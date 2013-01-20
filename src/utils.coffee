(->
  # Expose utility functions used throughout your app simply by adding them as
  # properties to the `exports` global variable.

  _ = require 'lodash'

  encodeTrack = (track) ->
    _.extend track,
      _id: track._id.toString()
      timestamp: track.timestamp.toString()

  exports.encodeParty = (party) ->
    _.extend party, '_id',
      _id: party._id.toString()
      playing: encodeTrack party.playing
      played: _.map party.played, encodeTrack
      songs: _.map party.songs, encodeTrack

)()
