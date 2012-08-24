should = require 'should'
EventScheduler = require '../lib/event-scheduler'


schedulerStateHolder = 'not set'

scheduler = new EventScheduler
scheduler.on 'start', -> schedulerStateHolder = 'started'
scheduler.on 'end', -> schedulerStateHolder = 'ended'


class MoreSeriousScheduler extends EventScheduler

  stateHolder: 'not set'

seriousScheduler = new MoreSeriousScheduler
seriousScheduler.on 'start to play', -> @stateHolder = 'started'
seriousScheduler.on 'after a long time', -> @stateHolder = 'ended'

anotherSeriousScheduler = new MoreSeriousScheduler
anotherSeriousScheduler.on 'start to play', (done) ->
  seriousScheduler.stateHolder.should.eql 'started'
  @stateHolder.should.eql 'not set'
  @stateHolder = 'started'

describe 'planned event', ->

  it 'should be triggered from EventScheduler instance', (done) ->
    schedulerStateHolder.should.eql 'not set'
    scheduler.emit 'start'
    schedulerStateHolder.should.eql 'started'
    scheduler.namespace.should.eql 'EventScheduler'

    setTimeout ->
      scheduler.emit 'end'
    , 1000

    setTimeout ->
      schedulerStateHolder.should.eql 'ended'
      done()
    , 1200

  it 'should be triggered from subclass instance of EventEmitter', (done) ->
    seriousScheduler.emit 'start to play'
    anotherSeriousScheduler.emit 'start to play'

    setTimeout ->
      seriousScheduler.emit 'after a long time'
    , 2000

    setTimeout ->
      seriousScheduler.stateHolder.should.eql 'ended'
      done()
    , 2200


