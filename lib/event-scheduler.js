// Generated by CoffeeScript 1.3.3
(function() {
  var EventEmitter, EventScheduler, _schedulers,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  EventEmitter = require('events').EventEmitter;

  _schedulers = [];

  EventScheduler = (function(_super) {

    __extends(EventScheduler, _super);

    function EventScheduler(namespace) {
      var _ref;
      this.namespace = namespace;
      _schedulers.push(this);
      this._idx = _schedulers.indexOf(this);
      if ((_ref = this.namespace) == null) {
        this.namespace = this.constructor.toString().match(/function\s*(\w+)/)[1];
      }
      EventScheduler.__super__.constructor.apply(this, arguments);
    }

    EventScheduler.prototype._addNamespace = function(name) {
      return [this._idx, this.namespace, name].join('::');
    };

    EventScheduler.prototype.addListener = function(event, listener) {
      event = this._addNamespace(event);
      return EventScheduler.__super__.addListener.call(this, event, listener);
    };

    EventScheduler.prototype.on = function(event, listener) {
      event = this._addNamespace(event);
      return EventScheduler.__super__.on.call(this, event, listener);
    };

    EventScheduler.prototype.once = function(event, listener) {
      event = this._addNamespace(event);
      return EventScheduler.__super__.once.call(this, event, listener);
    };

    EventScheduler.prototype.removeListener = function(event, listener) {
      event = this._addNamespace(event);
      return EventScheduler.__super__.removeListener.call(this, event, listener);
    };

    EventScheduler.prototype.removeAllListeners = function(event) {
      var idx, name, _i, _len;
      if (typeof event === 'string') {
        event = [event];
      }
      for (name = _i = 0, _len = event.length; _i < _len; name = ++_i) {
        idx = event[name];
        event[idx] = this._addNamespace(name);
      }
      return EventScheduler.__super__.removeAllListeners.call(this, event);
    };

    EventScheduler.prototype.listeners = function(event) {
      event = this._addNamespace(event);
      return EventScheduler.__super__.listeners.call(this, event);
    };

    EventScheduler.prototype.emit = function() {
      arguments[0] = this._addNamespace(arguments[0]);
      return EventScheduler.__super__.emit.apply(this, arguments);
    };

    return EventScheduler;

  })(EventEmitter);

  module.exports = EventScheduler;

}).call(this);