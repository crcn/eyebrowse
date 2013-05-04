path = require "path"
_    = require "underscore"
sift = require "sift"
fs = require "fs"
Application = require "./application"
Version = require "./version"

class AppLoader

  ###
  ###

  constructor: (@options) ->
    @name = options.name
    @processNames = options.process?.names or []

    # where do the settings go?
    @_settingPaths = options.settings or {}
    
    @_setupDirs()
    @_setupVersionSettings()
    @_setupVersionOptions()

  ###
  ###

  load: (callback) ->

    versions = []
    
    for fileName in fs.readdirSync @directories.versions

      continue if fileName is ".DS_Store"

      fileParts = fileName.split(".")
      fileParts.pop() # remove the extension

      version   = fileParts.join(".")

      options = _.extend({ 
        number: version, 
        settings: @_settingPaths,
        settingsDirectory: @_versionSettingPaths[version],
        path: path.join(@directories.versions, fileName)
      }, @_versionOptions(version))


      versions.push new Version options

    callback null, new Application @, @name, versions

  ###
  ###

  _setupDirs: () ->
    dirs = {}
    _.defaults dirs, @options.directories or {}, { versions: "versions", settings: "settings" }

    for dirName of dirs
      dirs[dirName] = path.join @options.directory, dirName

    @directories = dirs

  ###
  ###

  _setupVersionSettings: () ->

    settingPaths = {}

    try 
      for name in fs.readdirSync(@directories.settings)
        versions = name.split(" ")
        for version in versions
          settingPaths[version] = path.join @directories.settings, name
    catch e
      # doesn't exist

    @_versionSettingPaths = settingPaths

  ###
  ###

  _setupVersionOptions: () ->

    appOptions = []

    for options in @options.versions
      appOptions.push {
        test: sift(options.test),
        set: options.set
      }

    @versionOptions = appOptions
      
  ###
  ###

  _versionOptions: (version) ->

    for options in @versionOptions
      return options.set if options.test { version: version }

    return {}










module.exports = AppLoader