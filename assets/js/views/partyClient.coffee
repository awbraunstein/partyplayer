define (require, exports, module) ->

  $         = require 'jquery'
  _         = require '/lib/js/lodash.js'
  Backbone  = require '/lib/js/backbone.js'

  exports.partyClientView = _.extend Backbone.View
    
    initialize: () ->
      console.log 'client view init '

    render: () ->
      this.$el.html(this.model.toJSON().toString())
      return this

  module.exports = server
