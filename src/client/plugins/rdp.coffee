fs = require "fs"
exec = require("child_process").exec

module.exports = (launcher) ->
  launcher.pre "start", (next, options) ->

    rdpFilePath = "/tmp/eyebrowse.rdp"

    address = launcher.address.hostname
    # address = "ec2-54-224-41-224.compute-1.amazonaws.com"

    fs.writeFileSync rdpFilePath, "
auto connect:i:1\n
full address:s:#{address}\n
username:s:Administrator
    ", "utf8"

    exec(command = "sudo open \"/Applications/Remote Desktop Connection.app\" --args #{rdpFilePath}")

    console.log command

    next();