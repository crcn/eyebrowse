fs   = require "fs"
path = require "path"

for file in fs.readdirSync __dirname
  continue if /\.DS_Store|index/.test file
  fp = path.basename(file).split(".")
  name = fp.shift()
  exports[name] = require __dirname + "/" + name

