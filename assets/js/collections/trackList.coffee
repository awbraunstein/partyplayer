define (require, exports, module) ->

  _         = require 'underscore'
  $         = require 'jquery'
  Backbone  = require 'backbone'
  Track     = require 'models/track'

  exports.track = Backbone.Collection.extend

    model: Track

    comparator: (track) ->
      -track.get('score')
