dnode = require "dnode"
cstep = require "cstep"
Url   = require "url"
asyngleton = require "asyngleton"

class RemoteLauncher extends require("../base")

  ###
  ###

  constructor: (address) ->
    super()

    unless ~address.indexOf("://")
      address = "http://" + address

    @address = Url.parse address


  ###
  ###

  load: asyngleton cstep (callback) ->
    d = dnode()
    d.on "remote", (@client) =>
      callback()
    d.connect(@address.port, @address.hostname)

  ###
  ###

  start: (options, callback) ->
    @load () => 
      @client.start options, callback




module.exports = RemoteLauncher