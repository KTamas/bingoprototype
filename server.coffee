http = require 'http'
express = require 'express'
app = express.createserver()
app.use express.bodyParser()
app.use app.router
app.use express.static("#{__dirname}/public")

app.post 'sheet', (req, res) ->
  # do stuff

app.get '/sheet/:id', (req, res) ->
  # do even more stuff

app.put '/sheet/:id', (req, res) ->
  # oh so many things to do

app.delete '/sheet/:id', (req, res) ->
  # I don't even know where to begin
