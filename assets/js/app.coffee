# Entry point for client-side javascript app
requirejs.config
  paths:
    jquery:     '/lib/js/jquery-1.9.0.min'
    underscore: '/lib/js/underscore'
    backbone:   '/lib/js/backbone'
    handlebars: '/lib/js/handlebars'
  shim:
    backbone:
      deps: ['underscore', 'jquery']
      exports: 'Backbone'
    handlebars:
      deps: ['underscore']
      exports: 'Handlebars'

define (require, exports, module) ->

  # Module dependencies
  _         = require 'underscore'
  $         = require 'jquery'
  Backbone  = require 'backbone'
  utils     = require 'utils'
  server    = require 'server'

  Party           = require 'models/party'
  PartyClientView = require 'views/partyClient'

  initClient = (party) ->
    $partyClient = $('#party-client')

    clientView = new PartyClientView
      model: new Party(party)

    $partyClient.empty().append clientView.$el
    clientView.render()

  sampleSong =
    type: 'Spotify'
    score: 4
    uri: 'http://open.spotify.com/track/31yCrPeqVYke01Un3jPVWk'
    title: 'Alligator'
    artist: 'The Babies'
    timestamp: Date.now

  sampleParty =
    name: 'rad party'
    loc: [39, -75]
    playing: sampleSong
    requests: [sampleSong]

  init = () ->
    unless 'geolocation' of navigator
      # TODO: better alert
      console.log 'not supported in browser'

    navigator.geolocation.getCurrentPosition (position) ->
      console.log 'finding nearby parties...'
      server.findParties position.coords, (parties) ->
        console.log parties
        # TODO: use real data
        $ -> initClient sampleParty

  init()

  $ ->
    console.log 'DOM ready'

  return null
