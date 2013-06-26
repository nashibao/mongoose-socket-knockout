require('knockout')
oo = ko.observable
oa = ko.observableArray
$ = require('jquery')
Model = require('./mongoose-socket-client').Model
SocketAdapter = require('./mongoose-socket-client/adapter').socket
RestAdapter = require('./mongoose-socket-client/adapter').rest
message_schema = require('./message/model').message_schema
d3_charts = require('simple-d3-charts')
pie = d3_charts.pie
line = d3_charts.line


app = {}
app.message_schema = message_schema

socket = SocketAdapter.create_socket('test', io)


class ApplicationViewModel
  constructor: ()->
    adapter = new SocketAdapter({
      socket: socket
    })
    # adapter = new RestAdapter()
    @messages_model = new Model({
      name_space: 'test'
      collection_name: 'message'
      model: message_schema
      adapter: adapter
    })

    @messages = @messages_model.find {}

    @count = @messages_model.count {}
    
    @content = oo("")

    # todo: dirty
    # pie charts---
    @pie_chart = false
    @line_chart = false
    $(document).ready ()=>
      @pie_chart = new pie("#pie-chart", {
          pie:
            width: 300
            height: 300
            r: 60
            ir: 30
        })
      # @line_chart = new line("#line-chart", {
      #     width: 600
      #     height: 300
      #     scale_x:
      #       min: 0
      #       max: 10
      #     scale_y:
      #       min: 0
      #       max: 10
      #   })

    @count.val.subscribe (d)=>
      nd = [
        {
          data_label: 'no'
          data_value: 10 - d
        },
        {
          data_label: 'yes'
          data_value: d
        }]
      @pie_chart.update(nd)

    # todo: dirty
    # progress bar charts---
    # @message_length = oa([])
    # @_message_length = {}
    # @update_cnt = 0

    # @messages.docs.subscribe (ds)=>
    #   line_d = []
    #   @update_cnt += 1
    #   cnt = 0
    #   for d in ds
    #     line_d.push {
    #       data_label: d.content
    #       x: cnt
    #       y: d.content.length
    #     }
    #     cnt += 1
    #     if d._id of @_message_length
    #       val = @_message_length[d._id]
    #       val.content(d.content.length)
    #       val.update_cnt = @update_cnt
    #     else
    #       val = {content: oo(d.content.length), update_cnt: @update_cnt}
    #       @_message_length[d._id] = val
    #       @message_length.push(val)
    #   removes = []
    #   for val in @message_length()
    #     if val.update_cnt != @update_cnt
    #       removes.push(val)
    #   for val in removes
    #     @message_length.remove(val)

    #   @line_chart.update(line_d)

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
