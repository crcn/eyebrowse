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

  test: (options, callback) -> 
    @load () =>
      browser = sift({ name: options.name }, @browsers).pop()

      if not browser
        return callback new Error "browser #{options.name} does not exist"

      browser.test options, (err) ->
        return callback(err) if err?
        callback null, browser

  ###
  ###


  start: (options, callback) ->
    @test options, (err, browser) =>
      return callback(err) if err?
      browser.start options, (err) ->
        return callback(err) if err?
        callback null, browser

  ###
  ###

  load: asyngleton cstep (callback) ->
    @_loader.load (err, @browsers) => callback(err)


  ###
  ###

  listBrowsers: (callback) -> @load () => callback null, @browsers

  ###
  ###

  _listenOnExit: () ->
    process.once "SIGINT", () =>
      for app in @browsers
        app.stop()
      process.exit()





module.exports = LocalLauncher