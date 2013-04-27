fs = require "fs"
path = require "path"
drivers = require "./drivers"

class DirectoryLoader extends require("../base")

  ###
  ###

  constructor: (directory) ->
    @_applications = {}
    @directory = directory.replace("~", process.env.HOME)
  
  ###
  ###

  loadApplications: (callback) ->


    # temporarily register base classes so require() driver can extend them
    @_registerGlobal()

    for appName in fs.readdirSync @directory
      @_applications[appName] = require path.join @directory, appName

    # remove the globals
    @_unregisterGlobal()

    callback()

  ###
  ###

  start: (options, callback) ->
    app = @_applications[options.name]


  ###
  ###

  _registerGlobal: () ->
    for name of drivers
      global[name] = drivers[name]


  ###
  ###

  _unregisterGlobal: () ->
    for name of drivers
      delete global[name]






module.exports = DirectoryLoader