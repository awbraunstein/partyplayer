(->
  _ = require 'lodash'
  mongoose = require 'mongoose'
  mongoose.connect 'mongodb://localhost/party'

  Song =
    source: String
    score:
      type: Number
      default: 1
    uri: String
    timestamp: Date

  partySchema = mongoose.Schema
    name: String
    loc: [Number]
    playing:
      type: Song
      default: {}
    songs: [Song]

  partySchema.index loc: "2d"

  partySchema.methods.voteSong = (song, increment) ->
    for s in this.songs
      if s is song
        s.score += increment
    this.save()

  partySchema.methods.upvoteSong = (song) ->
    partySchema.methods.voteSong 1    

  partySchema.methods.upvoteSong = (song) ->
    partySchema.methods.voteSong -1
                
  partySchema.methods.addSong = (song) ->
    song.timestamp = Date.now()
    console.log song
    console.log this.songs
    this.songs.push(song)
    console.log this.songs
    this.save()


  partySchema.methods.playNextSong = (song) ->
    if this.songs.length isnt 0
      # Pick highest scoring song
      next = _.max this.songs, (song) -> song.score
      this.songs = _.select this.songs, (song) -> song isnt next
      this.playing = next
      this.save()

  module.exports.Party = mongoose.model('Party', partySchema)
)()
