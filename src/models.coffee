(->
  _         = require 'lodash'
  mongoose  = require 'mongoose'

  mongoose.connect 'mongodb://localhost/party'

  Song =
    source: String
    artist: String
    title: String
    album_art: String
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
    played: [Song]

  partySchema.set 'toJSON',
    getters: true
  partySchema.index
    loc: "2d"

  partySchema.methods.upvoteSong = (uri) ->
    song = _.find(this.songs, (s) -> s.uri is uri)
    song.score += 1
    this.save()
    song

  partySchema.methods.downvoteSong = (uri) ->
    song = _.find(this.songs, (s) -> s.uri is uri)
    song.score -= 1
    this.save()
    song
                
  partySchema.methods.addSong = (song) ->
    song.timestamp = Date.now()
    this.songs.push(song)
    this.save()
    song

  partySchema.methods.playNextSong = (uri) ->
    nextSong = _.find(this.songs, (s) -> s.uri is uri)
    newSongs = _.reject(this.songs, (s) -> s.uri is uri)
    this.played.push(this.playing)
    this.songs = newSongs
    this.playing = nextSong
    this.save()
    this.playing

  module.exports.Party = mongoose.model 'Party', partySchema
)()
