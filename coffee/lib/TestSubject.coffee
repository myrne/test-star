module.exports = class TestSubject
  constructor: (@type, @name) ->
    @tests = []
  
  toString: ->
    "#{@type} #{@name}"
  
  addTest: (test) ->
    @tests = [] unless @tests?
    @tests.push test

  getTests: ->
    if @tests? then @tests else []