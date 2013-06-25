require('knockout')
oo = ko.observable
oa = ko.observableArray
$ = require('jquery')
Model = require('./mongoose-socket-client').Model
SocketAdapter = require('./mongoose-socket-client/adapter').socket
RestAdapter = require('./mongoose-socket-client/adapter').rest
message_schema = require('./message/model').message_schema

app = {}
app.message_schema = message_schema

socket = SocketAdapter.create_socket('test', io)

class ApplicationViewModel
  constructor: ()->
    # adapter = new SocketAdapter({
    #   socket: socket
    # })
    adapter = new RestAdapter()
    @messages_model = new Model({
      name_space: 'test'
      collection_name: 'message'
      model: message_schema
      adapter: adapter
    })

    @messages = @messages_model.find {}

    @count = @messages_model.count {}
    
    @content = oo("")

  create: ()=>
    bl = @messages_model.create {doc: {'content': @content()}}
    if bl
      @content("")

  update: (doc)=>
    @messages_model.update {conditions: {'_id': doc._id}, update: doc}

  remove: (doc)=>
    @messages_model.remove {conditions: {'_id': doc._id}}

app.vm = new ApplicationViewModel

$(document).ready =>
  ko.applyBindings app.vm

module.exports = app
