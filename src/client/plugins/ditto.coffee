###
 synchronizes user interactions between browsers
###

exports.client = () =>
  (launcher) =>
    launcher.pre "start", (next, options) =>
      # TODO - replace launched site with new proxy
      # TODO - start ditto server to listen for changes in local files