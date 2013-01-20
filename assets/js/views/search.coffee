define (require, exports, module) ->

  $          = require 'jquery'
  _          = require 'underscore'
  utils     = require 'utils'
  Backbone   = require 'backbone'

  SEARCH_RESULT_SELECTOR = '#search-results'

  # Extend this view to add search capability to your backbone view
  exports.SearchView = Backbone.View.extend

    autoCompleteDebounce: (e) ->
      # Check if key up was a letter or backspace
      if (e.keyCode >= 65 and e.keyCode <= 90) or e.keyCode == 8
        _.debounce @autoCompleteSearch(e), 500

    autoCompleteSearch: (e) ->
      $results = @$(SEARCH_RESULT_SELECTOR)
      partyID  = @model.get 'id'

      $results.empty()
      query = @$('#search').val()
      if query.length < 4
        return

      @searchModel.search query, (source, results) ->
        # Render each search result in the results div
        # Because of the excessive time it would take to create Backbone views,
        # we use raw strings here instead.
        for res in results
          if _.isObject res
            html = utils.tmpl 'searchResult', res
            $results.append html
      return null

    clearSearch: (e) ->
      @$(SEARCH_RESULT_SELECTOR).empty()
