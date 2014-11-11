
Message = require('./model').Message

# # socket and rest api -------------------

# 1. socket api
mongoose_socket = require('../mongoose-socket/index')

io = global.io

# # mock authorization
# io.configure ()->
io.set 'authorization', (request, next)->

  request.session = {
    test: "test"
  }
  console.log 'socket.io authorization successed'

  request._session = {
    test: "test"
  }
  return next null, true

api = new mongoose_socket({
  name_space: 'test'
  collection_name: 'message'
  model: Message
  # use_stream: true
})

api.init(io)

# auth test
api.use (method, data, socket)=>
  console.log method, ' session: ', socket.request.session
  return true


# # 2. rest api
# rest = require('../mongoose-socket/rest')

# rest_api = new rest({
#   name_space: 'test'
#   collection_name: 'message'
#   model: Message
# })

# rest_api.use (query)=>
#   query.conditions = query.conditions || {}
#   # query.conditions['number'] = {"$gt": 6}
#   return query

# rest_api.init(app)

# # 3. storage api

Storage = require('../mongoose-socket/storage')

storage = new Storage({
  set: (req, res, next) ->
    console.log 'storage, set'
    next()
  })

storage.init(io)