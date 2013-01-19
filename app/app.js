(function() {
  var DIRNAME, PORT, app, assets, express, io, router;
  DIRNAME = process.cwd();
  PORT = process.env.PORT || process.env.VMC_APP_PORT || 3000;
  express = require('express');
  assets = require('connect-assets');
  io = require('socket.io').listen(app);
  router = require('./router').Router;
  app = module.exports = express();
  app.configure(function() {
    app.set('views', "" + DIRNAME + "/views");
    app.set('view options', {
      layout: false
    });
    app.set('view engine', 'jade');
    app.locals.pretty = true;
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(express.cookieParser());
    app.use(express.session({
      secret: 'your secret here'
    }));
    app.use(app.router);
    app.use(express.static("" + DIRNAME + "/public"));
    return app.use(assets());
  });
  app.configure('development', function() {
    app.use(express.errorHandler({
      dumpExceptions: true,
      showStack: true
    }));
    console.log('\n========== Routes ==========');
    console.log(router);
    return console.log('============================\n');
  });
  app.configure('production', function() {
    return app.use(express.errorHandler());
  });
  app.get('/', router.party.createParty);
  app.get('/a/:id', router.party.partyAdmin);
  app.get('/:id', router.party.party);
  app.listen(PORT, function() {
    return console.log("Listening on " + PORT + " in " + app.settings.env + " mode");
  });
  io.sockets.on('connection', function(socket) {
    socket.on('joinparty', function(data) {
      var pdata;
      console.log(data);
      pdata = "";
      socket.party = data.id;
      socket.join(socket.party);
      socket.emit('joined', 'SERVER', "you have joined the " + socket.party + " party.");
      return socket.emit('populate', 'SERVER', pdata);
    });
    socket.on('createparty', function(data) {
      console.log(data);
      socket.party = data.id;
      socket.join(socket.party);
      return socket.emit('joined', 'SERVER', "you have joined the " + socket.party + " party.");
    });
    socket.on('addsong', function(data) {
      console.log(data);
      return io.sockets["in"](socket.party).emit('addsong', 'SERVER', data);
    });
    return socket.on('vote', function(data) {
      console.log(data);
      return io.sockets["in"](socket.party).emit('vote', 'SERVER', data);
    });
  });
  return null;
})();
