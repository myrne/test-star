OutlineWriter = require "./OutlineWriter"

module.exports = class ConsoleReporter
  constructor: (@star) ->
    @writer = new OutlineWriter console.log.bind console
    
    @star.on "before-tests", (tests) =>
      @writer.write ""
      @writer.indent "•"
      console.log ""
      console.log "GOING TO TEST:"
      console.log "  " + test.toString() for test in tests
    
    @star.on "before-subject", (subject) =>
      @writer.indent ""
      @writer.write ""
      @writer.write "Testing #{subject}"
      @writer.indent ""

    @star.on "after-subject", (subject) =>
      @writer.dedent ""
      @writer.dedent ""
      
    @star.on "before-test", (test) =>
      # console.log "Testing #{test.toString()}"
      
    @star.on "after-test", (testRun) =>
      @writer.write testRun.toString() 
      return if testRun.hasSucceeded()
      @writer.indent()
      @writer.write "The following #{testRun.getErrors().length} errors occurred:"
      @writer.indent "■"
      @writer.write error.stack.toString() + "\n" for error in testRun.getErrors()
      @writer.dedent()
      @writer.dedent()  
    
    @star.on "stats", (stats) =>
      # @writer.dedent()
      @writer.write ""
      @writer.write "Test statistics:"
      @writer.indent()
      @writer.indent()
      @writer.write "#{name}: #{value}" for name, value of stats
      @writer.dedent()
      @writer.dedent()