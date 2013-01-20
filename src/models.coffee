(->
  _         = require 'lodash'
  mongoose  = require 'mongoose'

  mongoose.connect 'mongodb://localhost/party'

  Song =
    source: String
    score:
      type: Number
      default: 1
    uri: String
    duration: Number
    timestamp: Date

  partySchema = mongoose.Schema
    name: String
    loc: [Number]
    playing:
      type: Song
    songs: [Song]

  partySchema.index
    loc: "2d"

  partySchema.methods.voteSong = (uri, increment) ->
    song = null
    for s in this.songs
      if s.uri is uri
        s.score += increment
        song = s
    this.save()
    song

  partySchema.methods.upvoteSong = (uri) ->
    partySchema.methods.voteSong uri, 1

  partySchema.methods.downvoteSong = (uri) ->
    partySchema.methods.voteSong uri, -1
                
  partySchema.methods.addSong = (song) ->
    song.timestamp = Date.now()
    this.songs.push(song)
    this.save()
    song

  partySchema.methods.playNextSong = () ->
    if this.songs.length isnt 0
      # Pick highest scoring song
      next = _.max this.songs, (song) -> song.score
      this.songs = _.select this.songs, (song) -> song isnt next
      this.playing = next
      this.save()
    this.playing

  module.exports.Party = mongoose.model 'Party', partySchema
)()
