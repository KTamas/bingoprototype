#### Initialization
http = require 'http' 
express = require 'express' 
public = "#{__dirname}/public"

# Express.js
app = express.createServer()

# Express.js default configuration
app.configure ->
  app.use express.compiler
    src: public
    enable: ['coffeescript']
  app.use express.bodyParser() 
  app.use express.static public  
  app.use app.router 

#### Database configuration. 
# See [this](https://github.com/zefhemel/persistencejs/pull/42) why we're using a fork of the original persistence.js library, also why the messy initialization process.
# This was the best ORM I could find for MySql and it's still kinda immature, but it'll work for now.
persistence = require './persistence' 
PersistenceConfig = require('./persistence').StoreConfig
persistenceStore = PersistenceConfig.init persistence, adaptor: 'mysql'
persistenceStore.config persistence, 'localhost', 3306, 'bingo', 'root', '' 

# Immature, yes, I have to pass around a session object.
session = persistenceStore.getSession()

# We have many wordlists.
Wordlist = persistence.define 'Wordlist',
  name: "TEXT" 
  size: "INT"

# Wordlists have `Wordlist.size` words.
Word = persistence.define 'Word', 
  value: "TEXT"

Wordlist.hasMany 'words', Word, 'wordlists' 

User = persistence.define 'User',
  nick: "TEXT"
  email: "TEXT"

app.get '/sync', (req, res) ->
  session.schemaSync (tx) ->
    res.write('Done')

# First time? Just the first wordlist for now.
app.get '/wordlist', (req, res) ->
  Wordlist.all(session).one (data) ->
    data.words.list null, (results) ->
      res.send(results)

app.get '/wordlist/:id', (req, res) ->
  Wordlist.all(session).filter('id', '=', req.params.id).one (data) ->
    data.words.list null, (results) ->
      res.send(results)


app.post '/wordlist', (req, res) ->
  wordlist = new Wordlist(session)
  for c in [0..24]
    word = new Word(session)
    word.value = req.body[c].value
    word.selected = false
    wordlist.words.add(word)
  session.flush()
  res.send(req.body)


app.put '/wordlist/:id', (req, res) ->
  # oh so many things to do

app.delete '/wordlist/:id', (req, res) ->
  # I don't even know where to begin

app.listen(8080)
