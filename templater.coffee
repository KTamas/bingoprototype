fs = require 'fs'
path = require 'path'
_ = require 'underscore'
async = require 'async'

templates = {}
base_dir = ""

readiter = (item, callback) ->
  fs.readFile path.resolve(base_dir, item), 'utf-8', (err, data) ->
    if err
      next err 
    else
      templates[path.basename(item, '.html')] = _.template(data)
      callback()

read_files_async = (directory) ->
  base_dir = directory
  (req, res, next) ->
    fs.readdir directory, (err, files) ->
      if err
        next err  
      else
        async.forEach files, readiter, (err) ->
          if err
            next err 
          else
            string = "templates = {};\n"
            for key, value of templates
              string += "templates['#{key.toString()}'] = #{value.toString()}\n"
            fs.writeFile __dirname + "/public/templates.js", string, 'utf-8', (err) ->
              next err

connect = require 'connect'
connect(
  read_files_async(__dirname + "/templates/")
).listen(3000)
