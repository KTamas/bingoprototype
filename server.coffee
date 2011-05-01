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
mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

mongoose.connect 'mongodb://bingo:B1ng0@flame.mongohq.com:27032/bingo'

Words = new Schema
  body: String

Wordlist = new Schema
  name: String
  words: [Words]

Users = new Schema
  name: String
  email: String

Games = new Schema
  users: [Users]
  wordlist: [Wordlist]

mongoose.model 'Wordlist', Wordlist
mongoose.model 'Users', Users
mongoose.model 'Games', Games

app.get '/wordlist', (req, res) ->
  wordlist = mongoose.model 'Wordlist'
  wordlist.findOne()

app.get '/wordlist/:id', (req, res) ->
  wordlist = mongoose.model 'Wordlist'
  wordlist.findOne({ id: req.params.id })

app.post '/wordlist', (req, res) ->
  console.log 'starting'
  wordlist = mongoose.model 'Wordlist'
  mylist = new wordlist
  for c in [0..24]
    mylist.words.push body: "foo"
  mylist.save (err) ->
    if !err
      console.log('success')
      res.send('foobar')

app.listen(8080)
