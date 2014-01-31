# imports
express = require 'express'
app = module.exports = express()

# view
app.set "views", __dirname
app.set "view engine", "jade"

# routing
app.get "/", (req, res)=>
  res.render 'test'

# model
mongoose = require("mongoose")
message_schema = require('./model').message_schema

MessageSchema = new mongoose.Schema(message_schema, {
  # capped:
  #   size: 1024
  #   max: 1000
  #   autoIndexId: true
  })

exports.Message = Message = mongoose.model("Message", MessageSchema)


# socket and rest api -------------------

# 1. socket api
mongoose_socket = require('../mongoose-socket/index')

io = module.parent.exports.io


# mock authorization
io.configure ()->
  io.set 'authorization', (handshake, next)->

    handshake.session = {
      test: "test"
    }
    console.log 'socket.io authorization successed'

    handshake._session = {
      test: "test"
    }

    return next null, true

api = new mongoose_socket({
  name_space: 'test'
  collection_name: 'message'
  model: Message
  # use_stream: true
})

api.init(io)

# auth test
api.use (method, data, socket)=>
  console.log method, ' session: ', socket.handshake.session
  return true


# 2. rest api
rest = require('../mongoose-socket/rest')

rest_api = new rest({
  name_space: 'test'
  collection_name: 'message'
  model: Message
})

rest_api.use (query)=>
  query.conditions = query.conditions || {}
  # query.conditions['number'] = {"$gt": 6}
  return query

rest_api.init(app)

# 3. storage api

Storage = require('../mongoose-socket/storage')

storage = new Storage({})

storage.init(io)
