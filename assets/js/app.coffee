# Entry point for client-side javascript app
define (require, exports, module) ->

  # Module dependencies
  $         = require 'jquery'
  _         = require '/lib/js/lodash.js'
  Backbone  = require '/lib/js/backbone.js'
  utils     = require 'utils'
  server    = require 'server'

  PartyClient     = require 'models/partyClient'
  PartyClientView = require 'views/partyClient'

  initClient = (party) ->
    $partyClient = $('#party-client')

    clientView = PartyClientView
      model: PartyClient(party)

    $partyClient.empty.append clientView.$el
    clientView.render()

  init = () ->
    if 'geolocation' of navigator
      navigator.geolocation.getCurrentPosition (position) ->
        console.log 'finding nearby parties...'
        server.findParties position.coords, (parties) ->
          console.log 'found parties...'
          console.log parties
          # TODO
          initClient parties[0]
    else
      console.log 'not supported in browser'

  init()

  $ ->
    console.log 'DOM ready'

  return null
