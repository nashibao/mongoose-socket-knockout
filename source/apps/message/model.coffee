
validate = require('mongoose-validator').validate

message_schema = {
  content:
    type: String
    required: true
    validate: [validate('len', 3, 10)]
}

exports.message_schema = message_schema
