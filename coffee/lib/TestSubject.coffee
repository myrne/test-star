now = require "performance-now"
{EventEmitter} = require "events"
{fulfill,forEachSeries,ensurePromise} = require "faithful"
{EventEmitter} = require "events"
TestRun = require "./TestRun"

module.exports = class TestSubject extends EventEmitter
  constructor: (@type, @name) ->
    @tests = []
  
  toString: ->
    "#{@type} #{@name}"
  
  toJSON: ->
    type: @type
    tests: @tests
    name: @name
  
  addTest: (test) ->
    @tests = [] unless @tests?
    @tests.push test
    
  test: ->
    @emit "before-tests", @
    @startTime = now()
    forEachSeries(@tests, (test) -> test.run()).then =>
      @endTime = now()
      @emit "after-tests"
      
  getStats: ->
    @stats = 
      total: @tests.length
      passed: 0
      failed: 0
      timeTaken: (@endTime - @startTime).toFixed 3
    for test in @tests
      if test.run.hasSucceeded() then @stats.passed++ else @stats.failed++
    @stats.isCorrect = @stats.failed is 0
    @stats