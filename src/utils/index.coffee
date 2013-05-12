fs       = require "fs"
async    = require "async"
path     = require "path"
exec     = require("child_process").exec
platform = require("os").platform()


exports.fixPath = (path) ->   
  path.
  replace(/^\./, process.cwd()).
  replace(/^~/, process.env.HOME or process.env.HOMEPATH)



exports.readdir = (dir) -> fs.readdirSync(dir).filter((name) ->
    name isnt ".DS_Store"
  ).map((name) ->
    path.join(dir, name)
  )


exports.killProcesses = (processNames, callback) ->
  async.forEach processNames, ((name, next) ->

    if /^win/.test platform
      command = "taskkill /F /IM #{name}"
    else
      command = "killall \"#{name}\" QUIT -9"

    exports.logger.log command 


    # need to give app time to die - some processes stay open for a bit
    exec command, () ->   
      setTimeout callback, 1000

  ), callback

if not process.env.APUPPET_LOG
  exports.logger = {
    warn: () ->
    error: () ->
    log: () ->
  }
else
  exports.logger = console