define (require, exports, module) ->

  _  = require 'underscore'
  $  = require 'jquery'

  FIND_PARTIES_PATH = '/nearby'
  CREATE_PARTY_PATH = '/create'

  server =

    findParties: (coordinates, callback) ->
      console.log coordinates
      $.post FIND_PARTIES_PATH,
        latitude: coordinates.latitude
        longitude: coordinates.longitude
      , callback
      return null

    getPartyInfo: (name, callback) ->
      $.ajax
        url: "/party/#{name}"
        data: null
        success: callback
        dataType: 'json'
      return null

  module.exports = server
