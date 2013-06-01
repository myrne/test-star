require("source-map-support").install()
require("mocha-as-promised")()

assert = require "assert"

star = require "../../"
testIndex = require "../fixtures/test/index.js"

describe "TestStar", ->
  it "works", ->
    suite = star.extractTests testIndex
    suite.test().then ->
      stats = suite.getStats()
      assert.equal stats.totalSubjects, 5
      assert.equal stats.correct, 2
      assert.equal stats.incorrect, 3
      assert.equal stats.ok, false
      assert stats.timeTaken > 1900
      assert stats.timeTaken < 2000
