hooks = require "hooks"
_ = require "underscore"

class Launcher


  ###
  ###

  constructor: () ->
    _.extend @, hooks
    @hook "start", @start
    @hook "load", @load
    @hook "test", @test

  ###
  ###

  start : () -> 
  load  : () -> 
  test  : () -> 

  ###
  ###

  use: (module) -> module @


module.exports = Launcher