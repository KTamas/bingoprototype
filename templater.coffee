fs = require 'fs'
path = require 'path'
_ = require 'underscore'
require 'futures/forEachAsync'

#read_files = (folder) ->
  #templates = {}
  #dir = fs.readdirSync folder 
  #for file in dir
    #realfile = path.resolve(folder, file)
    #data = fs.readFileSync realfile, 'utf8'
    #templates[path.basename(file, '.html')] = _.template(data)
  #string = "templates = {}\n"
  #for key, value of templates
    #string += "templates['#{key.toString()}'] =  #{value.toString()}\n"
  #return string 

templates = {}
string = "templates = {};\n"

read_files_async = (directory) ->
  (req, res, next) ->
    fs.readdir directory, (err, files) ->
      if err
        next(err)
      else
        files.forEachAsync (futurenext, file) ->
          fs.readFile path.resolve(directory, file), 'utf8', (err, data) ->
            if err
              futurenext(err)
            else
              templates[path.basename(file, '.html')] = _.template(data)
              futurenext()
        .then () ->
          for key, value of templates
            string += "templates['#{key.toString()}'] =  #{value.toString()}\n"
    console.log string
    return next()

connect = require 'connect'
connect(
  connect.logger()
  read_files_async(__dirname + "/templates/")
).listen(3000)
