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

  # Module dependencies
  _         = require 'underscore'
  $         = require 'jquery'
  Backbone  = require 'backbone'
  utils     = require 'utils'
  server    = require 'server'

  Party           = require 'models/party'
  PartyClientView = require 'views/partyClient'
  PartyPlayerView = require 'views/partyPlayer'
  SearchView      = require 'views/search'

  initClient = (party) ->
    $partyClient = $('#party-client')

    # clientView = new PartyClientView
    #   model: new Party(party)

    clientView = new PartyPlayerView model: new Party(party)

    $partyClient.empty().append clientView.$el
    clientView.render()

    searchView = new SearchView()
    searchView.search 'Trey anastasio', (source, results) ->
      console.log source
      console.log results

  sampleSong =
    source: 'Soundcloud'
    score: 4
    uri: '/tracks/297'
    duration: 399151
    timestamp:
      Date.now()

  sampleSong2 =
    source: 'Soundcloud'
    score: 3
    uri: '/tracks/296'
    duration: 422556
    timestamp:
      Date.now()

  sampleParty =
    name: 'rad party'
    loc: [39, -75]
    playing: sampleSong
    songs: [sampleSong,sampleSong2]

  init = () ->
    $ -> initClient sampleParty
    # unless 'geolocation' of navigator
    #   # TODO: better alert
    #   console.log 'not supported in browser'

    # navigator.geolocation.getCurrentPosition (position) ->
    #   console.log 'finding nearby parties...'
    #   server.findParties position.coords, (parties) ->
    #     console.log parties
    #     # TODO: use real data
    #     $ -> initClient sampleParty

  init()

  $ ->
    console.log 'DOM ready'

  return null
