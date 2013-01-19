(function() {
  var staticController;
  staticController = require('./controllers/static');
  return module.exports.Router = {
    static: staticController
  };
})();