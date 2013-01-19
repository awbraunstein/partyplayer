define (require, exports, module) ->

  $         = require 'jquery'
  _         = require 'underscore'
  Backbone  = require 'backbone'
  utils     = require 'utils'

  exports.partyClientView = Backbone.View.extend

    template: 'mobileClient'

    initialize: () ->
      console.log 'client view init'

    render: () ->
      console.log this.model.toJSON()
      html = utils.tmpl this.template, this.model.toJSON()
      this.$el.html html
      return this
