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
      launchers.push inst = new clazz options[type]
      inst.name = type

    launchers

module.exports = new Factory()
