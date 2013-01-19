# Entry point for server-side javascript app
(->
  DIRNAME = process.cwd()
  PORT    = process.env.PORT or process.env.VMC_APP_PORT or 3000

  # Module dependencies and app init
  express = require 'express'
  assets  = require 'connect-assets'
  router  = require('./router').Router
  app     = module.exports = express()

  # Configuration
  app.configure ->
    app.set 'views', "#{DIRNAME}/views"
    # Allow template inheritance
    app.set 'view options',
      layout: false
    app.set 'view engine', 'jade'
    app.locals.pretty = true # render pretty HTML in view engine
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use express.cookieParser()
    app.use express.session secret: 'your secret here'
    app.use app.router
    app.use express.static "#{DIRNAME}/public"
    app.use assets()

  app.configure 'development', ->
    app.use express.errorHandler
      dumpExceptions: true
      showStack: true
    console.log '\n========== Routes =========='
    console.log router
    console.log '============================\n'

  app.configure 'production', ->
    app.use express.errorHandler()

  # Routes
  app.get '/', router.party.createParty
  app.get '/a/:id', router.party.partyAdmin
  app.get '/:id', router.party.party

  # Start Server
  app.listen PORT, ->
    console.log "Listening on #{PORT} in #{app.settings.env} mode"

  return null
)()
