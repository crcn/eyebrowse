path = require "path"

class Version
  
  ###
  ###

  constructor: (@options) ->
    @number      = options.number
    @path        = options.path
    @settings    = options.settingDirs or []

module.exports = Version