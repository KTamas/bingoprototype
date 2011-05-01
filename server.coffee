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
ObjectId = mongoose.ObjectId
mongoose.connect 'mongodb://bingo:B1ng0@flame.mongohq.com:27032/bingo'

Words = new Schema
  body: String

Wordlist = new Schema
  id: ObjectId
  name: String
  words: [Words]

Users = new Schema
  id: ObjectId
  name: String
  email: String

Games = new Schema
  id: ObjectId
  users: [Users]
  wordlist: [Wordlist]

mongoose.model 'Wordlist', Wordlist
mongoose.model 'Users', Users
mongoose.model 'Games', Games

app.get '/wordlist/:id', (req, res) ->
  wordlist = mongoose.model 'Wordlist'
  wordlist.findOne({ id: req.params.id })

app.post '/wordlist', (req, res) ->
  wordlist = mongoose.model 'Wordlist'
  mylist = new Wordlist
  for c in [0..24]
    mylist.words.push body: "foo"
  mylist.save (err) ->
    if !err
      console.log(success)

app.listen(8080)
