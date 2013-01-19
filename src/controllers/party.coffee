# Controller for PARTY page routes
(->

  Party = require('./../models').Party

  exports.createParty = (req,res) ->
    res.render('create_party')

  exports.partyAdmin = (req,res) ->
    Party.findById req.params.id, (err,p) ->
      if err
        res.send(404, "No such party found")        
      else
        res.render('party_admin', party: p)

  exports.party = (req,res) ->
    Party.findById req.params.id, (err,p) ->
      if err
        res.send(404, "No such party found")
      else
        res.render('party', party: p)

)()
