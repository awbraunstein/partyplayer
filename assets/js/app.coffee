# Entry point for client-side javascript app
requirejs.config
  paths:
    jquery:     '/lib/js/jquery-1.9.0.min'
    underscore: '/lib/js/underscore'
    backbone:   '/lib/js/backbone'
  shim:
    backbone:
      deps: ['underscore', 'jquery']
      exports: 'Backbone'

define (require, exports, module) ->

  # Module dependencies
  _         = require 'underscore'
  $         = require 'jquery'
  Backbone  = require 'backbone'
  utils     = require 'utils'
  server    = require 'server'

  PartyClient     = require 'models/partyClient'
  PartyClientView = require 'views/partyClient'
  SearchView      = require 'views/search'

  initClient = (party) ->
    $partyClient = $('#party-client')

    clientView = new PartyClientView
      model: new PartyClient(party)

    $partyClient.empty().append clientView.$el
    clientView.render()
    searchView = new SearchView()
    searchView.searchYoutube('two coins')

  sampleSong =
    type: 'Spotify'
    score: 4
    uri: 'http://open.spotify.com/track/1eozfgjK3LKYLe89MUo0tC'
    timestamp:
      Date.now

  sampleParty =
    name: 'rad party'
    loc: [39, -75]
    playing: sampleSong
    songs: [sampleSong]

  init = () ->
    if 'geolocation' of navigator
      navigator.geolocation.getCurrentPosition (position) ->
        console.log 'finding nearby parties...'
        server.findParties position.coords, (parties) ->
          console.log 'found parties...'
          console.log parties
          # TODO
          initClient sampleParty
    else
      console.log 'not supported in browser'

  console.log 'underscore...'
  console.log _
  console.log 'Backbone...'
  console.log Backbone
  init()

  $ ->
    console.log 'DOM ready'

  return null
