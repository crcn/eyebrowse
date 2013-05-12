_         = require "underscore"
fs        = require "fs"
path      = require "path"
async     = require "async"
utils     = require "../../../utils"
AppLoader = require "./appLoader"
outcome   = require "outcome"

class DirectoryLoader extends require("../base")

  ###
  ###

  constructor: (directory) ->
    @_applications = {}
    @directory = directory.replace("~", process.env.HOME)
  
  ###
  ###

  loadApplications: (callback) ->

    apps = []

    for appName in fs.readdirSync @directory

      continue if appName is ".DS_Store"

      dir = path.join @directory, appName
      options = require dir
      apps.push new AppLoader(_.extend({ directory: dir, name: appName }, options))

    async.map apps, ((app, next) ->
      app.load next
    ), callback








module.exports = DirectoryLoader