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
      @model.get('songs').on 'add', @renderTrackList
      @model.get('playing').on 'change', @render

    renderTrackList: () ->
      $list = @$(TRACK_LIST_SELECTOR)
      $list.empty()

      @model.get('songs').each (song) ->
        view = new TrackView
          model: song
        $list.append view.$el
        view.render()

    render: () ->
      html = utils.tmpl @template, _.extend @model.toJSON(),
        previous: @model.get('played').last()
      @$el.html html
      @renderTrackList()
      return this

    onScoreChange: (song) ->
      @model.get('songs').sort()
      @renderTrackList()

    autoCompleteDebounce: (e) ->
      # Check if key up was a letter or backspace
      if (e.keyCode >= 65 and e.keyCode <= 90) or e.keyCode == 8
        _.debounce @autoCompleteSearch(e), 500

    autoCompleteSearch: (e) ->
      $results = @$(SEARCH_RESULT_SELECTOR)
      partyID  = @model.get 'id'

      $results.empty()
      query = @$('#search').val()
      if query.length < 4
        return

      @searchView.search query, (source, results) ->
        # Render each search result in the results div
        # Because of the excessive time it would take to create Backbone views,
        # we use raw strings here instead.
        for res in results
          if _.isObject res
            html = utils.tmpl 'searchResult', res
            $results.append html
      return null

    clearSearch: (e) ->
      @$(SEARCH_RESULT_SELECTOR).empty()      

    requestTrack: (e) ->
      e.preventDefault()
      $el     = $(e.currentTarget)
      t =
        source: $el.attr 'data-source'
        uri:    $el.attr 'data-uri'
        title:  $el.attr 'data-title'
        artist: $el.attr 'data-artist'
        score:  0
        album_art: $el.attr 'data-art'
      @model.sendNewRequest t
      html = utils.tmpl 'trackItem', t
      @$(TRACK_LIST_SELECTOR).append html
      @clearSearch()
