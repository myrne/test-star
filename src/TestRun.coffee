now = require "performance-now"
{makePromise,ensurePromise,fulfill,fail} = require "faithful"

module.exports = class TestRun
  constructor: (@test, @star) ->
    @hasRun = false
    @running = false
    @uncaughtExceptions = []
    
  getTimeTaken: ->
    (@endTime - @startTime).toFixed 3
  
  toString: ->
    if @hasRun
      "#{@test.toString()} #{@result.toString()} (#{@getTimeTaken()} ms)"
    else
      "#{@test.toString()} (not run yet)"
  
  run: ->
    @star.emit "before-test", @test
    @startTime = now()
    @running = true
    @runUntimed().then (result) =>
      @running = false
      @hasRun = true
      @endTime = now()
      @result = result
      @star.emit "after-test", @
      result
  
  handleUncaughtException: (err) =>
    @uncaughtExceptions.push err
  
  runUntimed: ->
    makePromise (cb) =>
      setImmediate =>
        process.removeAllListeners "uncaughtException"
        process.on "uncaughtException", @handleUncaughtException
        try
          result = @test.fn.call {}
        catch error
          return cb null, new FailResult error
        ensurePromise(result)
          .then (result) =>
            process.removeAllListeners "uncaughtException"
            if @uncaughtExceptions.length
              cb null, new FailResult null, @uncaughtExceptions
            else
              cb null, new PassResult
          .then null, (err) =>
            cb null, new FailResult err, @unchaughtExceptions
        
  hasSucceeded: ->
    @result.hasSucceeded()
      
  getErrors: ->
    @result.getErrors()
  
class PassResult
  constructor: ->
    
  toString: ->
    "passed"
  
  hasSucceeded: ->
    true
  
  getErrors: ->
    []

class FailResult
  constructor: (@error, @exceptions = []) ->
  
  toString: ->
    if @error 
      if @exceptions.length
        "failed: #{@error.toString()} and #{@exceptions.length} uncaught exceptions"
      else
        "failed: #{@error.toString()}"
    else
      "#{@exceptions.length} uncaught exceptions"

  hasSucceeded: ->
    false
  
  getErrors: ->
    if @error
      [@error].concat @exceptions
    else
      @exceptions