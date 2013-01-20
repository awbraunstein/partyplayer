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
  var $, Backbone, PartyClient, PartyClientView, init, initClient, server, utils, _;
  _ = require('underscore');
  $ = require('jquery');
  Backbone = require('backbone');
  utils = require('utils');
  server = require('server');
  PartyClient = require('models/partyClient');
  PartyClientView = require('views/partyClient');
  initClient = function(party) {
    var $partyClient, clientView;
    $partyClient = $('#party-client');
    clientView = new PartyClientView({
      model: new PartyClient(party)
    });
    $partyClient.empty().append(clientView.$el);
    return clientView.render();
  };
  init = function() {
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
  $(function() {
    return console.log('DOM ready');
  });
  return null;
});