define (require, exports, module) ->

  $         = require 'jquery'
  _         = require '/lib/js/lodash.js'
  Backbone  = require '/lib/js/backbone.js'

  exports.partyClient = _.extend Backbone.Model
    
    url: () ->
      "/party/#{this.id}"

  module.exports = server
