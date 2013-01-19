define(function(require, exports, module) {
  var $, Backbone, utils, _;
  $ = require('jquery');
  _ = require('underscore');
  Backbone = require('backbone');
  utils = require('utils');
  return exports.partyClientView = Backbone.View.extend({
    template: 'mobileClient',
    initialize: function() {
      return console.log('client view init');
    },
    render: function() {
      var html;
      console.log(this.model.toJSON());
      html = utils.tmpl(this.template, this.model.toJSON());
      this.$el.html(html);
      return this;
    }
  });
});