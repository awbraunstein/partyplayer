define(function(require, exports, module) {
  var $, Backbone, Track, _;
  _ = require('underscore');
  $ = require('jquery');
  Backbone = require('backbone');
  Track = require('models/track');
  return exports.track = Backbone.Collection.extend({
    model: Track,
    comparator: function(track) {
      return track.get('score');
    }
  });
});