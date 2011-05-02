sv = require 'supervisor'
path = require 'path'
{spawn, exec} = require 'child_process'

# http://stackoverflow.com/questions/4819782/output-when-watching-coffeescript-files-from-a-cakefile-task

task 'start', ->
  sv.run "-e coffee -x coffee server.coffee".split(" ")

task 'templates', ->
  sv.run '-e html -x coffee templater.coffee'.split(' ')

task 'docs', ->
  exec [
    'docco public/*.coffee'
    'docco server.coffee'
    'cp -f docs/server.html docs/index.html'
  ].join(' && ')
 
# see https://github.com/rtomayko/rocco/blob/master/Rakefile
task 'docs:gh', 'generate docs and push it to gh-pages', ->
  # Shamelessly stolen this trick from https://github.com/jashkenas/coffee-script/blob/master/Cakefile
  nope = [
    "cd docs"
    "git init -q"
    "git remote add o ../.git"
    "cd .."
  ].join(' && ')
  
  yep = [
    "cd docs"
    "git fetch -q o"
    "git reset -q --hard o/gh-pages"
    "touch ."
    "cd .."
  ].join(' && ')

  todo = [
    "cake docs"
    "cd docs"
    "git add *.css"
    "git add *.html"
    "git commit -a -m 'fancy commit message goes here'"
    "git push -q o HEAD:gh-pages"
    "cd .."
    "git push -q origin gh-pages"
  ].join(' && ')
  path.exists './docs/.git/refs/heads/master', (exists) ->
    if !exists
      exec nope + ' && ' + todo, (err, stdout, stderr) ->
        if err then console.log stderr.trim() else console.log 'success'
    else
      exec yep + ' && ' + todo, (err, stdout, stderr) ->
        if err then console.log stderr.trim() else console.log 'success'

task 'docs:osx', ->
  invoke 'docs'
  exec 'open docs/server.html'


task 'docs:gnome', ->
  invoke 'docs'
  exec 'xdg-open docs/server.html'
