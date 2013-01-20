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

    testSong:
      title:"Corinna"
      artist:"Phish"
      duration: 274000
      uri: "spotify:track:0KImAx8VSImr3bzE0YyMcs"
      
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
            loadSpotifySong next.uri
            btn = @$('iframe').contents().find('.play-pause-btn')
            btn.click()
            this.playID = setTimeout(this.playNext, next.duration)
            
            
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
          btn = @$('iframe').contents().find('.play-pause-btn')
          btn.click()
          
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
            btn = @$('iframe').contents().find('.play-pause-btn')
            elapsedTimeString = @$('iframe').contents().find('.time-spent').contents()
            [minutes, seconds] = elapsedTimeString.split(':')
            elapsedTime = ((parseInt(minutes) * 60) + parseInt(seconds)) * 1000
            remainingTime = this.model.get('playing').duration - elapsedTime
            this.playId = setTimeout this.playNext, remainingTime
            btn.click()

    play: () ->
      debugger
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
