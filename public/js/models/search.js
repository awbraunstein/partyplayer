define(function(require, exports, module) {
  var $, Backbone, _;
  $ = require('jquery');
  _ = require('underscore');
  Backbone = require('backbone');
  require('/lib/js/soundcloud.js');
  return exports.Search = Backbone.Model.extend({
    initialize: function() {
      console.log('created search model');
      return SC.initialize({
        client_id: '0bc80f756a59625ed11e9791f107004a'
      });
    },
    search: function(str, callback) {
      this.searchYoutube(str, callback);
      return this.searchSoundcloud(str, callback);
    },
    searchYoutube: function(str, callback) {
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
        var tracks, video, _i, _len, _ref;
        tracks = [];
        _ref = data.feed.entry;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          video = _ref[_i];
          tracks.push({
            uri: video.media$group.yt$videoid.$t,
            duration: parseInt(video.media$group.yt$duration.seconds) * 1000,
            title: video.title.$t,
            source: 'youtube',
            album_art: video['media$group']['media$thumbnail'][0].url
          });
        }
        return callback('youtube', tracks);
      });
    },
    searchSoundcloud: function(str, callback) {
      return SC.get('/search', {
        q: str,
        facet: 'model',
        limit: 15,
        linked_partitioning: 1
      }, function(songs) {
        var song, tracks, _i, _len, _ref;
        tracks = [];
        _ref = songs.collection;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          song = _ref[_i];
          if (song.kind === 'track' && song.streamable) {
            tracks.push({
              uri: song.uri,
              duration: song.duration,
              title: song.title,
              artist: song.user.username,
              source: 'soundcloud',
              album_art: song.artwork_url
            });
          }
        }
        return callback('soundcloud', tracks);
      });
    }
  });
});