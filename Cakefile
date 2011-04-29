fs = require 'fs'
cp = require 'child_process'

# http://stackoverflow.com/questions/4819782/output-when-watching-coffeescript-files-from-a-cakefile-task
task 'watch', ->
  cp.spawn 'coffee', ['-cw', 'public'], customFds: [0..2]

task 'build' ->
  cp.exec 'coffee -c public/server.coffee'

task 'docs', ->
  cp.exec 'docco public/*.coffee'
  cp.exec 'docco server.coffee'
