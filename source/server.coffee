express = require("express")
path = require("path")
favicon = require("serve-favicon")
logger = require("morgan")
cookieParser = require("cookie-parser")
bodyParser = require("body-parser")
flash = require('connect-flash')
session = require('express-session')
RedisStore = require('connect-redis')(session)
app = express()

# 設定
require('./config')()

# MongoDB設定
require('./mongodb')

# ポート
app.set "port", CONFIG.SERVER.PORT

# view engine setup
app.set "views", path.join(__dirname, "/views")
app.set "view engine", "jade"
app.set "cookieSessionKey", "Qr22vnjVmDjKJD"
app.set "secretKey", "HzmZpXUU6UXt3e"

# uncomment after placing your favicon in /public
#app.use(favicon(__dirname + '/public/favicon.ico'));
app.use logger("dev")
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: false)
app.use cookieParser()
app.set 'sessionStore', new RedisStore({
      host: CONFIG.REDIS.HOST
      port: CONFIG.REDIS.PORT
      pass: CONFIG.REDIS.PASSWORD
    })

sessionMiddleware = session({
  store: app.get 'sessionStore'
  key: app.get 'cookieSessionKey'
  secret: "HzmZpXUU6UXt3e"
  resave: true
  saveUninitialized: true
  cookie:
    maxAge: false
})

app.use sessionMiddleware

app.use express.static(path.join(__dirname, "/public"))

# flash
app.use flash()

app.use (req, res, next) ->
  res.locals.session = req.session
  res.locals.message = req.flash()
  next()

# モジュール
app.use "/", require("./apps/message")

# catch 404 and forward to error handler
app.use (req, res, next) ->
  err = new Error("Not Found")
  err.status = 404
  next err
  return

# error handlers

# development error handler
# will print stacktrace
if CONFIG.DEVELOPMENT
  app.use (err, req, res, next) ->
    res.status err.status or 500
    res.render "error",
      message: err.message
      error: err

    return

# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
  res.status err.status or 500
  res.render "error",
    message: err.message
    error: {}

  return

grunt = require('grunt')
grunt.tasks(['watch'])

# # socket.io
Server = require("http").Server
ioserver = Server(app)
io = require("socket.io")(ioserver)

# http://stackoverflow.com/questions/25532692/how-to-share-sessions-with-socket-io-1-x-and-express-4-x
io.use (socket, next) ->
  sessionMiddleware(socket.request, socket.request.res, next)

# server.listen(3001)
global.io = io

ioserver.listen(3001)

# www server
debug = require("debug")("ShareProb")
server = app.listen(app.get("port"), ->

  console.log "Express server listening on port " + server.address().port
  return
)

require('./apps/message/rpc')

# io.on 'connection', (socket) ->
#   console.log 'connected', socket
#   socket.emit 'news', { hello: 'world' }
#   socket.on 'my other event', (data) ->
#     console.log(data)