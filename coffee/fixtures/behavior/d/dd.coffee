module.exports = 
  "does ddd": ->
    setImmediate ->
      throw new Error "This error should be caught, somewhere."
    true
  "does dddd": ->
    setImmediate ->
      throw new Error "This error should be caught, somewhere."
    setImmediate ->
      throw new Error "Another error that should be caught."
    setImmediate ->
      throw new Error "Yet another error that should be caught."
    true      
  