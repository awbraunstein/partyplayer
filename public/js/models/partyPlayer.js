var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
define(function(require, exports, module) {
  var $, Backbone, SOCKET_PORT, _;
  _ = require('underscore');
  $ = require('jquery');
  Backbone = require('backbone');
  SOCKET_PORT = 8080;
  return exports.PartyPlayer = Backbone.Model.extend({
    idAttribute: '_id',
    url: function() {
      return "/party/" + this.id;
    },
    initialize: function() {
      this.socket = io.connect("http://localhost:" + SOCKET_PORT);
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
      var next;
      next = _.max(this.get("songs"), function(s) {
        return s.score;
      });
      this.get("played").push(this.get("playing"));
      this.set("songs", _.select(this.get("songs"), function(song) {
        return song !== next;
      }));
      this.set("playing", next);
      this.socket.emit('playsong', next);
      return next;
    }
  });
});