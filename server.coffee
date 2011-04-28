http = require('http')
express = require('express')
# https://github.com/zefhemel/persistencejs/pull/42
persistence = require('./persistence')
PersistenceConfig = require('./persistence').StoreConfig;
persistenceStore = PersistenceConfig.init(persistence, {
  adaptor: 'mysql',
})

persistenceStore.config(persistence, 'localhost', 3306, 'bingo', 'root', '')

session = persistenceStore.getSession()

app = express.createServer()
app.use(express.bodyParser())
app.use(app.router)
app.use(express.static("#{__dirname}/public"))

Cell = persistence.define('Cell', {
  selected: "BOOL",
  value: "TEXT"
})

Sheet = persistence.define('Sheet', {
  name: "TEXT",
  size: "INT"
})

Sheet.hasMany('cells', Cell, 'sheets')

app.get '/sync', (req, res) ->
  session.schemaSync (tx) ->
    res.write('Done')

app.post '/sheet', (req, res) ->
  sheet = new Sheet(session)
  for c in [0..24]
    cell = new Cell(session)
    cell.value = req.body[c].value
    cell.selected = false
    sheet.cells.add(cell)
  session.flush()
  res.send(req.body)

app.get '/sheet', (req, res) ->
  Sheet.all(session).one (data) ->
    console.log(data.cells.all())
    res.send(data.cells)

app.get '/sheet/:id', (req, res) ->
  console.log(req)
  console.log('--------------------')
  console.log(res)
  # do even more stuff

app.put '/sheet/:id', (req, res) ->
  # oh so many things to do

app.delete '/sheet/:id', (req, res) ->
  # I don't even know where to begin

app.listen(8080)
