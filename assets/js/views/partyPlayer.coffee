define (require, exports, module) ->

  $         = require 'jquery'
  _         = require 'underscore'
  Backbone  = require 'backbone'

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
    
    initialize: () ->
      console.log 'player view init'
      this.initializeYoutube()

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
        switch next.source
          when "Soundcloud"
            SC.stream next.uri, (sound) =>
              this.sound = sound
              this.playId = setTimeout(this.playNext, next.duration)
              sound.play()
          when "Youtube"
            # Assuming we have a player object, which should come from some
            # embedded swf in a hidden div
            player.loadVideoById(next.uri, 0, "default")
            player.playVideo()
            this.playId = setTimeout(this.playNext, next.duration)
          when "Spotify"
            null
            
    pause: () ->
      clearTimeout(this.playId)
      switch this.model.get("playing").source
        when "Soundcloud"
          # Soundcloud uses soundManager for streaming, see
          # http://www.schillmania.com/projects/soundmanager2/doc/
          this.sound.pause()
        when "Youtube"
          player.pauseVideo()
        when "Spotify"
          null
          
    resume: () ->
      if this.model.get("playing")
        switch this.model.get("playing").source
          when "Soundcloud"
            this.playId = setTimeout(this.playNext, this.sound.duration - this.sound.position)
            this.sound.play()
          when "Youtube"
            this.playId = setTimeout this.playNext,
              (player.getDuration() - player.getCurrentTime()) * 1000
            player.playVideo()
          when "Spotify"
            null
          
    play: () ->
      if this.model.get("playing")
        this.resume()
      else
        this.playNext()

    next: () ->
      if this.playId
        clearTimeout(this.playId)
      this.playNext()

    render: () ->
      this.$el.html("<button class='play'>play</button><button class='pause'>pause</button><button class='next'>next</button>")
      return this
