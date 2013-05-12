Client = require "../client"
dnode  = require "dnode"
dsync  = require "dsync"

class Server

  ###
  ###

  constructor: (config) ->
    @client = new Client config

  ###
  ###

  listen: (port) ->
    console.log "listening on port #{port}"
    dnode(dsync(@client)).listen(port)
    @

  ###
  ###

  use: () -> @client.use arguments...



module.exports = Server