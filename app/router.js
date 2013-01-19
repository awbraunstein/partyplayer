(function() {
  var partyController, staticController;
  staticController = require('./controllers/static');
  partyController = require('./controllers/party');
  return module.exports.Router = {
    static: staticController,
    party: partyController
  };
})();