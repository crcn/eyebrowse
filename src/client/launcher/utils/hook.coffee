async = require "async"
type  = require "type-component"

setupHooks = (target) ->

  target.__hooks = {}

  target.pre = (property, fn) ->
    target.__hooks[property].pre.push fn


module.exports = (target, property) ->
  
  unless target.__hooks
    setupHooks target

  target.__hooks[property] = hooks = {
    call: target[property],
    pre: [],
    post: []
  }

  target[property] = () ->
    args = Array.prototype.slice.call arguments, 0

    if type(args[args.length - 1]) is "function"
      next = args[args.length - 1]
    else
      next = () ->

    async.eachSeries hooks.pre, ((fn, next) ->
      fn.apply target, [next].concat(args)
    ), (err) ->
      return next(err) if err?
      hooks.call.apply target, args
