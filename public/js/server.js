define(function(require, exports, module) {
  var $, server, _;
  _ = require('underscore');
  $ = require('jquery');
  server = {
    findParties: function(coordinates, callback) {
      console.log(coordinates);
      return $.post('/nearby', {
        latitude: coordinates.latitude,
        longitude: coordinates.longitude
      }, callback);
    }
  };
  return module.exports = server;
});