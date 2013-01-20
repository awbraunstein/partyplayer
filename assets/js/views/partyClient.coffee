define (require, exports, module) ->

  $         = require 'jquery'
  _         = require 'underscore'
  Backbone  = require 'backbone'
  utils     = require 'utils'

  # Track       = require 'models/track'
  SearchView  = require 'views/search'
  # TrackView   = require 'views/track'

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
      $results = @$('#search-results')
      partyID  = @model.get 'id'

      query = @$('#search').val()
      if query is ''
        return

      $results.empty()
      @searchView.search query, (source, results) ->
        for res in results
          # Create a new track model and view, including the current partyID
          # trackView = new TrackView
          #   model: new Track _.extend res,
          #     partyID: partyID

          $results.append res
          # $results.append trackView.$el
          # trackView.render()

      return null
