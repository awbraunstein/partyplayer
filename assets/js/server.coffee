define (require, exports, module) ->

  _  = require '/lib/js/lodash.js'
  $  = require 'jquery'

  server =

    findParties: (coordinates, callback) ->
      console.log coordinates
      $.post '/find_parties',
        latitude: coordinates.latitude
        longitude: coordinates.longitude
      , callback

  module.exports = server
