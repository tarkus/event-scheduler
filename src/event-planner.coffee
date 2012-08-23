{EventEmitter} = require 'events'

class EventPlanner extends EventEmitter


  constructor: (@namespace) ->
    @namespace ?= @constructor.toString().match(/function\s*(\w+)/)[1]
    super

  _addNamespace: (name) ->
    [@namespace, name].join '::'

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
    EventPlanner.__super__.emit.apply(@, arguments)

module.exports = EventPlanner
