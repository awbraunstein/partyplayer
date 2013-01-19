define(function(require, exports, module) {
  var $, Handlebars, templates, utils, _;
  _ = require('underscore');
  $ = require('jquery');
  Handlebars = require('handlebars');
  templates = {
    mobileClient: require('text!templates/mobile-client.handlebars')
  };
  utils = {
    tmpl: function(id, context) {
      var source, template;
      source = templates[id];
      template = Handlebars.compile(source);
      return template(context);
    }
  };
  return module.exports = utils;
});