events  = require "events"
utils   = require "../../utils"
exec    = require("child_process").exec
cstep   = require "cstep"
platform = require("os").platform
outcome = require "outcome"
sift = require "sift"
comerr = require "comerr"
stepc = require "stepc"
dirmr = require "dirmr"
rmdir = require "rmdir"
async = require "async"
fs = require "fs"

class Application extends events.EventEmitter

  ###
  ###

  constructor: (loader, @name, @versions) ->
    @processNames = loader.processNames
    

  ###
  ###

  start: (options, callback) ->
    o = outcome.e callback
    self = @


    stepc.async(

      # stop the current version
      (() ->
        self.killAll @
      ),

      # find the new version
      (o.s () ->
        self.findVersion options.version, @
      ),

      # copy the settings
      (o.s (version) ->
        self.currentVersion = version
        self._copySettingsToSys @
      ),

      # start it 
      (o.s () ->
        if /win/.test(platform)
          command = "start /WAIT \"\" \"#{self.currentVersion.path}\" #{options.args.join(" ")}"
        else
          command = "open \"#{self.currentVersion.path}\" -W --args #{options.args.join(" ")}"


        utils.logger.log command
        self._process = exec command
        self._process.on "exit", self._onExit
      )
    )

  ###
  ###

  findVersion: (version, callback) ->

    version = sift({ number: version }, @versions).shift()

    if version
      return callback null, version

    callback new comerr.NotFound "#{@name} version #{@version} doesn't exist"

  ###
  ###

  killAll: cstep (callback) ->
    utils.killProcesses @processNames, callback

  ###
  ###

  stop: (callback = (() ->)) ->
    return callback() if not @_process
    @killAll callback

  ###
  ###

  _copySettingsToSys: (callback) ->
    @cleanup outcome.e(callback).s () =>
      async.forEach @currentVersion.settings, ((setting, next) ->
        o = outcome.e next
        utils.logger.log "cp #{setting.from} -> #{setting.to}"
        dirmr([setting.from]).join(setting.to).complete(next)
      ), callback

  ###
  ###

  _copySettingsFromSys: cstep (callback) ->

  ###
  ###

  cleanup: cstep (callback) ->

    async.forEach @currentVersion.settings, ((setting, next) ->
      return next() if not fs.existsSync setting.to
      utils.logger.log "rm -rf #{setting.to}"
      rmdir setting.to, next
    ), callback

  ###
  ###

  _onExit: () =>
    utils.logger.log "#{@name}@#{@currentVersion.number} has exited, cleaning up..."
    @running = false
    @emit "stop"



module.exports = Application