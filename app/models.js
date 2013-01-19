(function() {
  var Song, mongoose, partySchema;
  mongoose = require('mongoose');
  mongoose.connect('mongodb://localhost/party');
  Song = {
    type: String,
    score: Number,
    uri: String,
    timestamp: {
      type: Date,
      "default": Date.now
    }
  };
  partySchema = mongoose.Schema({
    name: String,
    loc: [Number],
    playing: {
      type: Song
    },
    songs: [Song]
  });
  partySchema.index({
    loc: "2d"
  });
  partySchema.methods.voteSong = function(song, increment) {
    var s, _i, _len, _ref, _results;
    _ref = this.songs;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      s = _ref[_i];
      _results.push(s === song ? s.score += increment : void 0);
    }
    return _results;
  };
  partySchema.methods.upvoteSong = function(song) {
    return partySchema.methods.voteSong(1);
  };
  partySchema.methods.upvoteSong = function(song) {
    return partySchema.methods.voteSong(-1);
  };
  partySchema.methods.addSong = function(song) {
    this.songs.push(song);
    return this.model('Party').save();
  };
  partySchema.methods.playNextSong = function(song) {
    return null;
  };
  return module.exports.Party = mongoose.model('Party', partySchema);
})();