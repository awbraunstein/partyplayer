define(function(require, exports, module) {
  var $, Backbone, _;
  _ = require('underscore');
  $ = require('jquery');
  Backbone = require('backbone');
  return exports.partyClient = Backbone.Model.extend({
    url: function() {
      return "/party/" + this.id + " ";
    }
  });
});