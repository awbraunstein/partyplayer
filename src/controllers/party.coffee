# Controller for PARTY page routes
(->

  Party = require('./../models').Party

  exports.createParty = (req, res) ->
    res.render 'create_party',
      title: 'Join a party'

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
    console.log 'findParties! *****************************'
    console.log req.params
    loc = [
      req.params.latitude
    , req.params.longitude
    ]

    ps = Party.find
      $within:
        $center: [loc, 0.1]

    # res.send ps
    res.send []

)()
