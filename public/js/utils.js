define(function(require, exports, module) {
  var $, Handlebars, id, source, templates, utils, _;
  _ = require('underscore');
  $ = require('jquery');
  Handlebars = require('handlebars');
  templates = {
    mobileClient: require('text!templates/mobile-client.handlebars'),
    trackItem: require('text!templates/track-item.handlebars'),
    partyPlayer: require('text!templates/player.handlebars')
  };
  for (id in templates) {
    source = templates[id];
    templates[id] = Handlebars.compile(source);
  }
  utils = {
    tmpl: function(id, context) {
      return templates[id](context);
    }
  };
  return module.exports = utils;
});