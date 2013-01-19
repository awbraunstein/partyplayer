# Controller for PARTY page routes
(->

  Party = require('./../models').Party

  exports.index = (req,res) ->
    res.render 'index', title: 'Join a party'

  exports.createParty = (req, res) ->
    p = new Party
      name:   req.params.name
      loc:    [req.params.latitude, req.params.longitude]
      songs:  []
    p.save (err, party) ->
      if not err
        res.send party

  exports.partyAdmin = (req, res) ->
    Party.findById req.params.id, (err, p) ->
      if err
        res.send 404, "No such party found"
      else
        res.render 'party_admin',
          title: 'Party admin'
          party: p

  exports.party = (req, res) ->
    Party.findById req.params.id, (err, p) ->
      if err
        res.send 404, "No such party found"
      else
        res.render 'party',
          title: 'View party'
          party: p

  exports.findParties = (req, res) ->
    loc = [
      req.body.latitude
    , req.body.longitude
    ]

    ps = Party.find
      $within:
        $center: [loc, 0.1]

    # res.send ps
    res.send []

)()
