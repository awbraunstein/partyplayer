define(function(require, exports, module) {
  var $, Backbone, _;
  $ = require('jquery');
  _ = require('underscore');
  Backbone = require('backbone');
  return exports.partyClientView = Backbone.View.extend({
    initialize: function() {
      return console.log('client view init');
    },
    render: function() {
      this.$el.html(this.model.get('name'));
      return this;
    }
  });
});