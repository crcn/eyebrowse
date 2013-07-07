###
 synchronizes user interactions between browsers
###

exports.client = () =>
  (launcher) =>
    launcher.pre "start", (next, options) =>
      # TODO - replace launched site with new proxy