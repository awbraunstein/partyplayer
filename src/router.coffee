(->

  staticController = require './controllers/static'
  partyController  = require './controllers/party'

  module.exports.Router =
    static: staticController
    party:  partyController

)()

