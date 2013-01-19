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

  partySchema.methods.voteSong = (uri, increment) ->
    for s in this.songs
      if s.uri is uri
        s.score += increment
        this.model('Party').save()
        return s

  partySchema.methods.upvoteSong = (uri) ->
    partySchema.methods.voteSong 1    

  partySchema.methods.downvoteSong = (uri) ->
    partySchema.methods.voteSong -1
                
  partySchema.methods.addSong = (song) ->
    this.songs.push(song)
    this.model('Party').save()
    for s in this.songs
      if s.uri is song.uri
        return s

  partySchema.methods.playNextSong = (uri) ->
    null

  module.exports.Party = mongoose.model('Party', partySchema)
)()
