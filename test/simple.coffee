should = require 'should'
EventPlanner = require '../lib/event-planner'


plannerStateHolder = 'not set'

planner = new EventPlanner
planner.on 'start', -> plannerStateHolder = 'started'
planner.on 'end', -> plannerStateHolder = 'ended'


class MoreSeriousPlanner extends EventPlanner

  stateHolder: 'not set'

seriousPlanner = new MoreSeriousPlanner
seriousPlanner.on 'start to play', -> @stateHolder = 'started'
seriousPlanner.on 'after a long time', -> @stateHolder = 'ended'

anotherSeriousPlanner = new MoreSeriousPlanner
anotherSeriousPlanner.on 'start to play', (done) ->
  seriousPlanner.stateHolder.should.eql 'started'
  @stateHolder.should.eql 'not set'
  @stateHolder = 'started'

describe 'planned event', ->

  it 'should be triggered from EventPlanner instance', (done) ->
    plannerStateHolder.should.eql 'not set'
    planner.emit 'start'
    plannerStateHolder.should.eql 'started'
    planner.namespace.should.eql 'EventPlanner'

    setTimeout ->
      planner.emit 'end'
    , 1000

    setTimeout ->
      plannerStateHolder.should.eql 'ended'
      done()
    , 1200

  it 'should be triggered from subclass instance of EventEmitter', (done) ->
    seriousPlanner.emit 'start to play'
    anotherSeriousPlanner.emit 'start to play'

    setTimeout ->
      seriousPlanner.emit 'after a long time'
    , 2000

    setTimeout ->
      seriousPlanner.stateHolder.should.eql 'ended'
      done()
    , 2200


