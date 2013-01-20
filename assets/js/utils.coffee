define (require, exports, module) ->

  _           = require 'underscore'
  $           = require 'jquery'
  Handlebars  = require 'handlebars'

  # Load all necessary handlebars templates here, then access them during
  # compilation process in `utils.tmpl`
  templates =
    mobileClient: require 'text!templates/mobile-client.handlebars'
    trackItem:    require 'text!templates/track-item.handlebars'
    partyPlayer:  require 'text!templates/player.handlebars'

  # Compile the templates!
  for id, source of templates
    templates[id] = Handlebars.compile source

  utils =

    tmpl: (id, context) ->
      templates[id] context

  module.exports = utils
