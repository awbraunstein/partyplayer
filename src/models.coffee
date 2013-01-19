mongoose = require 'mongoose'
mongoose.connect 'mongodb://localhost/party'

partySchema = mongoose.Schema name: String,
  songs: [type: String, score: Number, uri: String]

module.exports.Party = mongoose.model('Party', partySchema)
