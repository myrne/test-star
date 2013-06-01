{EventEmitter} = require "events"
TestRun = require "./TestRun"

module.exports = class Test extends EventEmitter
  constructor: (@subject, @name, @fn) ->
    @emitter = new EventEmitter
    
  toString: ->
    "#{@subject} #{@name}"
  
  toJSON: ->
    subjectId: @subject.toString()
    name: @name
  
  run: ->
    @emit "before-run"
    @run = new TestRun @
    @run.run().then (result) => 
      @result = result
      @emit "after-run"