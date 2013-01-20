define(function(require, exports, module) {
  var $, Backbone, SEARCH_RESULT_SELECTOR, SearchView, TRACK_LIST_SELECTOR, Track, TrackList, TrackView, utils, _;
  $ = require('jquery');
  _ = require('underscore');
  Backbone = require('backbone');
  utils = require('utils');
  Track = require('models/track');
  TrackList = require('collections/trackList');
  SearchView = require('views/search');
  TrackView = require('views/track');
  SEARCH_RESULT_SELECTOR = '#search-results';
  TRACK_LIST_SELECTOR = '#request-list';
  return exports.partyClientView = Backbone.View.extend({
    template: 'mobileClient',
    events: {
      'keyup #search': 'autoCompleteDebounce',
      'click .search-result': 'requestTrack'
    },
    initialize: function() {
      this.searchView = new SearchView();
      return this.model.get('songs').on('change:score', this.onScoreChange);
    },
    renderTrackList: function() {
      var $list;
      $list = this.$(TRACK_LIST_SELECTOR);
      $list.empty();
      return this.model.get('songs').each(function(song) {
        var view;
        view = new TrackView({
          model: song
        });
        $list.append(view.$el);
        return view.render();
      });
    },
    render: function() {
      var html;
      html = utils.tmpl(this.template, this.model.toJSON());
      this.$el.html(html);
      this.renderTrackList();
      return this;
    },
    onScoreChange: function(song) {
      this.model.get('songs').sort();
      return this.renderTrackList;
    },
    autoCompleteDebounce: function(e) {
      if (e.keyCode >= 65 && e.keyCode <= 90) {
        return _.debounce(this.autoCompleteSearch(e), 500);
      }
    },
    autoCompleteSearch: function(e) {
      var $results, partyID, query;
      $results = this.$(SEARCH_RESULT_SELECTOR);
      partyID = this.model.get('id');
      query = this.$('#search').val();
      if (query.length < 4) {
        return;
      }
      $results.empty();
      this.searchView.search(query, function(source, results) {
        var res, _i, _len, _results;
        _results = [];
        for (_i = 0, _len = results.length; _i < _len; _i++) {
          res = results[_i];
          _results.push(_.isObject(res) ? $results.append("<a class='search-result' data-uri='" + res.uri + "'                              data-source='" + res.source + "' href='#'>                              " + res.title + " - " + res.artist + "                            </a>") : void 0);
        }
        return _results;
      });
      return null;
    },
    requestTrack: function(e) {
      var $el, source, uri;
      e.preventDefault();
      $el = $(e.currentTarget);
      source = $el.attr('data-source');
      uri = $el.attr('data-uri');
      return this.model.sendNewRequest(source, uri);
    }
  });
});