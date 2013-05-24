fs = require "fs"
resolvePath = require("path").resolve
makeHTML = require "make-document-html"

indexHTML = makeHTML
  title: "TestStar tests"
  jsPaths: ["test.js"]
  charset: "UTF-8"

indexPath = resolvePath __dirname, "../public/index.html"
fs.writeFileSync indexPath, indexHTML