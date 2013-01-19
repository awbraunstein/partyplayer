define (require, exports, module) ->

  _  = require '/lib/js/lodash.js'
  $  = require 'jquery'

  require '/lib/js/handlebars.js'

  utils =

    tmpl: (id, context) ->
      source = $("##{id}-tmpl").html()
      template = Handlebars.compile source
      return template(context)

  module.exports = utils
