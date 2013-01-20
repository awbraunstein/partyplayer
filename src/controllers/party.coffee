# Controller for PARTY page routes
(->

  utils = require '../utils'
  Party = require('./../models').Party

  # GET -> root
  exports.index = (req,res) ->
    res.render 'index', title: 'Join a party'

  # GET -> party form
  exports.newParty = (req, res) ->
    res.render 'new_party',
      title: 'New Party'

  # POST
  exports.createParty = (req, res) ->
    p = new Party
      name:   req.params.name
      loc:    [req.params.latitude, req.params.longitude]
      songs:  []
    p.save (err, party) ->
      if not err
        res.send party

  # GET
  exports.playParty = (req, res) ->
    if req.xhr
      Party.findOne
        name: req.params.name
      , (err, p) ->
        if err or not p?
          res.send 404, "No such party found"
        else
          res.send p
    else
      res.render 'party',
        title: 'Party'

  # POST -> nearby parties
  exports.findParties = (req, res) ->
    loc = [
      req.body.latitude
    , req.body.longitude
    ]

    Party.find
      loc:
        $near: loc
    , (err, ps) ->
      if err
        res.send []
      else
        res.send ps

)()
