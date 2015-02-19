# things we need
Router = require './rally/route-manager'
routes = require './data/routes.json'
express = require 'express'

#config info (from .env)
dotenv = require 'dotenv'
dotenv.load()

## display stuff
#the pitft framebuffer display

if "#{process.env.ISPI}" == "1"
  FBui = require './display/fb'
  fbui = new FBui

## rally stuff
router = new Router(routes)

#web stuff
app = new express()

app.use (request, response, next)->
  console.log response.statusCode, request.path, ":", Date.now()
  next()

app.use "/public", express.static(__dirname + '/public')

app.get "/routes", (request, response)->
  response.json router.all()
  router.save()

app.get "/odo", (request, response)->
  response.json true
  fbui.updateData
    odo: Date.now()
    cast: 32
    instruction: "asdfaslkdfalskdfj"

app.get "/routes/:id", (request, response)->
  response.json router.byId(request.params.id)

app.post "/routes", (request, response)->
  response.json router.addRoute request.body
  router.save()

app.post "/routes/:id", (request, response)->
  response.json router.updateById request.body
  router.save()

app.get "/", (request, response)->
  response.sendfile(__dirname + '/web/index.html')

app.listen 8090
# blah = router.first()
# blah.addStep { "cast": 35, "distance": 0, "length": 1234, "instructions": "second" }

# console.log blah.allsteps()

# router.save()