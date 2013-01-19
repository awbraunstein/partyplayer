(function() {
  var DIRNAME, PORT, app, assets, express, router;
  DIRNAME = process.cwd();
  PORT = process.env.PORT || process.env.VMC_APP_PORT || 3000;
  express = require('express');
  assets = require('connect-assets');
  router = require('./router').Router;
  app = module.exports = express();
  app.configure(function() {
    app.set('views', "" + DIRNAME + "/views");
    app.set('view engine', 'jade');
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
    app.locals.pretty = true;
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
  app.get('/', router.static.index);
  app.listen(PORT, function() {
    return console.log("Listening on " + PORT + " in " + app.settings.env + " mode");
  });
  return null;
})();