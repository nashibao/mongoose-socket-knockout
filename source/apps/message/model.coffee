Validator = require('mongoose-validator')
Validator.localization('jp')
validate = Validator.validate

message_schema = {
  content:
    type: String
    required: true
    validate: [validate('len', 3, 10)]
    help_text: '3文字から10文字'
}

exports.message_schema = message_schema
