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

  start : () -> 
  load  : () -> 
  test  : () -> 

  ###
  ###

  use: (module) -> module @


module.exports = Launcher