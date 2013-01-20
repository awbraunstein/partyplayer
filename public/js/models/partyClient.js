var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
define(function(require, exports, module) {
  var $, Backbone, SOCKET_PORT, Track, TrackList, _;
  _ = require('underscore');
  $ = require('jquery');
  Backbone = require('backbone');
  Track = require('models/track');
  TrackList = require('collections/trackList');
  SOCKET_PORT = 8080;
  return exports.PartyClient = Backbone.Model.extend({
    idAttribute: '_id',
    url: function() {
      return "/party/" + this.id;
    },
    initialize: function() {
      var played, songs, track;
      console.log(this.toJSON());
      track = new Track(this.get('playing'));
      played = new TrackList(this.get('played'));
      songs = new TrackList(this.get('songs'));
      this.set('playing', track);
      this.set('played', played);
      this.set('songs', songs);
      return this.initSocketActions();
    },
    initSocketActions: function() {
      this.socket = io.connect("http://localhost:" + SOCKET_PORT);
      this.socket.on('connect', __bind(function() {
        return this.socket.emit('joinparty', {
          id: this.id
        });
      }, this));
      this.socket.on('populate', __bind(function(party) {
        return console.log("populate: " + party);
      }, this));
      this.socket.on('playsong', __bind(function(next) {
        var nextTrack;
        console.log('***** play new song *****');
        console.log(next);
        nextTrack = this.get('songs').find(function(song) {
          return song.get('uri' === next.uri);
        });
        this.played.push(this.get('playing'));
        this.set('playing', nextTrack);
        return this.get('songs').remove(nextTrack);
      }, this));
      return this.socket.on('addsong', __bind(function(song) {
        var newRequest;
        newRequest = new Track(song);
        return this.get('songs').push(newRequest);
      }, this));
    },
    sendNewRequest: function(source, uri) {
      return this.socket.emit('addsong', {
        id: this.id,
        uri: uri,
        type: source
      });
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