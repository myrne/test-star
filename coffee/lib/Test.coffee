module.exports = class Test
  constructor: (@subject, @name, @fn) ->

  toString: ->
    "#{@subject} #{@name}"