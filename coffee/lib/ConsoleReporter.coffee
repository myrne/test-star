OutlineWriter = require "./OutlineWriter"

module.exports = class ConsoleReporter
  constructor: (@suite) ->
    @writer = new OutlineWriter console.log.bind console
    new SuiteConsoleReporter @writer, @suite

class SuiteConsoleReporter
  constructor: (@writer, @suite) ->
    new SubjectConsoleReporter @writer, subject for subject in @suite.subjects

    @suite.on "before-subjects", =>
      # @writer.write ""
      @writer.indent ""
      # console.log ""
      # console.log "GOING TO TEST:"
      # console.log "  " + test.toString() for test in tests
    
    @suite.on "after-subjects", =>
      @writer.dedent()
      # @writer.write ""
      @writer.write "Suite statistics:"
      @writer.indent()
      @writer.indent()
      @writer.write "#{name}: #{value}" for name, value of @suite.getStats()
      @writer.dedent()
      @writer.dedent()

class SubjectConsoleReporter
  constructor: (@writer, @subject) ->
    new TestConsoleReporter @writer, test for test in @subject.tests
    
    @subject.on "before-tests", =>
      # @writer.indent ""
      @writer.write "Testing #{@subject}"
      @writer.indent " "

    @subject.on "after-tests", =>
      @writer.write ""
      # @writer.dedent ""
      # @writer.write "Subject statistics:"
      # @writer.write "#{name}: #{value}" for name, value of @subject.getStats()
      @writer.dedent ""

class TestConsoleReporter
  constructor: (@writer, @test) ->
    @test.on "before-run", =>
      # @writer.write "Testing #{test.toString()}"
    
    @test.on "after-run", =>
      @writer.write @test.run.toString() 
      # return if @test.run.hasSucceeded()
      # @writer.write "The following #{@test.run.getErrors().length} errors occurred:"
      # @writer.indent "■"
      # @writer.write error.stack.toString() + "\n" for error in @test.run.getErrors()
      # @writer.dedent()