# most zárd be, különben meglátod, hogy készül a parizer
_ = require 'underscore'
fs = require 'fs'
path = require 'path'


read_files = (folder) ->
  templates = {}
  dir = fs.readdirSync folder 
  for file in dir
    realfile = path.resolve(folder, file)
    data = fs.readFileSync realfile, 'utf8'
    templates[path.basename(file, '.html')] = _.template(data)
  string = "templates = {}\n"
  for key, value of templates
    string += "templates['#{key.toString()}'] =  #{value.toString()}\n"
  return string 

templates = read_files(__dirname + "/templates/")
fs.writeFileSync "#{__dirname}/public/templates.js", templates, "utf8"

