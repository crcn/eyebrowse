dnode = require "dnode"
cstep = require "cstep"
Url   = require "url"
asyngleton = require "asyngleton"
winston = require "winston"

class RemoteLauncher extends require("../base")

  ###
  ###

  constructor: (address) ->
    super()

    unless ~address.indexOf("://")
      address = "http://" + address

    @address = Url.parse address

    @label = @address.hostname

  ###
  ###

  load: asyngleton cstep (callback) ->
    d = dnode()
    d.on "remote", (@client) =>
      @client.listBrowsers (err, @browsers) => callback arguments...

    winston.info "load remote #{@address.hostname}:#{@address.port}"
    d.connect(@address.port, @address.hostname)

  ###
  ###

  listBrowsers: (callback) => @load () => callback null, @browsers

  ###
  ###

  test: (options, callback) ->
    @load () =>
      @client.test options, callback

  ###
  ###

  start: (options, callback) ->
    @load () => 
      @client.start options, callback




module.exports = RemoteLauncher