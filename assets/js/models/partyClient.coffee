define (require, exports, module) ->

  _         = require 'underscore'
  $         = require 'jquery'
  Backbone  = require 'backbone'

  exports.partyClient = Backbone.Model.extend

    url: () ->
      "/party/#{this.id} "
