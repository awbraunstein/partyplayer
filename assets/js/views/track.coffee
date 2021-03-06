define (require, exports, module) ->

  $         = require 'jquery'
  _         = require 'underscore'
  Backbone  = require 'backbone'
  utils     = require 'utils'

  exports.trackView = Backbone.View.extend

    template: 'trackItem'

    adminTemplate: 'trackItemAdmin'

    initialize: () ->
      return this

    render: () ->
      html = utils.tmpl @template, @model.toJSON()
      @$el.html html
      return this

    renderAdmin: () ->
      html = utils.tmpl @adminTemplate, @model.toJSON()
      @$el.html html
      return this
