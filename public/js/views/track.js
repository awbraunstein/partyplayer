define(function(require, exports, module) {
  var $, Backbone, utils, _;
  $ = require('jquery');
  _ = require('underscore');
  Backbone = require('backbone');
  utils = require('utils');
  return exports.trackView = Backbone.View.extend({
    template: 'trackItem',
    adminTemplate: 'trackItemAdmin',
    initialize: function() {
      return this;
    },
    render: function() {
      var html;
      html = utils.tmpl(this.template, this.model.toJSON());
      this.$el.html(html);
      return this;
    },
    renderAdmin: function() {
      var html;
      html = utils.tmpl(this.adminTemplate, this.model.toJSON());
      this.$el.html(html);
      return this;
    }
  });
});