require('knockout')
oo = ko.observable
oa = ko.observableArray
$ = require('jquery')
Model = require('./mongoose-socket-client').Model

app = {}

socket = Model.create_socket('test', io)

class ApplicationViewModel
  constructor: ()->
    @messages_model = new Model('test', 'message', {}, socket)
    @messages = @messages_model.find {}
    @count = @messages_model.count {}

    @content = oo("")

  create: ()=>
    @messages_model.create {'content': @content()}
    @content("")

  update: (doc)=>
    @messages_model.update {'_id': doc._id}, doc

  remove: (doc)=>
    @messages_model.remove {'_id': doc._id}

app.vm = new ApplicationViewModel

$(document).ready =>
  ko.applyBindings app.vm

module.exports = app
