
init = (MONGO_CONFIG) ->
  # mongoの設定
  MONGO_DB_NAME = undefined
  MONGO_TARGET = undefined

  # mongo
  mongoOptions = {}
  mongo_urls = []
  for i in MONGO_CONFIG.HOSTS
    if MONGO_CONFIG.USER
      mongo_urls.push MONGO_CONFIG.USER + ':' + MONGO_CONFIG.PASSWORD + "@" + i
    else
      mongo_urls.push i

  MONGO_DB_NAME = MONGO_CONFIG.DB_NAME

  if global.testing
    MONGO_DB_NAME = MONGO_DB_NAME + '_test'

  MONGO_TARGETS = (mongo_urls.map (x) ->  ("mongodb://" + x + "/" + MONGO_DB_NAME))

  return MONGO_TARGETS


# default mongodb
MONGO_TARGETS = init(CONFIG.MONGO)
MONGO_TARGET = MONGO_TARGETS.join(",")

# mongoose
mongoose = require "mongoose"
mongoose.connect MONGO_TARGET
