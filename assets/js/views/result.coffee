define (require, exports, module) ->

  $         = require 'jquery'
  _         = require 'underscore'
  Backbone  = require 'backbone'
  utils     = require 'utils'

  ResultView  = require 'views/result'

  exports.partyClientView = Backbone.View.extend

    template: 'searchResult'

    initialize: () ->
      console.log 'result view init'
      console.log @model.toJSON()

    render: () ->
      # html = utils.tmpl @template, @model.toJSON()
      # @$el.html html
      return this

