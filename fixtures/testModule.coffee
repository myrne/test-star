{fulfill,fail} = require "faithful"

module.exports =
  "component a":
    "does aa": -> true
    "does aaa": -> fulfill true
  "component b":
    "subcomponent bb":
      "does bbb": -> true
      "does bbbb": -> fulfill true
  "component c":
    "does cc": -> throw new Error "Regular thrown error."
    "does ccc": -> fail new Error "Failed promise."
  "component d":
    "does dd": ->
      setImmediate ->
        throw new Error "This error should be caught, somewhere."
      true
    "does ddd": ->
      setImmediate ->
        throw new Error "This error should be caught, somewhere."
      setImmediate ->
        throw new Error "Another error that should be caught."
      setImmediate ->
        throw new Error "Yet another error that should be caught."
      true      