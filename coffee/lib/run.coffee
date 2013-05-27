require "process-events-shim"

stepthrough = require "stepthrough"
extract = require "../lib/extractTests"
TestRunner = require "../lib/TestRunner"
ConsoleReporter = require "../lib/ConsoleReporter"

testIndex = require "../fixtures/test/index.js"

module.exports = run = ->
  loadEventually ->
    suite = extract testIndex
    runner = new TestRunner
    reporter = new ConsoleReporter runner
    runner.testSubjects(suite.subjects)
      .then null, (err) -> 
        console.log err
        console.log err.stack

loadEventually = (fn) ->
  if window? and window.document
    window.document.addEventListener "DOMContentLoaded", fn
  else
    setImmediate fn