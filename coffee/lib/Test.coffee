module.exports = class Test
  constructor: (@path, @fn) ->
  getFullName: ->
    @path.join " -> "
  toString: ->
    @getFullName()