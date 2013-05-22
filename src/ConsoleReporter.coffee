module.exports = class ConsoleReporter
  constructor: (@star) ->
    @star.on "before-tests", (tests) ->
      console.log ""
      # console.log "GOING TO TEST:"
      # console.log "  " + test.toString() for test in tests
    
    @star.on "before-test", (test) ->
      # console.log "Testing #{test.toString()}"
      
    @star.on "after-test", (testRun) ->
      console.log testRun.toString()
    
    @star.on "stats", (stats) ->
      console.log ""
      console.log "STATS:"
      console.log "#{name}: #{value}" for name, value of stats