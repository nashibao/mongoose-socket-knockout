express = require 'express'
app = module.exports = express()

app.set "views", __dirname
app.set "view engine", "jade"

app.get "/", (req, res)=>
  res.render 'index'

# model

mongoose = require("mongoose")
message_schema = require('./model').message_schema

MessageSchema = new mongoose.Schema(message_schema)

exports.Message = Message = mongoose.model("Message", MessageSchema)

# api

mongoose_socket = require('mongoose-socket-server')

io = module.parent.exports.io

api = new mongoose_socket({
  name_space: 'test'
  collection_name: 'message'
  model: Message
})

api.init(io)


# rest api

rest = require('mongoose-socket-server/rest')

rest_api = new rest({
  collection_name: 'message'
  model: Message
})

rest_api.init(app)

