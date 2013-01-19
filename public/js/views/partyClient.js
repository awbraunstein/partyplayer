define(function(require, exports, module) {
  var $, Backbone, ResultView, SearchView, utils, _;
  $ = require('jquery');
  _ = require('underscore');
  Backbone = require('backbone');
  utils = require('utils');
  SearchView = require('views/search');
  ResultView = require('views/result');
  return exports.partyClientView = Backbone.View.extend({
    template: 'mobileClient',
    events: {
      'keypress #search': 'autoCompleteSearch'
    },
    initialize: function() {
      console.log('client view init');
      return this.searchView = new SearchView();
    },
    render: function() {
      var html;
      console.log(this.model.toJSON());
      html = utils.tmpl(this.template, this.model.toJSON());
      this.$el.html(html);
      return this;
    },
    autoCompleteSearch: function(e) {
      var query;
      query = this.$('#search').val();
      if (query === '') {
        return;
      }
      this('#search-results').empty();
      this.searchView.search(query, function(source, results) {
        var res, _i, _len, _results;
        _results = [];
        for (_i = 0, _len = results.length; _i < _len; _i++) {
          res = results[_i];
          _results.push(this.$('#search-results').append(res.title));
        }
        return _results;
      });
      return null;
    }
  });
});