require("source-map-support").install()

stepthrough = require "stepthrough"

extract = require "../lib/extractTests"
writeIndexJS = require "../lib/writeIndexJS"

TestRunner = require "../lib/TestRunner"
ConsoleReporter = require "../lib/ConsoleReporter"

testsDir = __dirname + "/tests"

loadEventually = (fn) ->
  if window? and window.document
    window.document.addEventListener "DOMContentLoaded", fn
  else
    setImmediate fn

loadEventually ->
  writeIndexJS(testsDir)
    .then ->
      suite = extract require testsDir
      runner = new TestRunner
      reporter = new ConsoleReporter runner
      runner.testSubjects suite.subjects
    .then null, (err) -> 
      console.log err
      console.log err.stack