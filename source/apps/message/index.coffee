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

api = new mongoose_socket("test", "message", Message, io)

api.create()
