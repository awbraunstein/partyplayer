# Entry point for client-side javascript app
requirejs.config
  paths:
    jquery:     '/lib/js/jquery-1.9.0.min'
    underscore: '/lib/js/underscore'
    backbone:   '/lib/js/backbone'
    handlebars: '/lib/js/handlebars'
  shim:
    underscore:
      deps: []
      exports: '_'
    backbone:
      deps: ['underscore', 'jquery']
      exports: 'Backbone'
    handlebars:
      deps: ['underscore']
      exports: 'Handlebars'

define (require, exports, module) ->

  PARTY_NAME_REGEX = /party\/(.+)/

  # Module dependencies
  _         = require 'underscore'
  $         = require 'jquery'
  Backbone  = require 'backbone'
  utils     = require 'utils'
  server    = require 'server'

  PartyClient     = require 'models/partyClient'
  PartyPlayer     = require 'models/partyPlayer'
  PartyClientView = require 'views/partyClient'
  PartyPlayerView = require 'views/partyPlayer'

  initClient = (party) ->
    $partyClient = $('#party-client')

    clientView = new PartyClientView
      model: new PartyClient party

    $partyClient.empty().append clientView.$el
    clientView.render()

  initPlayer = (party) ->
    $partyPlayer = $('#party-player')

    m = new PartyPlayer(party)
    console.log m

    playerView = new PartyPlayerView
      model: m

    $partyPlayer.empty().append playerView.$el
    playerView.render()

  sampleSong =
    source: 'Youtube'
    score: 4
    uri: 'KlujizeNNQM'
    duration: 5000
    timestamp:
      Date.now()

  sampleSong2 =
    source: 'Soundcloud'
    score: 3
    uri: '/tracks/297'
    duration: 399151
    timestamp:
      Date.now()

  sampleParty =
    name: 'rad party'
    loc: [39, -75]
    playing: sampleSong
    songs: [sampleSong,sampleSong2]

  init = () ->
    matched = window.location.pathname.match PARTY_NAME_REGEX
    if matched
      server.getPartyInfo matched[1], (partyData) ->
        console.log partyData
        $ -> initPlayer partyData
      return

    # Otherwise, find the closest party and join it as a client
    unless 'geolocation' of navigator
      # TODO: better alert
      console.log 'not supported in browser'

    navigator.geolocation.getCurrentPosition (position) ->
      console.log 'finding nearby parties...'
      server.findParties position.coords, (parties) ->
        # TODO: select party
        if parties?
          $ -> initClient parties[0]
        else
          console.log 'No parties!'

  init()

  return null
