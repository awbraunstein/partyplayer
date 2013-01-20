var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
define(function(require, exports, module) {
  var $, Backbone, SOCKET_PORT, _;
  _ = require('underscore');
  $ = require('jquery');
  Backbone = require('backbone');
  SOCKET_PORT = 8080;
  return exports.partyClient = Backbone.Model.extend({
    idAttribute: '_id',
    url: function() {
      return "/party/" + this.id;
    },
    initialize: function() {
      this.socket = io.connect("http://localhost:" + SOCKET_PORT);
      this.socket.on('connect', __bind(function() {
        return this.socket.emit('joined', {
          id: this.id
        });
      }, this));
      return this.socket.on('populate', __bind(function(party) {
        console.log('Got a (socket) party!');
        return console.log(party);
      }, this));
    }
  });
});