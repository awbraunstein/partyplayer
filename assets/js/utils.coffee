define (require, exports, module) ->

  _           = require 'underscore'
  $           = require 'jquery'
  Handlebars  = require 'handlebars'

  # Load all necessary handlebars templates here, then access them during
  # compilation process in `utils.tmpl`
  templates =
    mobileClient: require 'text!templates/mobile-client.handlebars'
    partyPlayer: require 'text!templates/player.handlebars'

  utils =

    tmpl: (id, context) ->
      source = templates[id]
      template = Handlebars.compile source
      return template(context)

  module.exports = utils
