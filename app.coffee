
app_name = "test"

express = require "express"

app = express()

mongoose = require "mongoose"

flash = require('connect-flash')
RedisStore = require('connect-redis')(express)

local_settings = require('./local_config').settings

redisOptions = {
    prefix: app_name + ':',
    host: local_settings.LOCAL_REDIS_HOST,
    port: local_settings.LOCAL_REDIS_PORT,
    pass: local_settings.LOCAL_REDIS_PASSWORD
}

mongoOptions = {}
mongoOptions['url'] = local_settings.LOCAL_MONGO_URL

app.configure ->
  app.set "port", process.env.PORT or 8060
  app.set "views", __dirname + "/views"
  app.set "view engine", "jade"
  app.use express.favicon()
  app.use express.logger("dev")
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser()

  app.use express.session({
    secret: 'secret session key',
    store: new RedisStore(redisOptions),
    cookie: {
      maxAge: false
    }
  })

  app.use flash()

  app.use (req, res, next) ->
    res.locals.originalUrl = req.originalUrl
    res.locals.session = req.session
    .locals.user = (true and req.session.username)
    next()

  app.use app.router

  app.use express.static(require("path").join(__dirname, "./public"))

model_init = (url, db_name)->
  mongoose.connect url + "/" + db_name

app.configure "development", ->
  model_init mongoOptions.url, app_name + "_dev"
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )

if module.parent
  return

module.exports = app

server = require("http").createServer(app)

server.listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")

io = require('socket.io').listen(server)

module.exports.io = io

app.use require('test')
require('model')
