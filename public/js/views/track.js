define(function(require, exports, module) {
  var $, Backbone, utils, _;
  $ = require('jquery');
  _ = require('underscore');
  Backbone = require('backbone');
  utils = require('utils');
  return exports.trackView = Backbone.View.extend({
    template: 'trackItem',
    initialize: function() {
      return this;
    },
    render: function() {
      var html;
      html = utils.tmpl(this.template, this.model.toJSON());
      this.$el.html(html);
      return this;
    }
  });
});