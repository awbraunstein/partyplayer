define (require, exports, module) ->

  $         = require 'jquery'
  _         = require 'underscore'
  utils     = require 'utils'
  Backbone  = require 'backbone'

  Search      = require 'models/search'
  Track       = require 'models/track'
  TrackList   = require 'collections/trackList'
  SearchView  = require 'views/search'
  TrackView   = require 'views/track'

  TRACK_LIST_SELECTOR = '#request-list'

  exports.partyClientView = SearchView.extend

    template: 'mobileClient'

    events:
      'keyup #search': 'autoCompleteDebounce'
      'click .search-result': 'requestTrack'
      'click .vote': 'vote'

    initialize: () ->
      @searchModel = new Search()
      @model.get('songs').on 'change:score', () => @onScoreChange()
      @model.get('songs').on 'add', () => @renderTrackList()
      @model.get('playing').on 'change', () => @render()

    renderTrackList: () ->
      console.log 'rendering track list'
      $list = @$(TRACK_LIST_SELECTOR)
      $list.empty()

      @model.get('songs').each (song) ->
        view = new TrackView
          model: song
        $list.append view.$el
        view.render()

    render: () ->
      data = @model.toJSON()
      prev = @model.get('played').last()
      if prev
        data.previous = prev.toJSON()
      if @model.get('playing')
        data.playing = @model.get('playing').toJSON()

      html = utils.tmpl @template, data
      @$el.html html
      @renderTrackList()
      return this

    onScoreChange: (song) ->
      @model.get('songs').sort()
      @renderTrackList()

    requestTrack: (e) ->
      e.preventDefault()
      $el = $(e.currentTarget)
      @model.sendNewRequest
        source: $el.attr 'data-source'
        uri:    $el.attr 'data-uri'
        title:  $el.attr 'data-title'
        artist: $el.attr 'data-artist'
        album_art: $el.attr 'data-art'
      @clearSearch()

    vote: (e) ->
      $vote = @$(e.target).closest('.track-item').one()
      if not $vote.hasClass('active')
        uri = $vote.attr 'data-uri'
        @model.voteSong uri, 'up'
        $vote.addClass 'active'
