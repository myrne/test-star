TestStar = require "../../"
testModule = require "./single/testModule"

return unless window
return unless window.document

global.abc = true

window.document.addEventListener "DOMContentLoaded", ->
  star = new TestStar
  star.runModule testModule