now = require "performance-now"
{fulfill,forEachSeries,ensurePromise} = require "faithful"
{EventEmitter} = require "events"

Test = require "./Test"
TestResult = require "./TestResult"
TestRun = require "./TestRun"

ConsoleReporter = require "./ConsoleReporter"

module.exports = class TestStar
  constructor: (@options) ->
    @emitter = new EventEmitter
    @reporter = new ConsoleReporter @
  
  on: (name, fn) ->
    @emitter.on name, fn
  
  emit: (name, value) ->
    @emitter.emit name, value
  
  run: (testModules) ->
    @runModule testModule for testModule in testModules
  
  runModule: (testModule) ->
    tests = @extractTests testModule
    @emit "before-tests", tests
    startTime = now()
    @runTests(tests).then (runs) =>
      endTime = now()
      stats = 
        total: runs.length
        passed: 0
        failed: 0
        timeTaken: (endTime - startTime).toFixed 3
      for run in runs
        if run.result.passed then stats.passed++ else stats.failed++
      @emitter.emit "stats", stats

  runTests: (tests) ->
    startTime = now()
    runs = []
    forEachSeries tests, @runTest,
      handleResult: (result, i) =>
        run = new TestRun result, startTime, now()
        runs.push run
        startTime = now()
        @emit "after-test", run
      getFinalValue: ->
        runs

  runTest: (test) =>
    @emit "before-test", test
    try
      result = test.fn.call {}
    catch error
      return fulfill new TestResult test, false, error
    ensurePromise(result)
      .then (result) ->
        new TestResult test, true
      .then null, (err) ->
        new TestResult test, false, err

  extractTests: (obj, path = []) ->
    tests = []
    for key, value of obj
      childPath = path.concat [key]
      switch typeof value
        when "function"
          tests.push new Test childPath, value
        when "object"
          tests = tests.concat @extractTests value, childPath
        else
          throw new Error "Wrong type of value (#{typeof value}})"
    tests