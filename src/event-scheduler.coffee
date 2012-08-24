{EventEmitter} = require 'events'

_schedulers = []

class EventScheduler extends EventEmitter

  constructor: (@namespace) ->
    _schedulers.push @
    @_idx = _schedulers.indexOf @
    @namespace ?= @constructor.toString().match(/function\s*(\w+)/)[1]
    super

  _addNamespace: (name) ->
    [@_idx, @namespace, name].join '::'

  addListener: (event, listener) ->
    event = @_addNamespace event
    super event, listener

  on: (event, listener) ->
    event = @_addNamespace event
    super event, listener

  once: (event, listener) ->
    event = @_addNamespace event
    super event, listener

  removeListener: (event, listener) ->
    event = @_addNamespace event
    super event, listener

  removeAllListeners: (event) ->
    event = [ event ] if typeof event is 'string'
    event[idx] = @_addNamespace name for idx, name in event
    super event

  listeners: (event) ->
    event = @_addNamespace event
    super event

  emit: () ->
    arguments[0] = @_addNamespace arguments[0]
    EventScheduler.__super__.emit.apply(@, arguments)

module.exports = EventScheduler
