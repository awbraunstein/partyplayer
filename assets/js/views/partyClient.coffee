define (require, exports, module) ->

  $         = require 'jquery'
  _         = require 'underscore'
  Backbone  = require 'backbone'
  utils     = require 'utils'

  Track       = require 'models/track'
  TrackList   = require 'collections/trackList'
  SearchView  = require 'views/search'
  TrackView   = require 'views/track'

  SEARCH_RESULT_SELECTOR  = '#search-results'
  TRACK_LIST_SELECTOR     = '#request-list'

  exports.partyClientView = Backbone.View.extend

    template: 'mobileClient'

    events:
      'keyup #search': 'autoCompleteDebounce'
      'click .search-result': 'requestTrack'

    initialize: () ->
      @searchView = new SearchView()
      @model.get('songs').on 'change:score', @onScoreChange

    renderTrackList: () ->
      $list = @$(TRACK_LIST_SELECTOR)
      $list.empty()

      @model.get('songs').each (song) ->
        view = new TrackView
          model: song
        $list.append view.$el
        view.render()

    render: () ->
      html = utils.tmpl @template, @model.toJSON()
      @$el.html html
      @renderTrackList()
      return this

    onScoreChange: (song) ->
      @model.get('songs').sort()
      @renderTrackList

    autoCompleteDebounce: (e) ->
      # Check if key up was a letter
      if e.keyCode >= 65 and e.keyCode <= 90
        _.debounce @autoCompleteSearch(e), 500

    autoCompleteSearch: (e) ->
      $results = @$(SEARCH_RESULT_SELECTOR)
      partyID  = @model.get 'id'

      query = @$('#search').val()
      if query.length < 4
        return

      $results.empty()
      @searchView.search query, (source, results) ->
        # Render each search result in the results div
        # Because of the excessive time it would take to create Backbone views,
        # we use raw strings here instead.
        for res in results
          if _.isObject res
            $results.append "<a class='search-result' data-uri='#{res.uri}'
                              data-source='#{res.source}' href='#'>
                              #{res.title} - #{res.artist}
                            </a>"
      return null

    requestTrack: (e) ->
      e.preventDefault()
      $el     = $(e.currentTarget)
      source  = $el.attr 'data-source'
      uri     = $el.attr 'data-uri'
      @model.sendNewRequest source, uri
