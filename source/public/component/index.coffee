
# imports
oo = ko.observable
oa = ko.observableArray
$ = require('jquery')
mgsc = require('./mongoose-socket-client')


# create adapters and socket
Model = mgsc.Model
SocketAdapter = mgsc.adapter.socket
RestAdapter = mgsc.adapter.rest
socket = SocketAdapter.create_socket('test', io)

# schema
message_schema = require('./message/model').message_schema

# knockout view model
class ApplicationViewModel
  constructor: ()->

    # adapters
    adapter = new SocketAdapter({
      socket: socket
    })
    # adapter = new RestAdapter({
    #   name_space: 'test'
    # })
    

    # model
    @messages_model = new Model({
      name_space: 'test'
      collection_name: 'message'
      model: message_schema
      adapter: adapter
    })

    # list
    @messages = @messages_model.find {}

    # each document
    @msg = @messages_model.findOne {}

    # count(aggregation)
    @count = @messages_model.count {}

    # general aggregation framework
    @calculated = @messages_model.aggregate {array:[
      {
        $group:
          _id: 'sum'
          count:
            $sum: 1
          number_sum:
            $sum: '$number'
      }
    ]}
    
    # for new item
    @content = oo("")

  # paging
  view_page: (page)=>
    @messages.query.page = page
    @messages.update()

  # create
  create: ()=>
    rnd = Math.floor((Math.random() * 10))
    bl = @messages_model.create {doc: {'content': @content(), 'number': rnd}}
    if bl
      @content("")

  # update
  update: (doc)=>
    @messages_model.update {conditions: {'_id': doc._id}, update: doc}

  # delete
  remove: (doc)=>
    @messages_model.remove {conditions: {'_id': doc._id}}

app = app || {}

app.vm = new ApplicationViewModel

$(document).ready =>
  ko.applyBindings app.vm

module.exports = app
