{fail} = require "faithful"

module.exports =
  "does cc": -> throw new Error "Regular thrown error."
  "does ccc": -> fail new Error "Failed promise."
  