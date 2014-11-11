Validator = require('mongoose-validator')
Validator.localization('jp')
validate = Validator.validate

message_schema = {
  content:
    type: String
    required: true
    validate: [validate('len', 3, 10)]
    help_text: '3文字から10文字'
  number:
    type: Number
    default: 0
}

mongoose = require("mongoose")

MessageSchema = new mongoose.Schema(message_schema, {
  # capped:
  #   size: 1024
  #   max: 1000
  #   autoIndexId: true
  })

exports.Message = Message = mongoose.model("Message", MessageSchema)
