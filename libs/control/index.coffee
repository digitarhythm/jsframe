express = require("express")
app = express()
Promise = require("bluebird")
http = require("http").Server(app)
https = require("https")
path = require("path")
config = require("config")
fs = require("fs-extra")
SPLog = require("ndlog").echo
ECT = require("ect")
api = require("../control/api.min.js")

network = config.network
node_env = process.env.NODE_ENV

__homedir = __dirname+"/../../.."

app.set("views", path.join(__homedir, "/libs/template"))
ectRenderer = ECT({ watch: true, root: __homedir + "/libs/template", ext : ".ect" })
app.engine("ect", ectRenderer.render)
app.set("view engine", "ect")

app.use('/plugins', express.static(__homedir+'/plugins'))
app.use('/public', express.static(__homedir+'/public'))
app.use('/view', express.static(__homedir+'/apps/js/view'))
app.use("/api", api)

app.get "/", (req, res) ->
  #==========================================================================
  # make directory file list
  #==========================================================================
  readFileList = (path) ->
    return new Promise (resolve, reject) ->
      fs.readdir path, (err, lists) ->
        if (err)
          reject(err)
        else
          resolve(lists)

  jsfilelist = []
  readFileList(__homedir+"/plugins").then (lists) ->
    for fname in lists
      if (fname.match(/^.*\.js$/))
        jsfilelist.push("/plugins/#{fname}")
    return 1
  .then (ret) ->
    readFileList(__homedir+"/apps/js/view").then (lists) ->
      filelist = []
      for fname in lists
        if (fname.match(/^.*\.min\.js$/) and !fname.match(/main\.min\.js/) and !fname.match(/library\.min\.js/))
          jsfilelist.push("view/#{fname}")
      return 1
  .then (ret) ->
    res.render "main",
      jsfilelist: jsfilelist
      node_env:node_env
  .catch (err) ->
    console.error(err)
    process.exit(1)

#==============================================================================
# run server
#==============================================================================
if (config.network? && config.network.port?)
  port = config.network.port
else
  port = if (node_env == "develop") then 3001 else 3000

switch (config.network.protocol)
  when "http"
    http.listen port, ->
      console.log("listening on *:", port)
  when "https"
    options =
      key: fs.readFileSync(config.network.ssl_key)
      cert: fs.readFileSync(config.network.ssl_cert)
    server = https.createServer(options, app)
    server.listen(port)
    console.log("listening on *:", port)

