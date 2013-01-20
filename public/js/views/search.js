define(function(require, exports, module) {
  var $, Backbone, SEARCH_RESULT_SELECTOR, utils, _;
  $ = require('jquery');
  _ = require('underscore');
  utils = require('utils');
  Backbone = require('backbone');
  SEARCH_RESULT_SELECTOR = '#search-results';
  return exports.SearchView = Backbone.View.extend({
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
      this.searchModel.search(query, function(source, results) {
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
    }
  });
});