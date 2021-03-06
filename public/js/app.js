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
  var $, Backbone, NEW_PARTY_REGEX, PARTY_NAME_REGEX, PartyClient, PartyClientView, PartyPlayer, PartyPlayerView, init, initClient, initPartyForm, initPlayer, initSpinner, server, utils, _;
  PARTY_NAME_REGEX = /party\/(.+)/;
  NEW_PARTY_REGEX = /\/new$/;
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
    var $partyPlayer, playerView;
    $partyPlayer = $('#party-player');
    playerView = new PartyPlayerView({
      model: new PartyPlayer(party)
    });
    $partyPlayer.empty().append(playerView.$el);
    return playerView.render();
  };
  initPartyForm = function(position) {
    $('input[name=latitude]').val(position.coords.latitude);
    $('input[name=longitude]').val(position.coords.longitude);
    return null;
  };
  initSpinner = function() {
    var spinner, target;
    target = document.getElementById('spin');
    return spinner = new Spinner({}).spin(target);
  };
  init = function() {
    var matched;
    initSpinner();
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
      if (window.location.pathname.match(NEW_PARTY_REGEX)) {
        $(function() {
          return initPartyForm(position);
        });
        return;
      }
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