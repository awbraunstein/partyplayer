define (require, exports, module) ->

  $         = require 'jquery'
  _         = require 'underscore'
  Backbone  = require 'backbone'

  require '/lib/js/soundcloud.js'

  SC.initialize client_id: '0bc80f756a59625ed11e9791f107004a'

  exports.PartyPlayerView = Backbone.View.extend

    events:
      'click .play'  : 'play'
      'click .pause' : 'pause'
      'click .next'  : 'next'
    
    initialize: () ->
      console.log 'player view init'

    playNext: () ->
      console.log this.model.get("songs")
      if this.model.get("songs").length isnt 0
        # Stop all existing music
        if this.sound
          this.sound.stop()
        # player.stopVideo()
        # Pick next top rated song and play it
        next = _.max(this.model.get("songs"), (s) -> s.score)
        # TODO notify the server we've changed songs
        this.model.set("songs", _.select(this.model.get("songs"), (song) -> song isnt next))
        this.playing = next
        switch next.source
          when "Soundcloud"
            SC.stream next.uri, (sound) =>
              this.sound = sound
              this.playId = setTimeout(next.duration, this.playNext)
              sound.play()
          when "Youtube"
            # Assuming we have a player object, which should come from some
            # embedded swf in a hidden div
            player.loadVideoById(next.uri, 0, "default")
            player.playVideo()
            this.playId = setTimeout(next.duration, this.playNext)
          when "Spotify"
            null
            
    pause: () ->
      clearTimeout(this.playId)
      switch this.playing.source
        when "Soundcloud"
          # Soundcloud uses soundManager
          this.sound.pause()
        when "Youtube"
          player.pauseVideo()
        when "Spotify"
          null
          
    resume: () ->
      if this.playing
        switch this.playing.source
          when "Soundcloud"
            this.playId = setTimeout(this.sound.duration - this.sound.position, this.playNext)
            this.sound.play()
          when "Youtube"
            this.playId = setTimeout((player.getDuration() - player.getCurrentTime()) * 1000, this.playNext)
            player.playVideo()
          when "Spotify"
            null
          
    play: () ->
      if this.playing
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
