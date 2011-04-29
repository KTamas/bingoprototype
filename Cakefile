sv = require 'supervisor'
path = require 'path'
{spawn, exec} = require 'child_process'

# http://stackoverflow.com/questions/4819782/output-when-watching-coffeescript-files-from-a-cakefile-task

task 'start', ->
  sv.run "-e coffee -x coffee server.coffee".split(" ")

task 'docs', ->
  exec 'docco public/*.coffee'
  exec 'docco server.coffee'
  exec 'cp docs/server.html docs/index.html'

# see https://github.com/rtomayko/rocco/blob/master/Rakefile
task 'docs:gh', 'generate docs and push it to gh-pages', ->
  invoke 'docs'


  # Yes I'm not proud of this line either, but I'm not gonna wrap all my shell commands into one callback of getting the freaking commit hash (`git rev-parse --short HEAD`). No way.
  rev = require('gitteh').openRepository('.git').getReference("HEAD").resolve().target.slice(0, 7)
  path.exists 'docs/.git/refs/heads/gh-pages', (exists) ->
    if !exists
      exec 'cd docs && git init -q && git remote add o ../.git'
    else
      exec 'cd docs && git fetch -q o && git reset -q --hard o/gh-pages && touch .'
  process.chdir 'docs'
  exec 'git add *.html'
  exec "git commit -m 'rebuild pages from #{rev}'", (err) ->
    if err
      console.log err
      return
    console.log 'gh-pages updated'
    exec 'git push -q o HEAD:gh-pages'

task 'docs:osx', ->
  invoke 'docs'
  exec 'open docs/server.html'


task 'docs:gnome', ->
  invoke 'docs'
  exec 'xdg-open docs/server.html'
