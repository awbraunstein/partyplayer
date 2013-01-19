define(function(require, exports, module) {
  var $, utils, _;
  _ = require('/lib/js/lodash.js');
  $ = require('jquery');
  require('/lib/js/handlebars.js');
  utils = {
    tmpl: function(id, context) {
      var source, template;
      source = $("#" + id + "-tmpl").html();
      template = Handlebars.compile(source);
      return template(context);
    }
  };
  return module.exports = utils;
});