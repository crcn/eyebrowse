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
   starts a browser
  ###

  start: (options, callback = (() ->)) ->

    ops = @_fixOptions options

    async.eachSeries @_launchers, ((launcher, next) ->
      launcher.start ops, (err) ->
        return callback arguments... unless err?
        next() 
    ), () ->
      callback new Error "#{ops.name}@#{ops.version} does not exist"



  ###
   lists available browsers
  ###

  listBrowsers: (callback) ->
    async.map @_launchers, ((launcher, next) ->
      launcher.listBrowsers next
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

