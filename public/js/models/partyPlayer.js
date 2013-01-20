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
      console.log("currently playing " + (track.get('title')) + "...");
      return this.initSocketActions();
    },
    initSocketActions: function() {
      this.socket = io.connect("http://" + window.location.hostname + ":" + SOCKET_PORT);
      this.socket.emit('createparty', {
        id: this.id
      });
      return this.socket.on('addsong', __bind(function(song) {
        console.log('******* got new request ********');
        console.log(song);
        return this.get('songs').push(song);
      }, this));
    },
    hasSongs: function() {
      return this.get('songs').length !== 0;
    },
    nextSong: function() {
      var next, songs;
      songs = this.get('songs');
      next = songs.max(function(s) {
        return s.score;
      });
      this.get("played").push(this.get("playing"));
      this.set("songs", songs.select, function(song) {
        return song !== next;
      });
      this.set("playing", next);
      this.socket.emit('playsong', next);
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