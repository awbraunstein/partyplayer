# Controller for static page routes
(->

  exports.index = (req, res) ->
    res.render 'index',
      title: 'Index page'

  exports.notFound = (req, res) ->
    res.render '404',
      title: 'Not found'

)()
