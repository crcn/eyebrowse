async      = require "async"
flatten    = require "flatten"
factory    = require "./factory"
outcome    = require "outcome"

###
###

class BrowserLauncher

  ###
  ###

  constructor: (options) ->
    @_launchers = factory.getLaunchers options

  ###
  ###

  use: (modules) ->
    for launcher in @_launchers 
      if typeof modules is "function"
        launcher.use modules
      else if modules[launcher.name]
        launcher.use modules[launcher.name]

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
   starts a browser
  ###

  start: (options, callback = (() ->)) ->

    ops = @_fixOptions options

    @test ops, (err, launcher) ->
      return callback(err) if err?
      launcher.start ops, (err) ->
        return callback arguments... unless err?
        next()

  ###
   lists available browsers
  ###

  listBrowsers: (callback) ->
    async.map @_launchers, ((launcher, next) ->
      launcher.listBrowsers outcome.e(next).s (browsers) =>
        next null, browsers.map (browser) =>
          browser.type = launcher.name
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
    




module.exports = BrowserLauncher

