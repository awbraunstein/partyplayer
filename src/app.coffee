# Entry point for server-side javascript app
(->
  DIRNAME = process.cwd()
  PORT    = process.env.PORT or process.env.VMC_APP_PORT or 3000

  # Module dependencies and app init
  express = require 'express'
  assets  = require 'connect-assets'
  io      = require('socket.io').listen app
  router  = require('./router').Router
  app     = module.exports = express()

  # --------------------------------------------------------------------------
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

  # --------------------------------------------------------------------------
  # Routes

  # GET -> render pages
  app.get '/',        router.party.createParty
  app.get '/a/:id',   router.party.partyAdmin
  app.get '/:id',     router.party.party

  # POST -> request data
  app.post '/nearby',  router.party.findParties

  # --------------------------------------------------------------------------
  # Start Server
  app.listen PORT, ->
    console.log "Listening on #{PORT} in #{app.settings.env} mode"


  # --------------------------------------------------------------------------
  # Socket stuff
  io.sockets.on('connection', (socket) ->

    socket.on('joinparty', (data) ->
      # join a party as a guest
      # data is {id: room_id, ...}
      console.log data

      # get the party data
      pdata = ""
      socket.party = data.id
      socket.join socket.party
      socket.emit 'joined', 'SERVER', "you have joined the #{socket.party} party."
      socket.emit 'populate', 'SERVER', pdata
    )

    socket.on('createparty', (data) ->
      # create a new party
      console.log data

      socket.party = data.id
      socket.join socket.party
      socket.emit 'joined', 'SERVER', "you have joined the #{socket.party} party."
    )

    socket.on('playsong', (data) ->
      # play a song by moving it into now playing
      # and removing it from the playlist
      # data is {song}
      console.log data

      io.sockets.in(socket.party).emit('playsong', 'SERVER', data)
    )

    socket.on('addsong', (data) ->
      # add song to a party playlist
      # data is {id: room_id, type: media_type, uri: url/uri}
      console.log data

      # add the new song to the server
      # then send out the update to everyone
      io.sockets.in(socket.party).emit('addsong', 'SERVER', data)
    )

    socket.on('vote', (data) ->
      # Vote for a uri in a party
      # data is {id: room_id, uri: url/uri, vote: up/down}
      console.log data

      # add the vote to the server
      # send out the update to everyone
      io.sockets.in(socket.party).emit('vote', 'SERVER', data)
    )

    socket.on('disconnect', () ->
      socket.leave socket.room
    )
  )

  return null
)()
