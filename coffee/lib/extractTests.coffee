Test = require "./Test"
TestSubject = require "./TestSubject"

module.exports = extractTests = (index) ->
  suite = 
    subjects: []
    states: {}
  for path, module of index
    components = path.split "/"
    switch components.shift()
      when "behavior"
        subject = makeSubject components
        console.log subject.toString()
        subject.tests.push new Test subject, name, fn for name, fn of module
        suite.subjects.push subject
      when "state"
        path = components.join "/"
        suite.states[path] = new StateSpecification path, module
  suite

makeSubject = (components) ->
  switch components[0]
    when "classes"
      if components[2] is "constructor"
        new TestSubject "constructor", components[1]
      else
        new TestSubject "method", "#{components[1]}::#{components[2]}"
    when "functions"
      new TestSubject "function", components[1]