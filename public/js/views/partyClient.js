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
      this.model.get('songs').on('change:score', this.onScoreChange);
      this.model.get('songs').on('add', this.renderTrackList);
      return this.model.get('playing').on('change', this.render);
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
      html = utils.tmpl(this.template, _.extend(this.model.toJSON(), {
        previous: this.model.get('played').last()
      }));
      this.$el.html(html);
      this.renderTrackList();
      return this;
    },
    onScoreChange: function(song) {
      this.model.get('songs').sort();
      return this.renderTrackList();
    },
    autoCompleteDebounce: function(e) {
      if ((e.keyCode >= 65 && e.keyCode <= 90) || e.keyCode === 8) {
        return _.debounce(this.autoCompleteSearch(e), 500);
      }
    },
    autoCompleteSearch: function(e) {
      var $results, partyID, query;
      $results = this.$(SEARCH_RESULT_SELECTOR);
      partyID = this.model.get('id');
      $results.empty();
      query = this.$('#search').val();
      if (query.length < 4) {
        return;
      }
      this.searchView.search(query, function(source, results) {
        var html, res, _i, _len, _results;
        _results = [];
        for (_i = 0, _len = results.length; _i < _len; _i++) {
          res = results[_i];
          _results.push(_.isObject(res) ? (html = utils.tmpl('searchResult', res), $results.append(html)) : void 0);
        }
        return _results;
      });
      return null;
    },
    clearSearch: function(e) {
      return this.$(SEARCH_RESULT_SELECTOR).empty();
    },
    requestTrack: function(e) {
      var $el, html, t;
      e.preventDefault();
      $el = $(e.currentTarget);
      t = {
        source: $el.attr('data-source'),
        uri: $el.attr('data-uri'),
        title: $el.attr('data-title'),
        artist: $el.attr('data-artist'),
        score: 0,
        album_art: $el.attr('data-art')
      };
      this.model.sendNewRequest(t);
      html = utils.tmpl('trackItem', t);
      this.$(TRACK_LIST_SELECTOR).append(html);
      return this.clearSearch();
    }
  });
});