{fulfill} = require "faithful"

module.exports =
  "component a":
    "does aa": -> true
    "does aaa": -> fulfill true
  "component b":
    "subcomponent bb":
      "does bbb": -> true
      "does bbbb": -> fulfill true