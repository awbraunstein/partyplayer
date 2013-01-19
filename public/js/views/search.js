define(function(require, exports, module) {
  var $, Backbone, _;
  $ = require('jquery');
  _ = require('underscore');
  Backbone = require('backbone');
  return exports.search = Backbone.View.extend({
    initialize: function() {
      return console.log('created search view');
    },
    searchYoutube: function(str) {
      var params, url, youtube_base_url;
      youtube_base_url = 'https://gdata.youtube.com/feeds/api/videos';
      params = {
        q: str,
        orderby: 'relevance',
        'start-index': 1,
        alt: 'json',
        v: 2,
        'max-results': 10
      };
      url = "" + youtube_base_url + "?" + ($.param(params));
      return $.get(url, function(data) {
        return console.log(data);
      });
    },
    searchSoundcloud: function(str) {},
    searchSpotify: function(str) {
      var params, spotify_base_url, url;
      spotify_base_url = 'http://ws.spotify.com/search/1/track';
      params = {
        q: str
      };
      url = "" + spotify_base_url + ".json?" + ($.param(params));
      return $.get(url, function(data) {
        return console.log(data);
      });
    },
    render: function() {
      this.$el.html(this.model.get('name'));
      return this;
    }
  });
});