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
  value: String

Wordlist = new Schema
  name: String
  words: [Words]

Users = new Schema
  name: String
  email: String

Games = new Schema
  creator: [Users]
  createdAt: Date
  users: [Users]
  wordlist: [Wordlist]

mongoose.model 'Wordlist', Wordlist
mongoose.model 'Users', Users
mongoose.model 'Games', Games

crud_generator = (model, name) ->
  app.get "/#{name}", (req, res) ->
    res.send mongoose.model model  
   
  app.get "/#{name}/:id", (req, res) ->
    mongoose.model(model).findOne _id: req.params.id, (err, data) ->
      res.send data

  app.post "/#{name}", (req, res) -> 
    mymodel = new mongoose.model model
    console.log(req.body.params)

  app.delete "/#{name}", (req, res) ->
    mongoose.model(model).findOne 
    # have to write this
    
app.get '/wordlist', (req, res) ->
  wordlist = mongoose.model 'Wordlist'
  wordlist.findOne name: "bla", (err, data) ->
    res.send data.words 

app.get '/wordlist/:id', (req, res) ->
  wordlist = mongoose.model 'Wordlist'
  wordlist.findOne id: req.params.id 

app.post '/wordlist', (req, res) ->
  wordlist = mongoose.model 'Wordlist'
  mylist = new wordlist
  mylist.name = "bla"
  for c in [0..24]
    mylist.words.push value: "foo"
  mylist.save (err) ->
    if !err
      res.send 'done' 

app.listen(8080)
