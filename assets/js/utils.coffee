define (require, exports, module) ->

  _  = require '/lib/js/lodash.js'
  $  = require 'jquery'

  utils =

    someFunction: () ->
      return null


  module.exports = utils
