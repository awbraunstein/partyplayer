requirejs.config({
  paths: {
    jquery: '/lib/js/jquery-1.9.0.min',
    underscore: '/lib/js/underscore',
    backbone: '/lib/js/backbone',
    handlebars: '/lib/js/handlebars'
  },
  shim: {
    underscore: {
      deps: [],
      exports: '_'
    },
    backbone: {
      deps: ['underscore', 'jquery'],
      exports: 'Backbone'
    },
    handlebars: {
      deps: ['underscore'],
      exports: 'Handlebars'
    }
  }
});
define(function(require, exports, module) {
  var $, Backbone, PARTY_NAME_REGEX, PartyClient, PartyClientView, PartyPlayer, PartyPlayerView, init, initClient, initPlayer, sampleParty, sampleSong, sampleSong2, server, utils, _;
  PARTY_NAME_REGEX = /party\/(.+)/;
  _ = require('underscore');
  $ = require('jquery');
  Backbone = require('backbone');
  utils = require('utils');
  server = require('server');
  PartyClient = require('models/partyClient');
  PartyPlayer = require('models/partyPlayer');
  PartyClientView = require('views/partyClient');
  PartyPlayerView = require('views/partyPlayer');
  initClient = function(party) {
    var $partyClient, clientView;
    $partyClient = $('#party-client');
    clientView = new PartyClientView({
      model: new PartyClient(party)
    });
    $partyClient.empty().append(clientView.$el);
    return clientView.render();
  };
  initPlayer = function(party) {
    var $partyPlayer, m, playerView;
    $partyPlayer = $('#party-player');
    m = new PartyPlayer(party);
    console.log(m);
    playerView = new PartyPlayerView({
      model: m
    });
    $partyPlayer.empty().append(playerView.$el);
    return playerView.render();
  };
  sampleSong = {
    source: 'Youtube',
    score: 4,
    uri: 'KlujizeNNQM',
    duration: 5000,
    timestamp: Date.now()
  };
  sampleSong2 = {
    source: 'Soundcloud',
    score: 3,
    uri: '/tracks/297',
    duration: 399151,
    timestamp: Date.now()
  };
  sampleParty = {
    name: 'rad party',
    loc: [39, -75],
    playing: sampleSong,
    songs: [sampleSong, sampleSong2]
  };
  init = function() {
    var matched;
    matched = window.location.pathname.match(PARTY_NAME_REGEX);
    if (matched) {
      server.getPartyInfo(matched[1], function(partyData) {
        console.log(partyData);
        return $(function() {
          return initPlayer(partyData);
        });
      });
      return;
    }
    if (!('geolocation' in navigator)) {
      console.log('not supported in browser');
    }
    return navigator.geolocation.getCurrentPosition(function(position) {
      console.log('finding nearby parties...');
      return server.findParties(position.coords, function(parties) {
        if (parties != null) {
          return $(function() {
            return initClient(parties[0]);
          });
        } else {
          return console.log('No parties!');
        }
      });
    });
  };
  init();
  return null;
});