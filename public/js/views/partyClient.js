define(function(require, exports, module) {
  var $, Backbone, _;
  $ = require('jquery');
  _ = require('/lib/js/lodash.js');
  Backbone = require('/lib/js/backbone.js');
  exports.partyClientView = _.extend(Backbone.View({
    initialize: function() {
      return console.log('client view init ');
    },
    render: function() {
      this.$el.html(this.model.toJSON().toString());
      return this;
    }
  }));
  return module.exports = server;
});