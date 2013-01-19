define(function(require, exports, module) {
  var $, Backbone, ResultView, utils, _;
  $ = require('jquery');
  _ = require('underscore');
  Backbone = require('backbone');
  utils = require('utils');
  ResultView = require('views/result');
  return exports.partyClientView = Backbone.View.extend({
    template: 'searchResult',
    initialize: function() {
      console.log('result view init');
      return console.log(this.model.toJSON());
    },
    render: function() {
      return this;
    }
  });
});