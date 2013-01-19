fs            = require 'fs'
{print}       = require 'util'
which         = require('which')
{spawn, exec} = require 'child_process'

# ANSI Terminal Colors
bold  = '\x1B[0;1m'
red   = '\x1B[0;31m'
green = '\x1B[0;32m'
reset = '\x1B[0m'

pkg       = JSON.parse fs.readFileSync('./package.json')
testCmd   = pkg.scripts.test
startCmd  = pkg.scripts.start


log = (message, color, explanation) ->
  console.log color + message + reset + ' ' + (explanation or '')

# Compiles app.coffee and src directory to the app directory
build = (callback) ->
  options = ['-c','-b', '-o', 'app', 'src']
  cmd = which.sync 'coffee'
  coffee = spawn cmd, options
  coffee.stdout.pipe process.stdout
  coffee.stderr.pipe process.stderr
  coffee.on 'exit', (status) -> callback?() if status is 0

# mocha test
test = (callback) ->
  options = [
    '--compilers'
    'coffee:coffee-script'
    '--colors'
    '--require'
    'should'
    '--require'
    './server'
  ]
  try
    cmd = which.sync 'mocha'
    spec = spawn cmd, options
    spec.stdout.pipe process.stdout
    spec.stderr.pipe process.stderr
    spec.on 'exit', (status) -> callback?() if status is 0
  catch err
    log err.message, red
    log 'Mocha is not installed - try npm install mocha -g', red

task 'docs', 'Generate annotated source code with Docco', ->
  fs.readdir 'src', (err, contents) ->
    files = ("src/#{file}" for file in contents when /\.coffee$/.test file)
    try
      cmd = which.sync 'docco'
      docco = spawn cmd, files
      docco.stdout.pipe process.stdout
      docco.stderr.pipe process.stderr
      docco.on 'exit', (status) -> callback?() if status is 0
    catch err
      log err.message, red
      log 'Docco is not installed - try npm install docco -g', red


task 'build', ->
  build -> log ":)", green

task 'spec', 'Run Mocha tests', ->
  build -> test -> log ":)", green

task 'test', 'Run Mocha tests', ->
  build -> test -> log ":)", green

task 'dev', 'start dev env', ->
  # watch_coffee
  options = ['-c', '-b', '-w', '-o', 'app', 'src']
  cmd = which.sync 'coffee'
  coffee = spawn cmd, options
  coffee.stdout.pipe process.stdout
  coffee.stderr.pipe process.stderr
  log 'Watching coffee files', green
  # watch_js
  supervisor = spawn 'node', ['./node_modules/supervisor/lib/cli-wrapper.js','-w','app,views', '-e', 'js|jade', 'server']
  supervisor.stdout.pipe process.stdout
  supervisor.stderr.pipe process.stderr
  log 'Watching js files and running server', green
  invoke 'watchAssets'
  log 'Watching assets'


# Front end asset compilation
appFiles = [
  'assets/js/app.coffee'
]

task 'coffeeFiles', 'find coffee files', () ->
  traverseFileSystem = (currentPath) ->
    files = fs.readdirSync currentPath
    for file in files
      do (file) ->
        currentFile = "#{currentPath}/#{file}"
        stats       = fs.statSync(currentFile)
        if stats.isFile() and currentFile.indexOf('.coffee') > 1 and
            appFiles.join('=').indexOf("#{currentFile}=") < 0
          appFiles.push currentFile
        else if stats.isDirectory()
          traverseFileSystem currentFile

  traverseFileSystem 'assets/js'
  log "#{appFiles.length} coffee files found."
  return appFiles

task 'watchAssets', 'Watch asset source files and build changes', () ->
  invoke 'buildAssets'
  for file in appFiles then do (file) ->
    fs.watchFile file, (curr, prev) ->
      if +curr.mtime isnt +prev.mtime
        log "Saw change in #{file}"
        invoke 'buildAssets'

task 'buildAssets', 'Build single application file from source files', ->
  invoke 'coffeeFiles'
  appContents = new Array remaining = appFiles.length
  for file, index in appFiles then do (file, index) ->
    fs.readFile file, 'utf8', (err, fileContents) ->
      throw err if err
      appContents[index] = fileContents
      process(file) if --remaining is 0
  process = (file) ->
    log '\n--------'
    log file
    # fs.writeFile 'public/app.coffee', appContents.join('\n\n'), 'utf8', (err) ->
    #   throw err if err
    #   exec 'coffee --compile public/app.coffee', (err, stdout, stderr) ->
    #     if err
    #       log 'Error compiling coffee file.'
    #     else
    #       fs.unlink 'public/app.coffee', (err) ->
    #         if err
    #           log 'Couldn\'t delete the app.coffee file/'
    #         log 'Done building coffee file.'

