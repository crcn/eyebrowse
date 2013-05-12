fs      = require "fs"
path    = require "path"
utils   = require "../../../utils"
cstep   = require "cstep"
async   = require "async"
Browser = require "./browser"
sift    = require "sift"
Loader  = require("./loader")
asyngleton = require "asyngleton"

class LocalLauncher extends require("../base")

  ###
  ###

  constructor: (path) ->
    super()
    @directory = utils.fixPath path
    @_loader = new Loader @directory
    @_listenOnExit()

  ###
  ###


  start: (options, callback) ->

    @load () =>
      browser = sift({ name: options.name }, @browsers).pop()

      if not browser
        return callback new Error "browser #{options.name} does not exist"

      browser.start options, callback


  ###
  ###

  load: asyngleton cstep (callback) ->
    @_loader.load (err, @browsers) => callback(err)

  ###
  ###

  _listenOnExit: () ->
    process.once "SIGINT", () =>
      for app in @browsers
        app.stop()
      process.exit()





module.exports = LocalLauncher