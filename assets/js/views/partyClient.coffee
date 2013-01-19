define (require, exports, module) ->

  $         = require 'jquery'
  _         = require 'underscore'
  Backbone  = require 'backbone'
  utils     = require 'utils'

  exports.partyClientView = Backbone.View.extend

    template: 'mobile-client'

    initialize: () ->
      console.log 'client view init'

    render: () ->
      this.$el.html(utils.tmpl this.template, this.model.toJSON())
      return this
