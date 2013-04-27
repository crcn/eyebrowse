require "coffee-script"

cstep  = require "cstep"
Loader = require "./loaders"


class APuppet

  ###
  ###

  constructor: (options) ->
    @_loader = new Loader options
    @load()

  ###
  ###

  start: cstep (options, callback) -> loader.start options, callback

  ###
  ###

  load: cstep (callback) -> 
    @_loader.loadApplications callback



module.exports = (options) -> new APuppet options