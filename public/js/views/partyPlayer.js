// Generated by CoffeeScript 1.3.3

define(function(require, exports, module) {
  var $, Backbone, YT_URL, _;
  $ = require('jquery');
  _ = require('underscore');
  Backbone = require('backbone');
  require('/lib/js/soundcloud.js');
  require('/lib/js/swfobject.js');
  SC.initialize({
    client_id: '0bc80f756a59625ed11e9791f107004a'
  });
  YT_URL = "http://www.youtube.com/apiplayer?enablejsapi=1&version=3";
  window.onYouTubePlayerReady = function(playerId) {
    return window.player = document.getElementById("youtubeplayer");
  };
  return exports.PartyPlayerView = Backbone.View.extend({
    events: {
      'click .play': 'play',
      'click .pause': 'pause',
      'click .next': 'next'
    },
    initialize: function() {
      console.log('player view init');
      return this.initializeYoutube();
    },
    initializeYoutube: function() {
      var attrs, params;
      params = {
        allowScriptAccess: "always"
      };
      attrs = {
        id: "youtubeplayer"
      };
      return swfobject.embedSWF(YT_URL, "youtube", "425", "356", "8", null, null, params, attrs);
    },
    playNext: function() {
      var next,
        _this = this;
      if (this.model.hasSongs()) {
        if (this.sound) {
          this.sound.stop();
        }
        player.stopVideo();
        next = this.model.nextSong();
        switch (next.source) {
          case "Soundcloud":
            return SC.stream(next.uri, function(sound) {
              _this.sound = sound;
              _this.playId = setTimeout(_.bind(_this.playNext, _this), next.duration);
              return sound.play();
            });
          case "Youtube":
            player.loadVideoById(next.uri, 0, "default");
            player.playVideo();
            return this.playId = setTimeout(_.bind(this.playNext, this), next.duration);
          case "Spotify":
            return null;
        }
      }
    },
    pause: function() {
      clearTimeout(this.playId);
      switch (this.model.get("playing").source) {
        case "Soundcloud":
          return this.sound.pause();
        case "Youtube":
          return player.pauseVideo();
        case "Spotify":
          return null;
      }
    },
    resume: function() {
      if (this.model.get("playing")) {
        switch (this.model.get("playing").source) {
          case "Soundcloud":
            this.playId = setTimeout(_.bind(this.playNext, this), this.sound.duration - this.sound.position);
            return this.sound.play();
          case "Youtube":
            this.playId = setTimeout(_.bind(this.playNext, this), (player.getDuration() - player.getCurrentTime()) * 1000);
            return player.playVideo();
          case "Spotify":
            return null;
        }
      }
    },
    play: function() {
      if (this.model.get("playing")) {
        return this.resume();
      } else {
        return this.playNext();
      }
    },
    next: function() {
      if (this.playId) {
        clearTimeout(this.playId);
      }
      return this.playNext();
    },
    render: function() {
      this.$el.html("<button class='play'>play</button><button class='pause'>pause</button><button class='next'>next</button>");
      return this;
    }
  });
});
