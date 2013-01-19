define (require, exports, module) ->

  _  = require 'underscore'
  $  = require 'jquery'

  FIND_PARTIES_PATH = '/nearby'

  server =

    findParties: (coordinates, callback) ->
      console.log coordinates
      $.post FIND_PARTIES_PATH,
        latitude: coordinates.latitude
        longitude: coordinates.longitude
      , callback
      return null

  module.exports = server
