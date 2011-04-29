cp = require 'child_process'
sv = require 'supervisor'

# http://stackoverflow.com/questions/4819782/output-when-watching-coffeescript-files-from-a-cakefile-task

task 'start', ->
  sv.run "-e coffee -x coffee server.coffee".split(" ")

task 'docs', ->
  cp.exec 'docco public/*.coffee'
  cp.exec 'docco server.coffee'

task 'docs:show', ->
  # Come on I seriously can't call another task?
  cp.exec 'cake docs'
  # TODO: linux version...
  cp.exec 'open docs/server.html'
