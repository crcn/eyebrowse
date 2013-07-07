toarray = require "toarray"

available = 
  local  : require("./local"),
  remote : require("./remote")


class Factory

  ###
  ###

  getLaunchers: (options) ->

    launchers = []

    for type of options
      ops = toarray options[type]
      for o in ops
        clazz = available[type]
        launchers.push inst = new clazz o
        inst.name = type

    launchers

module.exports = new Factory()
