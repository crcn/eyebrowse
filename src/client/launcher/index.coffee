async      = require "async"
flatten    = require "flatten"
factory    = require "./factory"
outcome    = require "outcome"
toarray    = require "toarray"

###
###

class BrowserLauncher

  ###
  ###

  constructor: (config) ->
    @_launchers = factory.getLaunchers config.transports

    if config.plugin
      for transportType of config.plugin
        transportPluginConfig = config.plugin[transportType]
        for name of transportPluginConfig
          cfg = {}
          cfg[transportType] = BrowserLauncher.plugins[name]?.client(transportPluginConfig[name])
          @use cfg


  ###
  ###

  use: (modules) ->
    for launcher in @_launchers 
      if typeof modules is "function"
        launcher.use modules
      else if modules[launcher.name]
        mods = toarray modules[launcher.name]
        for m in mods
          launcher.use m

  ###
  ###

  test: (options, callback) ->
    ops = @_fixOptions options
    async.eachSeries @_launchers, ((launcher, next) ->
      launcher.test ops, (err) ->
        return next() if err?
        callback null, launcher
    ), () ->
      callback new Error "#{ops.name}@#{ops.version} does not exist"

  ###
  ###

  getBrowser: (options, callback) ->
    ops = @_fixOptions options
    @test options, (err, launcher) ->
      return callback(err) unless launcher
      launcher.test ops, callback


  ###
   starts a browser
  ###

  start: (options, callback = (() ->)) ->

    ops = @_fixOptions options

    @test ops, (err, launcher) ->
      return callback(err) if err?
      launcher.start ops, () ->
        console.log arguments
        callback arguments...



  ###
   lists available browsers
  ###

  listBrowsers: (callback) ->
    async.map @_launchers, ((launcher, next) ->
      launcher.listBrowsers outcome.e(next).s (browsers) =>
        next null, browsers.map (browser) =>
          browser.type = launcher.label or launcher.name
          browser
    ), outcome.e(callback).s (result) ->
      callback null, flatten result


  ###
  ###

  _fixOptions: (options) ->

    nameParts = options.name.split "@"

    name    : nameParts.shift(),
    version : options.version or nameParts.shift() or "latest"
    args    : options.args or []
    

  ###
  ###

  @plugins: require("../plugins")



module.exports = BrowserLauncher

