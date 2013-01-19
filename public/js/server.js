// Generated by CoffeeScript 1.3.3

define(function(require, exports, module) {
  var $, FIND_PARTIES_PATH, server, _;
  _ = require('underscore');
  $ = require('jquery');
  FIND_PARTIES_PATH = '/nearby';
  server = {
    findParties: function(coordinates, callback) {
      console.log(coordinates);
      $.post(FIND_PARTIES_PATH, {
        latitude: coordinates.latitude,
        longitude: coordinates.longitude
      }, callback);
      return null;
    }
  };
  return module.exports = server;
});
