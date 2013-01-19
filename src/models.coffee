(->
  mongoose = require 'mongoose'
  mongoose.connect 'mongodb://localhost/party'

  Song =
    type: String
    score: Number
    uri: String
    timestamp:
      type: Date
      default: Date.now

  partySchema = mongoose.Schema
    name: String
    loc: [Number]
    playing:
      type: Song
    songs: [Song]

  partySchema.index loc: "2d"

  partySchema.methods.voteSong = (song, increment) ->
    for s in this.songs
      if s is song
        s.score += increment

  partySchema.methods.upvoteSong = (song) ->
    partySchema.methods.voteSong 1

  partySchema.methods.upvoteSong = (song) ->
    partySchema.methods.voteSong -1
                
  partySchema.methods.addSong = (song) ->
    this.songs.push(song)
    this.model('Party').save()

  partySchema.methods.playNextSong = (song) ->
    null

  module.exports.Party = mongoose.model('Party', partySchema)
)()
