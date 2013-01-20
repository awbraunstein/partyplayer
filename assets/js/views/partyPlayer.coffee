define (require, exports, module) ->

  $         = require 'jquery'
  _         = require 'underscore'
  Backbone  = require 'backbone'
  utils     = require 'utils'

  require '/lib/js/soundcloud.js'
  require '/lib/js/swfobject.js'

  SC.initialize client_id: '0bc80f756a59625ed11e9791f107004a'

  YT_URL = "http://www.youtube.com/apiplayer?enablejsapi=1&version=3"

  # Ugly code that Youtube mandates we use
  window.onYouTubePlayerReady = (playerId) ->
    window.player = document.getElementById("youtubeplayer")

  exports.PartyPlayerView = Backbone.View.extend

    events:
      'click .play'  : 'play'
      'click .pause' : 'pause'
      'click .next'  : 'next'

    template: 'partyPlayer'
    
    initialize: () ->
      console.log 'player view init'
      this.initializeYoutube()

    initializeYoutube: () ->
      params = allowScriptAccess: "always"
      attrs  = id: "youtubeplayer"
      swfobject.embedSWF YT_URL, "youtube", "425", "356", "8",
        null, null, params, attrs

    loadSpotifySong: (uri) ->
      console.log uri
      @render 'spotify-uri': uri
      
    playNext: () ->
      if this.model.hasSongs()
        # Stop all existing music
        if this.sound
          this.sound.stop()
        player.stopVideo()
        next = this.model.nextSong()
        switch next.source
          when "soundcloud"
            SC.stream next.uri, (sound) =>
              this.sound = sound
              this.playId = setTimeout(_.bind(this.playNext, this), next.duration)
              sound.play()
          when "youtube"
            # Assuming we have a player object, which should come from some
            # embedded swf in a hidden div
            player.loadVideoById(next.uri, 0, "default")
            player.playVideo()
            this.playId = setTimeout(_.bind(this.playNext, this), next.duration)
          when "spotify"
            @loadSpotifySong next.uri
            btn = @$('iframe').contents().find('.play-pause-btn')
            btn.click()
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
        when "spotify"
          btn = @$('iframe').contents().find('.play-pause-btn')
          btn.click()
          
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
          when "spotify"
            btn = @$('iframe').contents().find('.play-pause-btn')
            elapsedTimeString = @$('iframe').contents().find('.time-spent').contents()
            [minutes, seconds] = elapsedTimeString.split(':')
            elapsedTime = ((parseInt(minutes) * 60) + parseInt(seconds)) * 1000
            remainingTime = this.model.get('playing').duration - elapsedTime
            this.playId = setTimeout _bind(this.playNext, this), remainingTime
            btn.click()

    play: () ->
      if this.model.get("playing")
        this.resume()
      else
        this.playNext()

    next: () ->
      if this.playId
        clearTimeout(this.playId)
      this.playNext()

    render: (data) ->
      d = data || {}
      html = utils.tmpl @template, d
      @$el.html html
      return this
