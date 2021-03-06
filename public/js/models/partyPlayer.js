var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
define(function(require, exports, module) {
  var $, Backbone, SOCKET_PORT, Track, TrackList, io, _;
  _ = require('underscore');
  $ = require('jquery');
  io = require('/lib/js/socket.io.js');
  Backbone = require('backbone');
  Track = require('models/track');
  TrackList = require('collections/trackList');
  SOCKET_PORT = 8080;
  return exports.PartyPlayer = Backbone.Model.extend({
    idAttribute: '_id',
    url: function() {
      return "/party/" + this.id;
    },
    initialize: function() {
      var played, songs, track;
      track = new Track(this.get('playing'));
      played = new TrackList(this.get('played'));
      songs = new TrackList(this.get('songs'));
      this.set('playing', track);
      this.set('played', played);
      this.set('songs', songs);
      this.on('change:songs', __bind(function(data) {
        if (_.isArray(this.get('songs'))) {
          return this.set('songs', new TrackList(this.get('songs')));
        }
      }, this));
      console.log("currently playing " + (track.get('title')) + "...");
      return this.initSocketActions();
    },
    initSocketActions: function() {
      this.socket = io.connect("http://" + window.location.hostname + ":" + SOCKET_PORT);
      this.socket.emit('createparty', {
        id: this.id
      });
      this.socket.on('vote', __bind(function(song) {
        return this.get('songs').each(function(s) {
          if (s.get('uri') === song.uri) {
            return s.set('score', song.score);
          }
        });
      }, this));
      return this.socket.on('addsong', __bind(function(song) {
        console.log('******* got new request ********');
        console.log(song);
        return this.get('songs').add(new Track(song));
      }, this));
    },
    getNextSong: function() {
      var next, songs;
      songs = this.get('songs');
      if (!songs) {
        return null;
      }
      next = songs.max(function(s) {
        return s.get('score');
      });
      if (this.get('playing')) {
        this.get('played').push(this.get('playing'));
      }
      this.set('playing', next);
      this.get('songs').remove(next);
      this.socket.emit('playsong', next.attributes);
      console.log('***** playing next... *****');
      console.log(next);
      return next;
    },
    sendNewRequest: function(track) {
      return this.socket.emit('addsong', track);
    },
    voteSong: function(uri, vote) {
      return this.socket.emit('vote', {
        id: this.id,
        uri: uri,
        vote: vote
      });
    }
  });
});