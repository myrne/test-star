require "process-events-shim"
require("source-map-support").install()

stepthrough = require "stepthrough"
extract = require "../lib/extractTests"
ConsoleReporter = require "../lib/ConsoleReporter"

testIndex = require "../fixtures/test/index.js"

module.exports = run = ->
  loadEventually ->
    suite = extract testIndex
    reporter = new ConsoleReporter suite
    suite.test().then null, (err) -> 
      console.log err
      console.log err.stack

loadEventually = (fn) ->
  if window? and window.document
    window.document.addEventListener "DOMContentLoaded", fn
  else
    setImmediate fn