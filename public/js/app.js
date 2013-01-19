requirejs.config({
  paths: {
    jquery: '/lib/js/jquery-1.9.0.min',
    underscore: '/lib/js/underscore',
    backbone: '/lib/js/backbone',
    handlebars: '/lib/js/handlebars'
  },
  shim: {
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
  var $, Backbone, Party, PartyClientView, SearchView, init, initClient, sampleParty, sampleSong, server, utils, _;
  _ = require('underscore');
  $ = require('jquery');
  Backbone = require('backbone');
  utils = require('utils');
  server = require('server');
  Party = require('models/party');
  PartyClientView = require('views/partyClient');
  SearchView = require('views/search');
  initClient = function(party) {
    var $partyClient, clientView, searchView;
    $partyClient = $('#party-client');
    clientView = new PartyClientView({
      model: new Party(party)
    });
    $partyClient.empty().append(clientView.$el);
    clientView.render();
    searchView = new SearchView();
    return searchView.search('Trey anastasio', function(source, results) {
      console.log(source);
      return console.log(results);
    });
  };
  sampleSong = {
    type: 'Spotify',
    score: 4,
    uri: 'http://open.spotify.com/track/31yCrPeqVYke01Un3jPVWk',
    title: 'Alligator',
    artist: 'The Babies',
    timestamp: Date.now
  };
  sampleParty = {
    name: 'rad party',
    loc: [39, -75],
    playing: sampleSong,
    requests: [sampleSong]
  };
  init = function() {
    if (!('geolocation' in navigator)) {
      console.log('not supported in browser');
    }
    return navigator.geolocation.getCurrentPosition(function(position) {
      console.log('finding nearby parties...');
      return server.findParties(position.coords, function(parties) {
        console.log(parties);
        return $(function() {
          return initClient(sampleParty);
        });
      });
    });
  };
  init();
  $(function() {
    return console.log('DOM ready');
  });
  return null;
});
