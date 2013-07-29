Browser = require("./browser")
Version = require("./version")
asyngleton = require "asyngleton"
utils = require("../../../utils")
cstep = require "cstep"
_ = require "underscore"
path = require "path"
fs = require "fs"
fiddle = require "fiddle"
winston = require "winston"


class Loader

  ###
  ###

  constructor: (@directory) ->
    @load()

  ###
  ###

  load: asyngleton cstep (callback) ->

    winston.info "load local #{@directory}"

    browsers = utils.readdir(@directory).map (dir) =>
      config = @_fixConfig dir, require dir
      new Browser dir, config, @_loadVersions(config)

    callback null, browsers
  

  ###
  ###

  _loadVersions: (config) ->

    versions = utils.readdir(config.directories.versions).map (verPath) =>
      versionParts = path.basename(verPath).split(".")
      versionParts.pop() # remove the extension
      version = versionParts.join(".")
      vc = { number: version, path: verPath, settingDirs: config.settingPaths[version] }
      for setter in config.versionConfigSetter
        setter vc

      new Version vc

    versions

  ###
  ###

  _fixConfig: (dir, config) ->

    config.directories = _.defaults config.directories or {}, { versions: "versions", settings: "settings" }
    config.settings = config.settings or {}

    for name of config.settings
      config.settings[name] = utils.fixPath config.settings[name]

    # fix the directory paths
    for dirname of config.directories
      config.directories[dirname] = path.join dir, config.directories[dirname]


    settingPaths = {}
    if fs.existsSync config.directories.settings
      for name in fs.readdirSync(config.directories.settings)
        versions = name.split(" ")
        for version in versions
          vp = path.join config.directories.settings, name
          #settingPaths[version] = {}
          settings = []
          for settingName of config.settings
            settings.push 
              from: path.join(vp, settingName)
              to: config.settings[settingName]

          settingPaths[version] = settings

            

    config.settingPaths = settingPaths


    config.versionConfigSetter = (config.versions or []).map (config) -> fiddle({$set:config.set}, config.test)


    config

module.exports = Loader