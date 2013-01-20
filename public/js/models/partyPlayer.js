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
      return this.socket = io.connect("http://localhost:" + SOCKET_PORT);
    }
  });
});