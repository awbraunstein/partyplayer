define(function(require, exports, module) {
  var $, Backbone, _;
  $ = require('jquery');
  _ = require('underscore');
  Backbone = require('backbone');
  require('/lib/js/soundcloud.js');
  return exports.search = Backbone.View.extend({
    initialize: function() {
      console.log('created search view');
      return SC.initialize({
        client_id: '0bc80f756a59625ed11e9791f107004a'
      });
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
        return console.log(data.feed.entry);
      });
    },
    searchSoundcloud: function(str) {
      return SC.get('/tracks', {
        q: str,
        order: 'hotness',
        filter: 'streamable'
      }, function(tracks) {
        return console.log(tracks);
      });
    },
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