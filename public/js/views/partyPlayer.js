var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
define(function(require, exports, module) {
  var $, Backbone, PartyClientView, Search, TRACK_LIST_SELECTOR, TrackView, YT_URL, utils, _;
  $ = require('jquery');
  _ = require('underscore');
  utils = require('utils');
  Backbone = require('backbone');
  Search = require('models/search');
  PartyClientView = require('views/partyClient');
  TrackView = require('views/track');
  require('/lib/js/soundcloud.js');
  require('/lib/js/swfobject.js');
  SC.initialize({
    client_id: '0bc80f756a59625ed11e9791f107004a'
  });
  YT_URL = "http://www.youtube.com/apiplayer?enablejsapi=1&version=3";
  TRACK_LIST_SELECTOR = '#request-list';
  window.onYouTubePlayerReady = function(playerId) {
    return window.player = document.getElementById("youtubeplayer");
  };
  return exports.PartyPlayerView = PartyClientView.extend({
    template: 'partyPlayer',
    events: {
      'click .play': 'play',
      'click .pause': 'pause',
      'click .next': 'next',
      'keyup #search': 'autoCompleteDebounce',
      'click .search-result': 'requestTrack',
      'click .vote': 'vote'
    },
    initialize: function() {
      this.initializeYoutube();
      this.searchModel = new Search();
      this.model.get('songs').on('change:score', __bind(function() {
        return this.onScoreChange();
      }, this));
      this.model.get('songs').on('add', __bind(function() {
        return this.renderTrackList();
      }, this));
      return this.model.get('playing').on('change', __bind(function() {
        return this.render();
      }, this));
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
      var next;
      if (this.model.hasSongs()) {
        if (this.sound) {
          this.sound.stop();
        }
        player.stopVideo();
        next = this.model.nextSong();
        switch (next.get('source')) {
          case "soundcloud":
            return SC.stream(next.get('uri'), __bind(function(sound) {
              this.sound = sound;
              this.playId = setTimeout(_.bind(this.playNext, this), next.duration);
              return sound.play();
            }, this));
          case "youtube":
            player.loadVideoById(next.get('uri'), 0, "small");
            player.playVideo();
            return this.playId = setTimeout(_.bind(this.playNext, this), next.duration);
        }
      }
    },
    pause: function() {
      clearTimeout(this.playId);
      switch (this.model.get("playing").get('source')) {
        case "soundcloud":
          return this.sound.pause();
        case "youtube":
          return player.pauseVideo();
      }
    },
    resume: function() {
      if (this.model.get("playing")) {
        switch (this.model.get("playing").get('source')) {
          case "soundcloud":
            this.playId = setTimeout(_.bind(this.playNext, this), this.sound.duration - this.sound.position);
            return this.sound.play();
          case "youtube":
            this.playId = setTimeout(_.bind(this.playNext, this), (player.getDuration() - player.getCurrentTime()) * 1000);
            return player.playVideo();
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
    progess: function() {
      switch (this.model.get("playing").source) {
        case "soundcloud":
          return this.sound.position;
        case "youtube":
          return player.getCurrentTime() * 1000;
      }
    },
    onScoreChange: function(song) {
      this.model.get('songs').sort();
      return this.renderTrackList();
    },
    renderTrackList: function() {
      var $list;
      $list = this.$(TRACK_LIST_SELECTOR);
      $list.empty();
      return this.model.get('songs').each(function(song) {
        var view;
        view = new TrackView({
          model: song
        });
        $list.append(view.$el);
        return view.renderAdmin();
      });
    },
    render: function() {
      var data, html, view;
      data = this.model.toJSON();
      if (this.model.get('playing')) {
        data.playing = this.model.get('playing').toJSON();
      } else {
        data.playing = false;
      }
      if (this.model.get('previous')) {
        data.previous = this.model.get('previous').toJSON();
      } else {
        data.previous = false;
      }
      html = utils.tmpl(this.template, data);
      this.$el.html(html);
      if (this.model.get('previous')) {
        view = new TrackView({
          model: this.model.get('previous')
        });
        this.$('.previous').html(view.renderAdmin().$el);
      }
      if (this.model.get('playing')) {
        view = new TrackView({
          model: this.model.get('playing')
        });
        this.$('.now-playing').html(view.renderAdmin().$el);
      }
      this.renderTrackList();
      return this;
    }
  });
});