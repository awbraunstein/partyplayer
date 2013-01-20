define (require, exports, module) ->

  $         = require 'jquery'
  _         = require 'underscore'
  utils     = require 'utils'
  Backbone  = require 'backbone'

  Search          = require 'models/search'
  PartyClientView = require 'views/partyClient'

  require '/lib/js/soundcloud.js'
  require '/lib/js/swfobject.js'

  SC.initialize client_id: '0bc80f756a59625ed11e9791f107004a'

  YT_URL = "http://www.youtube.com/apiplayer?enablejsapi=1&version=3"

  # Ugly code that Youtube mandates we use
  window.onYouTubePlayerReady = (playerId) ->
    window.player = document.getElementById("youtubeplayer")

  exports.PartyPlayerView = PartyClientView.extend

    template: 'partyPlayer'

    events:
      'click .play'  : 'play'
      'click .pause' : 'pause'
      'click .next'  : 'next'
      'keyup #search': 'autoCompleteDebounce'
      'click .search-result': 'requestTrack'
      'click .vote'  : 'vote'

    initialize: () ->
      this.initializeYoutube()

      @searchModel = new Search()
      @model.get('songs').on 'change:score', () => @onScoreChange()
      @model.get('songs').on 'add', () => @renderTrackList()
      @model.get('playing').on 'change', () => @render()

    initializeYoutube: () ->
      params = allowScriptAccess: "always"
      attrs  = id: "youtubeplayer"
      swfobject.embedSWF YT_URL, "youtube", "425", "356", "8",
        null, null, params, attrs

    playNext: () ->
      
      if this.model.hasSongs()
        # Stop all existing music
        if this.sound
          this.sound.stop()
        player.stopVideo()
        next = this.model.nextSong()
        switch next.get('source')
          when "soundcloud"
            SC.stream next.get('uri'), (sound) =>
              this.sound = sound
              this.playId = setTimeout(_.bind(this.playNext, this), next.duration)
              sound.play()
          when "youtube"
            # Assuming we have a player object, which should come from some
            # embedded swf in a hidden div
            player.loadVideoById(next.get('uri'), 0, "small")
            player.playVideo()
            this.playId = setTimeout(_.bind(this.playNext, this), next.duration)
            
    pause: () ->
      clearTimeout(this.playId)
      switch this.model.get("playing").source
        when "soundcloud"
          # Soundcloud uses soundManager for streaming, see
          # http://www.schillmania.com/projects/soundmanager2/doc/
          this.sound.pause()
        when "youtube"
          player.pauseVideo()
          
    resume: () ->
      if this.model.get("playing")
        switch this.model.get("playing").source
          when "soundcloud"
            this.playId = setTimeout(_.bind(this.playNext, this), this.sound.duration - this.sound.position)
            this.sound.play()
          when "youtube"
            this.playId = setTimeout _.bind(this.playNext, this),
              (player.getDuration() - player.getCurrentTime()) * 1000
            player.playVideo()

    play: () ->
      if this.model.get("playing")
        this.resume()
      else
        this.playNext()

    next: () ->
      if this.playId
        clearTimeout(this.playId)
      this.playNext()

    # Time elapsed, in milliseconds
    progess: () ->
      switch this.model.get("playing").source
        when "soundcloud"
          this.sound.position
        when "youtube"
          player.getCurrentTime() * 1000

    render: (data) ->
      d = data || {}
      html = utils.tmpl @template, d
      @$el.html html
      @renderTrackList()
      return this
