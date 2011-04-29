# **This** is gonna be fun!
#
# Yes, really.

#### Initialization
http = require 'http' 
express = require 'express' 
app = express.createServer()

# Express.js default configuration
app.configure ->
  app.use express.bodyParser() 
  app.use express.static "#{__dirname}/public"  
  app.use app.router 

# Database configuration. 
# See [this](https://github.com/zefhemel/persistencejs/pull/42) why we're using a fork of the original persistence.js library, also why the messy initialization process.
# This was the best ORM I could find for MySql and it's still kinda immature, but it'll work for now.
persistence = require './persistence' 
PersistenceConfig = require('./persistence').StoreConfig
persistenceStore = PersistenceConfig.init persistence, adaptor: 'mysql'
persistenceStore.config persistence, 'localhost', 3306, 'bingo', 'root', '' 

# Immature, yes, I have to pass around a session object.
session = persistenceStore.getSession()

# We have many sheets.
Sheet = persistence.define 'Sheet',
  name: "TEXT" 
  size: "INT"

# Sheets have `Sheet.size` cells.
Cell = persistence.define 'Cell', 
  value: "TEXT"


Sheet.hasMany 'cells', Cell, 'sheets' 

app.get '/sync', (req, res) ->
  session.schemaSync (tx) ->
    res.write('Done')

# just the first sheet for now
app.get '/sheet', (req, res) ->
  Sheet.all(session).one (data) ->
    data.cells.list null, (results) ->
      res.send(results)

app.get '/sheet/:id', (req, res) ->


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
