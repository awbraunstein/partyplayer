# Entry point for server-side javascript app
(->
  DIRNAME     = process.cwd()
  PORT        = process.env.PORT or process.env.VMC_APP_PORT or 3000
  SOCKET_PORT = 8080

  # Libraries
  express = require 'express'
  _       = require 'lodash'
  assets  = require 'connect-assets'
  app     = express()
  server  = require('http').createServer app
  io      = require('socket.io').listen server

  # Modules
  router  = require('./router').Router
  models  = require './models'

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
  app.get '/',            router.party.index
  app.get '/new',         router.party.newParty
  app.get '/party/:name', router.party.playParty

  # POST -> request data
  app.post '/nearby',   router.party.findParties
  app.post '/create',   router.party.createParty

  # --------------------------------------------------------------------------
  # Start Server
  app.listen PORT, ->
    console.log "Listening on #{PORT} in #{app.settings.env} mode"

  # Fake data
  generateParty = () ->
    newParty = new models.Party
      name: 'party.io'
      loc: [ 39.9516968, -75.1909739 ]
    newParty.save (err) ->
      console.log err

    newParty.addSong
      source: 'youtube'
      title: "RickRoll'D"
      score: 3
      uri: 'oHg5SJYRHA0'
      duration: 213000
      timestamp:
        Date.now()

    newParty.addSong
      source: 'soundcloud'
      score: 4
      uri: '/tracks/297'
      duration: 399151
      timestamp:
        Date.now()

  # generateParty()

  # --------------------------------------------------------------------------
  # Socket stuff
  server.listen SOCKET_PORT

  io.sockets.on('connection', (socket) ->

    socket.on('joinparty', (data) ->
      # join a party as a guest
      # data is {id: room_id, ...}
      console.log data

      socket.party = data.id
      socket.join socket.party

      socket.emit 'joined', 'SERVER', "you have joined the #{socket.party} party."

      # get the party data
      party = socket.party
      socket.emit 'populate', 'SERVER', party
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

      models.Party.findById socket.party, (err, party) ->
        if not err
          song = party.playNextSong data.uri
          io.sockets.in(socket.party).emit 'playsong', data
    )

    socket.on('addsong', (data) ->
      # add song to a party playlist
      # data is {id: room_id, type: media_type, uri: url/uri, ...}
      console.log data
      models.Party.findById socket.party, (err, party) ->
        console.log _
        song = party.addSong _.extend data,
          score: 0

        # add the new song to the server
        # then send out the update to everyone
        io.sockets.in(socket.party).emit 'addsong', data
    )

    socket.on('vote', (data) ->
      # Vote for a uri in a party
      # data is {id: room_id, uri: url/uri, vote: up/down}
      console.log data

      models.Party.findById socket.party, (err, party) ->
        song = if data.vote is 'up'
          party.upvoteSong data.uri
        else
          party.downvoteSong data.uri

        # add the vote to the server
        # send out the update to everyone
        io.sockets.in(socket.party).emit 'vote', song
    )

    socket.on('disconnect', () ->
      socket.leave socket.room
    )
  )

  return null
)()
