var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
define(function(require, exports, module) {
  var $, Backbone, _;
  $ = require('jquery');
  _ = require('underscore');
  Backbone = require('backbone');
  require('/lib/js/soundcloud.js');
  SC.initialize({
    client_id: '0bc80f756a59625ed11e9791f107004a'
  });
  return exports.PartyPlayerView = Backbone.View.extend({
    events: {
      'click .play': 'play',
      'click .pause': 'pause',
      'click .next': 'next'
    },
    initialize: function() {
      return console.log('player view init');
    },
    playNext: function() {
      var next;
      console.log(this.model.get("songs"));
      if (this.model.get("songs").length !== 0) {
        if (this.sound) {
          this.sound.stop();
        }
        next = _.max(this.model.get("songs"), function(s) {
          return s.score;
        });
        this.model.set("songs", _.select(this.model.get("songs"), function(song) {
          return song !== next;
        }));
        this.playing = next;
        switch (next.source) {
          case "Soundcloud":
            return SC.stream(next.uri, __bind(function(sound) {
              this.sound = sound;
              this.playId = setTimeout(next.duration, this.playNext);
              return sound.play();
            }, this));
          case "Youtube":
            player.loadVideoById(next.uri, 0, "default");
            player.playVideo();
            return this.playId = setTimeout(next.duration, this.playNext);
          case "Spotify":
            return null;
        }
      }
    },
    pause: function() {
      clearTimeout(this.playId);
      switch (this.playing.source) {
        case "Soundcloud":
          return this.sound.pause();
        case "Youtube":
          return player.pauseVideo();
        case "Spotify":
          return null;
      }
    },
    resume: function() {
      if (this.playing) {
        switch (this.playing.source) {
          case "Soundcloud":
            this.playId = setTimeout(this.sound.duration - this.sound.position, this.playNext);
            return this.sound.play();
          case "Youtube":
            this.playId = setTimeout((player.getDuration() - player.getCurrentTime()) * 1000, this.playNext);
            return player.playVideo();
          case "Spotify":
            return null;
        }
      }
    },
    play: function() {
      if (this.playing) {
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