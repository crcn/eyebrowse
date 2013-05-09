async  = require "async"
comerr = require "comerr"

loaders = 
  directory : require("./directory")
  remote    : require("./remote")

class Loaders extends require("./base")

  ###
  ###

  constructor: (options) ->
    @_loaders = []

    for name of options
      continue if not (clazz = loaders[name])
      @_loaders.push new clazz(options[name])
      
  ###
  ###

  loadApplications: (callback) ->
    async.forEach @_loaders, ((loader, next) ->
      loader.loadApplications callback
    ), callback



module.exports = Loaders