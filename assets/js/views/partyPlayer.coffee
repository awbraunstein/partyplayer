define (require, exports, module) ->

  $         = require 'jquery'
  _         = require 'underscore'
  Backbone  = require 'backbone'
  SC        = require '/lib/js/soundcloud.js'

  SC.initialize client_id: '0bc80f756a59625ed11e9791f107004a'

  exports.PartyPlayerView = Backbone.View.extend
    
    initialize: () ->
      console.log 'player view init'

    playNext: () ->
      if this.model.get("songs").length isnt 0
        # TODO notify the server we've changed songs
        # Pick next top rated song and play it
        next = _.max this.model.get("songs"), (s) -> s.rating
        this.playing = next
        switch next.source
          when "Soundcloud"
            # Assuming we have the SC object and it's initialized. The same
            # thing is needed by search, so I assume we'll have this
            SC.stream next.uri, (sound) ->
              this.sound = sound
              this.playId = setTimeout(next.duration, playNext)
              sound.play()
          when "Youtube"
            # Assuming we have a player object, which should come from some
            # embedded swf in a hidden div
            player.loadVideoById(next.uri, 0, "default")
            player.playVideo()
            this.playId = setTimeout(next.duration, playNext)
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
            this.playId = setTimeout(this.sound.duration - this.sound.position)
            this.sound.play()
          when "Youtube"
            this.playId = setTimeout((player.getDuration() - player.getCurrentTime()) * 1000)
            player.playVideo()
          when "Spotify"
            null
          
    play: () ->
      if this.playing
        this.resume()
      else
        this.playNext()
                                                        
    render: () ->
      this.$el.html(this.model.get 'name')
      return this
