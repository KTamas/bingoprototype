# require in the usual stuff
http = require 'http' 
express = require 'express' 
app = express.createServer()
app.configure ->
  app.use express.bodyParser() 
  app.use express.static "#{__dirname}/public"  
  app.use app.router 

# database
# see https://github.com/zefhemel/persistencejs/pull/42
persistence = require './persistence' 
PersistenceConfig = require('./persistence').StoreConfig
persistenceStore = PersistenceConfig.init persistence, adaptor: 'mysql'

persistenceStore.config persistence, 'localhost', 3306, 'bingo', 'root', '' 

session = persistenceStore.getSession()

Cell = persistence.define 'Cell', 
  selected: "BOOL" 
  value: "TEXT"

Sheet = persistence.define 'Sheet',
  name: "TEXT" 
  size: "INT"

Sheet.hasMany 'cells', Cell, 'sheets' 

app.get '/sync', (req, res) ->
  session.schemaSync (tx) ->
    res.write('Done')

app.get '/sheet', (req, res) ->
  Sheet.all(session).one (data) ->
    data.cells.list null, (results) ->
      res.send(results)
      #results.forEach (r) ->
        #console.log(r.value)
      #res.send('foo')

app.get '/sheet/:id', (req, res) ->
  console.log req 
  console.log '--------------------' 
  console.log res 
  # do even more stuff

app.post '/sheet', (req, res) ->
  sheet = new Sheet(session)
  for c in [0..24]
    cell = new Cell(session)
    cell.value = req.body[c].value
    cell.selected = false
    sheet.cells.add(cell)
  session.flush()
  res.send(req.body)


app.put '/sheet/:id', (req, res) ->
  # oh so many things to do

app.delete '/sheet/:id', (req, res) ->
  # I don't even know where to begin

app.listen(8080)
