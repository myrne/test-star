now = require "performance-now"
{fulfill,forEachSeries,ensurePromise} = require "faithful"
{EventEmitter} = require "events"

Test = require "./Test"
TestRun = require "./TestRun"

ConsoleReporter = require "./ConsoleReporter"

module.exports = class TestStar
  constructor: (@options = {}) ->
    @emitter = new EventEmitter
    @reporter = new ConsoleReporter @
    @runOptions =
      timeout: @options.timeout or 1900
  
  on: (name, fn) ->
    @emitter.on name, fn
  
  emit: (name, value) ->
    @emitter.emit name, value
  
  run: (testModules) ->
    @runModule testModule for testModule in testModules
  
  runModule: (testModule) ->
    @runTests @extractTests testModule
  
  runTests: (tests) ->
    @emit "before-tests", tests
    testRuns = (new TestRun test, @, @runOptions for test in tests)
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