path = require "path"

class Version
  
  ###
  ###

  constructor: (@options) ->
    @number   = options.number
    @path     = options.path
    @settings = []

    for pt of options.settings
      @settings.push { from: path.join(options.settingsDirectory, pt), to: options.settings[pt].replace("~", process.env.HOME) }


module.exports = Version