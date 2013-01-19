(function() {
  var Party;
  Party = require('./../models').Party;
  exports.createParty = function(req, res) {
    return res.render('create_party', {
      title: 'Join a party'
    });
  };
  exports.partyAdmin = function(req, res) {
    return Party.findById(req.params.id, function(err, p) {
      if (err) {
        return res.send(404, "No such party found");
      } else {
        return res.render('party_admin', {
          title: 'Party admin',
          party: p
        });
      }
    });
  };
  exports.party = function(req, res) {
    return Party.findById(req.params.id, function(err, p) {
      if (err) {
        return res.send(404, "No such party found");
      } else {
        return res.render('party', {
          title: 'View party',
          party: p
        });
      }
    });
  };
  return exports.findParties = function(req, res) {
    var loc, ps;
    loc = [req.body.latitude, req.body.longitude];
    ps = Party.find({
      $within: {
        $center: [loc, 0.1]
      }
    });
    return res.send([]);
  };
})();