require('knockout')
oo = ko.observable
oa = ko.observableArray
$ = require('jquery')
Model = require('./mongoose-socket-client').Model
message_schema = require('./message/model').message_schema

app = {}
app.message_schema = message_schema


socket = Model.create_socket('test', io)

class ApplicationViewModel
  constructor: ()->
    @messages_model = new Model('test', 'message', message_schema, socket)
    @messages = @messages_model.find {}
    @count = @messages_model.count {}

    @content = oo("")

  create: ()=>
    bl = @messages_model.create {'content': @content()}
    if bl
      @content("")

  update: (doc)=>
    @messages_model.update {'_id': doc._id}, doc

  remove: (doc)=>
    @messages_model.remove {'_id': doc._id}

app.vm = new ApplicationViewModel

$(document).ready =>
  ko.applyBindings app.vm

module.exports = app
