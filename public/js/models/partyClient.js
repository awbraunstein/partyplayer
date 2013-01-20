// Generated by CoffeeScript 1.3.3

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
      console.log("currently playing " + (track.get('title')) + "...");
      return this.initSocketActions();
    },
    initSocketActions: function() {
      var _this = this;
      this.socket = io.connect("http://localhost:" + SOCKET_PORT);
      this.socket.on('connect', function() {
        return _this.socket.emit('joinparty', {
          id: _this.id
        });
      });
      this.socket.on('populate', function(party) {
        return null;
      });
      this.socket.on('playsong', function(next) {
        var nextTrack;
        console.log('***** play new song *****');
        console.log(next);
        nextTrack = _this.get('songs').find(function(song) {
          return song.get('uri' === next.uri);
        });
        _this.played.push(_this.get('playing'));
        _this.set('playing', nextTrack);
        return _this.get('songs').remove(nextTrack);
      });
      return this.socket.on('addsong', function(song) {
        var newRequest;
        console.log('***** got new request ******');
        console.log(song);
        newRequest = new Track(song);
        return _this.get('songs').push(newRequest);
      });
    },
    sendNewRequest: function(track) {
      return this.socket.emit('addsong', _.extend(track, {
        id: this.id
      }));
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
