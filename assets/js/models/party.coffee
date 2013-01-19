define (require, exports, module) ->

  _         = require 'underscore'
  $         = require 'jquery'
  Backbone  = require 'backbone'

  exports.party = Backbone.Model.extend

    url: () ->
      "/party/#{this.id} "
