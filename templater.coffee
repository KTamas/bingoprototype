fs = require 'fs'
path = require 'path'
_ = require 'underscore'
async = require 'async'

templates = {}
string = "templates = {};\n"
base_dir = ""

readiter = (item, callback) ->
  fs.readFile path.resolve(base_dir, item), 'utf-8', (err, data) ->
    if err then next(err)
    templates[path.basename(item, '.html')] = _.template(data)
    callback()

read_files_async = (directory) ->
  base_dir = directory
  (req, res, next) ->
    fs.readdir directory, (err, files) ->
      if err then next(err)
      async.forEach files, readiter, (err) ->
        if err then next(err)
        for key, value of templates
          string += "templates['#{key.toString()}'] =  #{value.toString()}\n"
    console.log string
    return next()

connect = require 'connect'
connect(
  connect.logger()
  read_files_async(__dirname + "/templates/")
).listen(3000)
