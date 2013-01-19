define (require, exports, module) ->

  $         = require 'jquery'
  _         = require 'underscore'
  Backbone  = require 'backbone'
  utils     = require 'utils'

  SearchView  = require 'views/search'
  ResultView  = require 'views/result'

  exports.partyClientView = Backbone.View.extend

    template: 'mobileClient'

    events:
      'keypress #search': 'autoCompleteSearch'

    initialize: () ->
      console.log 'client view init'
      @searchView = new SearchView()

    render: () ->
      console.log @model.toJSON()
      html = utils.tmpl @template, @model.toJSON()
      @$el.html html
      return this

    autoCompleteSearch: (e) ->
      query = @$('#search').val()
      if query is ''
        return

      @('#search-results').empty()
      @searchView.search query, (source, results) ->
        for res in results
          @$('#search-results').append res.title

      return null
