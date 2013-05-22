module.exports = class TestResult
  constructor: (@test, @passed) ->
    
  toString: ->
    "#{@test} #{@resultString()}."
    
  resultString: ->
    if @passed then "passed" else "failed"
    