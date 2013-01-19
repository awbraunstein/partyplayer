(->

  staticController = require './controllers/static'

  module.exports.Router =
    static: staticController

)()
