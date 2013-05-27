makeIndexJS = require "make-index-js"
{adapt} = require "faithful"
fs = require "fs"
writeFile = adapt fs.writeFile
getRelativePath = require("path").relative
getExtension = require("path").extname

{getFiles} = require "explorer"
getFiles = adapt getFiles

module.exports = (root) ->
  getFiles(root).then (paths) ->
    paths = (getRelativePath root, path for path in paths)
    paths = (path for path in paths when getExtension(path) is ".js")
    paths = (path for path in paths when path isnt "index.js")
    modules = {}
    modules[path.slice(0,-3)] = "./#{path}" for path in paths
    writeFile "#{root}/index.js", makeIndexJS modules