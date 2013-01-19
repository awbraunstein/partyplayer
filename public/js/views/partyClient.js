define(function(require, exports, module) {
  var $, Backbone, utils, _;
  $ = require('jquery');
  _ = require('underscore');
  Backbone = require('backbone');
  utils = require('utils');
  return exports.partyClientView = Backbone.View.extend({
    template: 'mobile-client',
    initialize: function() {
      return console.log('client view init');
    },
    render: function() {
      this.$el.html(utils.tmpl(this.template, this.model.toJSON()));
      return this;
    }
  });
});