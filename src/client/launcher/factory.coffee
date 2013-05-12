available = 
  local  : require("./local"),
  remote : require("./remote")


class Factory

  ###
  ###

  getLaunchers: (options) ->

    launchers = []

    for type of options
      clazz = available[type]
      launchers.push new clazz options[type]

    launchers

module.exports = new Factory()
