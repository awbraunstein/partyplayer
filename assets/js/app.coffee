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

  PartyClient     = require 'models/partyClient'
  PartyClientView = require 'views/partyClient'

  initClient = (party) ->
    $partyClient = $('#party-client')

    clientView = new PartyClientView
      model: new PartyClient(party)

    $partyClient.empty().append clientView.$el
    clientView.render()

  init = () ->
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

  $ ->
    console.log 'DOM ready'

  return null
