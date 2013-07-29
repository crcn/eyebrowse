path = require "path"
module.exports =
  Client : require "./client"
  Server : require "./server"
  utils  : require "./utils"
  path   : path.normalize(__dirname + "/../bin/eyebrowse")