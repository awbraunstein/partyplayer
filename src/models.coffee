(->
  mongoose = require 'mongoose'
  mongoose.connect 'mongodb://localhost/party'


  partySchema = mongoose.Schema name: String,
    loc: [Number],
    songs: [type: String, score: Number, uri: String]

  partySchema.index loc: "2d"

  module.exports.Party = mongoose.model('Party', partySchema)
)()
