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
    },
    getPartyInfo: function(name, callback) {
      $.ajax({
        url: "/party/" + name,
        data: null,
        success: callback,
        dataType: 'json'
      });
      return null;
    }
  };
  return module.exports = server;
});