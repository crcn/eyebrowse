hook = require "../utils/hook"
_ = require "underscore"

class Launcher


  ###
  ###

  constructor: () ->
    hook @, "start"
    hook @, "load"

  ###
  ###

  start : () -> 
  load  : () -> 
  test  : () -> 

  ###
  ###

  use: (module) -> module @


module.exports = Launcher