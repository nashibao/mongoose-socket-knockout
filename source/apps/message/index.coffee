# imports
express = require("express")
app = express.Router()

# routing
app.get "/", (req, res)=>
  res.render 'test'

module.exports = app
