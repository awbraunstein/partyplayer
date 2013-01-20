var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
define(function(require, exports, module) {
  var $, Backbone, Search, SearchView, TRACK_LIST_SELECTOR, Track, TrackList, TrackView, utils, _;
  $ = require('jquery');
  _ = require('underscore');
  utils = require('utils');
  Backbone = require('backbone');
  Search = require('models/search');
  Track = require('models/track');
  TrackList = require('collections/trackList');
  SearchView = require('views/search');
  TrackView = require('views/track');
  TRACK_LIST_SELECTOR = '#request-list';
  return exports.partyClientView = SearchView.extend({
    template: 'mobileClient',
    events: {
      'keyup #search': 'autoCompleteDebounce',
      'click .search-result': 'requestTrack',
      'click .vote': 'vote'
    },
    initialize: function() {
      this.searchModel = new Search();
      this.model.get('songs').on('change:score', __bind(function() {
        return this.onScoreChange();
      }, this));
      this.model.get('songs').on('add', __bind(function() {
        return this.renderTrackList();
      }, this));
      return this.model.get('playing').on('change', __bind(function() {
        return this.render();
      }, this));
    },
    renderTrackList: function() {
      var $list;
      console.log('rendering track list');
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
    requestTrack: function(e) {
      var $el;
      e.preventDefault();
      $el = $(e.currentTarget);
      this.model.sendNewRequest({
        source: $el.attr('data-source'),
        uri: $el.attr('data-uri'),
        title: $el.attr('data-title'),
        artist: $el.attr('data-artist'),
        album_art: $el.attr('data-art')
      });
      return this.clearSearch();
    },
    vote: function(e) {
      var $vote, uri;
      $vote = this.$(e.target).closest('.track-item').one();
      if (!$vote.hasClass('active')) {
        uri = $vote.attr('data-uri');
        this.model.voteSong(uri, 'up');
        return $vote.addClass('active');
      }
    }
  });
});