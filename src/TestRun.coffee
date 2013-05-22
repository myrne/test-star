module.exports = class TestRun
  constructor: (@result, @startTime, @endTime) ->
  
  getTimeTaken: ->
    (@endTime - @startTime).toFixed 3
  
  toString: ->
    "#{@result.toString()} (#{@getTimeTaken()} ms)"