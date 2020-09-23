express = require("express")
router = express.Router()
Promise = require("bluebird")
path = require("path")
config = require("config")
fs = require("fs-extra")
echo = require("ndlog").echo
packjson = require("../../../package.json")

router.use(express.json())
router.use(express.urlencoded({ extended: true }))

router.post "/:endpoint", (req, res) ->
  endpoint = req.params.endpoint
  body = req.body

  switch (endpoint)
    when 'version'
      ret =
        version: packjson.version
    else
      ret = undefined

  res.json(ret)

module.exports = router
