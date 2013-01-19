(function() {
  exports.index = function(req, res) {
    return res.render('index', {
      title: 'Index page'
    });
  };
  return exports.notFound = function(req, res) {
    return res.render('404', {
      title: 'Not found'
    });
  };
})();