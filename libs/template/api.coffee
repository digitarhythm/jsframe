express = require("express")
router = express.Router()
Promise = require("bluebird")
path = require("path")
config = require("config")
fs = require("fs-extra")
SPLog = require("ndlog").echo
packjson = require("../../package.json")

router.get "/:endpoint", (req, res) ->
  endpoint = req.params.endpoint
  switch (endpoint)
    when 'version'
      ver = packjson.version
      res.json
        version: ver





module.exports = router
