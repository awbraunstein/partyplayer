define(function(require, exports, module) {
  var $, Backbone, _;
  $ = require('jquery');
  _ = require('/lib/js/lodash.js');
  Backbone = require('/lib/js/backbone.js');
  exports.partyClient = _.extend(Backbone.Model({
    url: function() {
      return "/party/" + this.id + " ";
    }
  }));
  return module.exports = server;
});