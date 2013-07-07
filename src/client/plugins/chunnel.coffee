chunnel = require "chunnel"
dns     = require "dns"
Url     = require "url"
winston = require "winston"

exports.client = (port = 9526) ->
  (launcher) ->
    launcher.pre "start", (next, options) ->
      return next() unless options.args.length

      url = options.args[0]
      unless ~url.indexOf "://"
        url = "http://" + url

      urlParts = Url.parse url

      dns.resolve4 urlParts.hostname, (err, addresses) ->

        # localhost shouldn't resolve
        return next() if not err and (addresses[0] isnt "127.0.0.1")

        client = chunnel.client.connect({
          proxy: url,
          domain: url,
          server: launcher.address.hostname + ":" + port
        })

        client.once "connected", next



exports.server = (port = 9526) ->
  chunnel.server({}).listen(port)

  
