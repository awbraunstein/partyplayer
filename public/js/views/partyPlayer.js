var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
define(function(require, exports, module) {
  var $, Backbone, YT_URL, utils, _;
  $ = require('jquery');
  _ = require('underscore');
  Backbone = require('backbone');
  utils = require('utils');
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
    template: 'partyPlayer',
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
    loadSpotifySong: function(uri) {
      console.log(uri);
      return this.render({
        'spotify-uri': uri
      });
    },
    playNext: function() {
      var btn, next;
      if (this.model.hasSongs()) {
        if (this.sound) {
          this.sound.stop();
        }
        player.stopVideo();
        next = this.model.nextSong();
        switch (next.source) {
          case "soundcloud":
            return SC.stream(next.uri, __bind(function(sound) {
              this.sound = sound;
              this.playId = setTimeout(_.bind(this.playNext, this), next.duration);
              return sound.play();
            }, this));
          case "youtube":
            player.loadVideoById(next.uri, 0, "default");
            player.playVideo();
            return this.playId = setTimeout(_.bind(this.playNext, this), next.duration);
          case "spotify":
            this.loadSpotifySong(next.uri);
            btn = this.$('iframe').contents().find('.play-pause-btn');
            btn.click();
            return this.playId = setTimeout(_.bind(this.playNext, this), next.duration);
        }
      }
    },
    pause: function() {
      var btn;
      clearTimeout(this.playId);
      switch (this.model.get("playing").source) {
        case "soundcloud":
          return this.sound.pause();
        case "youtube":
          return player.pauseVideo();
        case "spotify":
          btn = this.$('iframe').contents().find('.play-pause-btn');
          return btn.click();
      }
    },
    resume: function() {
      var btn, elapsedTime, elapsedTimeString, minutes, remainingTime, seconds, _ref;
      if (this.model.get("playing")) {
        switch (this.model.get("playing").source) {
          case "soundcloud":
            this.playId = setTimeout(_.bind(this.playNext, this), this.sound.duration - this.sound.position);
            return this.sound.play();
          case "youtube":
            this.playId = setTimeout(_.bind(this.playNext, this), (player.getDuration() - player.getCurrentTime()) * 1000);
            return player.playVideo();
          case "spotify":
            btn = this.$('iframe').contents().find('.play-pause-btn');
            elapsedTimeString = this.$('iframe').contents().find('.time-spent').contents();
            _ref = elapsedTimeString.split(':'), minutes = _ref[0], seconds = _ref[1];
            elapsedTime = ((parseInt(minutes) * 60) + parseInt(seconds)) * 1000;
            remainingTime = this.model.get('playing').duration - elapsedTime;
            this.playId = setTimeout(_bind(this.playNext, this), remainingTime);
            return btn.click();
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
    render: function(data) {
      var d, html;
      d = data || {};
      html = utils.tmpl(this.template, d);
      this.$el.html(html);
      return this;
    }
  });
});