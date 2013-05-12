hooks = require "hooks"
_ = require "underscore"

class Launcher


  ###
  ###

  constructor: () ->
    _.extend @, hooks
    @hook "start", @start
    @hook "load", @load

  ###
  ###

  use: (module) -> module @


module.exports = Launcher