DEFAULT = {
  DEVELOPMENT: true
  SERVER:
    PORT: 3000
  MONGO:
    HOSTS: "localhost:27017"
    USER: ""
    PASSWORD: ""
    DB_NAME: "shareprob_dev"
  REDIS:
    HOST: "localhost"
    PORT: 6379
    PASSWORD: null
}

configExtend = require('config-extend')

module.exports = (file_path) ->
  CONFIG = DEFAULT
  try
    file_path = '../../' + file_path
    CONFIG = configExtend CONFIG, require(file_path)
  catch

  global.CONFIG = CONFIG
