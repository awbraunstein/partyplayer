define (require, exports, module) ->

  _         = require 'underscore'
  $         = require 'jquery'
  Backbone  = require 'backbone'

  exports.track = Backbone.Model.extend

    url: () ->
      "/party/#{this.partyID}"

