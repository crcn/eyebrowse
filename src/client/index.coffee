require "coffee-script"

cstep   = require "cstep"
Loader  = require "./loaders"
sift    = require "sift"
outcome = require "outcome"
comerr  = require "comerr"
async   = require "async"
_       = require "underscore"


class Client

  ###
  ###

  constructor: (options) ->
    @_loader = new Loader options
    @load()

    @_listenOnExit()

  ###
   Starts the application
  ###

  start: (options, callback) -> 

    # fix the options
    ops = @_parseOptions options

    # first the application be the name
    @findApp ops.name, outcome.e(callback).s (app) ->
      app.start { version: ops.version, args: options.args }, callback

  ###
  ###

  findApp: cstep (appName, callback) ->
    
    app = sift({ name: appName }, @applications).shift()

    if app
      return callback null, app

    callback new comerr.NotFound "application not found"

  ###
  ###

  getAvailableBrowsers: cstep (callback) ->

    browsers = []

    async.forEach @applications, ((app, next) ->
      app.getVersions outcome.e(next).s (versions) ->
        browsers.push { name: app.name, versions: versions }
        next()
      
    ), outcome.e(callback).s (v) -> callback null, browsers



  ###
  ###

  _parseOptions: (options) ->
    nameParts = options.name.split("@")
    _.extend {}, options, { name: nameParts.shift(), version: nameParts.shift(), args: options.args or [] }

  ###
  ###

  load: cstep (callback) -> 
    @_loader.loadApplications outcome.e(callback).s (@applications) =>
      callback()

  ###
  ###

  _listenOnExit: () ->
    process.on "SIGINT", () =>
      for app in @applications
        app.stop()


module.exports = Client