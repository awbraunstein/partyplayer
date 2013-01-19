define (require, exports, module) ->

  $         = require 'jquery'
  _         = require 'underscore'
  Backbone  = require 'backbone'

  exports.partyClientView = Backbone.View.extend
    
    initialize: () ->
      console.log 'client view init'

    render: () ->
      this.$el.html(this.model.get 'name')
      return this
