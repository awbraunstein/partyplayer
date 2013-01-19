# Entry point for client-side javascript app.
define (require, exports, module) ->

  # Module dependencies
  _       = require '/lib/js/lodash.js'
  $       = require 'jquery'
  utils   = require 'utils'

  $ ->
    console.log 'DOM ready'

  return null
