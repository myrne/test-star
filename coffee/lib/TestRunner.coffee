now = require "performance-now"
{fulfill,forEachSeries,ensurePromise} = require "faithful"
{EventEmitter} = require "events"

Test = require "./Test"
TestRun = require "./TestRun"

module.exports = class TestRunner
  constructor: (@options = {}) ->
    @emitter = new EventEmitter
    @options.timeout ?= 500
    
  on: (name, fn) ->
    @emitter.on name, fn
  
  emit: (name, value) ->
    @emitter.emit name, value
    
  runTests: (tests) ->
    @emit "before-tests", tests
    testRuns = (new TestRun test, @, @options for test in tests)
    startTime = now()
    forEachSeries(testRuns, (run) -> run.run()).then =>
      endTime = now()
      stats = 
        total: testRuns.length
        passed: 0
        failed: 0
        timeTaken: (endTime - startTime).toFixed 3
      for run in testRuns
        if run.hasSucceeded() then stats.passed++ else stats.failed++
      @emitter.emit "stats", stats
      
  testSubjects: (subjects) ->
    startTime = now()
    forEachSeries(subjects, @testSubject).then =>
      endTime = now()
      stats = 
        total: subjects.length
        correct: 0
        incorrect: 0
        timeTaken: (endTime - startTime).toFixed 3
      for subject in subjects 
        if subject.isValid then stats.correct++ else stats.incorrect++
      @emitter.emit "stats", stats
  
  testSubject: (subject) =>
    @emit "before-subject", subject
    startTime = now()
    testRuns = (new TestRun test, @, @options for test in subject.getTests())
    forEachSeries(testRuns, (run) -> run.run()).then =>
      endTime = now()
      stats = 
        total: testRuns.length
        passed: 0
        failed: 0
        timeTaken: (endTime - startTime).toFixed 3
      for run in testRuns
        if run.hasSucceeded() then stats.passed++ else stats.failed++
      subject.isCorrect = stats.failed is 0
      @emit "after-subject", subject, stats    