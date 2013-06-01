module.exports = class OutlineWriter
  constructor: (@writeLine) ->
    @formatters = [new ItemFormatter]
  
  write: (string) ->
    @writeLine @formatters[0].format string
  
  indent: (bullet = "") ->
    @formatters.unshift new ItemFormatter @getCurrentIndent() + 1, bullet
  
  dedent: ->
    @formatters.shift()
  
  getLevel: ->
    @formatters.length - 1
    
  getCurrentIndent: ->
    indent  = 0
    indent += formatter.totalIndent for formatter in @formatters
    indent

class ItemFormatter
  constructor: (@indent = 0, @bullet = "") ->
    @totalIndent = if @bullet? then @bullet.length + @indent else @indent
    @padding = makePadding @indent
    @firstPrefix = if @bullet? then @padding + @bullet + " " else @padding
    @furtherPrefix = makePadding @totalIndent

  format: (string) ->
    formatted = []
    lines = string.split "\n"
    return unless lines.length
    formatted.push @firstPrefix + lines.shift()
    formatted.push @furtherPrefix + line for line in lines
    formatted.join "\n"
  
makePadding = (n) ->
  (" " for i in [0...n]).join("")