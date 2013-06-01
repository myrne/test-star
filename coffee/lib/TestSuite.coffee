{EventEmitter} = require "events"
{forEachSeries} = require "faithful"
now = require "performance-now"

module.exports = class TestSuite extends EventEmitter
  constructor: ->
    @subjects = []
    @states = {}
  
  addSubject: (subject) ->
    @subjects.push subject
  
  addState: (name, state) ->
    @state[state.name] = state
    
  toJSON: ->
    subjects: @subjects
    states: @states
      
  test: ->
    @emit "before-subjects"
    @startTime = now()
    forEachSeries(@subjects, (subject) -> subject.test()).then =>
      @endTime = now()
      @emit "after-subjects"
  
  getStats: ->
    @stats = 
      totalSubjects: @subjects.length
      correct: 0
      incorrect: 0
      timeTaken: (@endTime - @startTime).toFixed 3
    for subject in @subjects
      if subject.getStats().isCorrect then @stats.correct++ else @stats.incorrect++
    @stats