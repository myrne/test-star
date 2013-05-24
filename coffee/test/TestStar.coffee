require("source-map-support").install()
require("mocha-as-promised")()

TestStar = require "../../"
star = new TestStar

describe "TestStar", ->
  describe "runModule", ->
    it "runs a test module", ->
      star.runModule require "../fixtures/testModule"