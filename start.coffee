# things we need
Router = require './rally/route-manager'
RallyComputer = require './rally/rally-computer'
routes = require './data/routes.json'
express = require 'express'

#config info (from .env)
dotenv = require 'dotenv'
dotenv.load()



## rally stuff
router = new Router(routes)
comp = new RallyComputer

## display stuff
#the pitft framebuffer display
console.log "pitft enabled: ", "#{process.env.ISPI}" == "1"
if "#{process.env.ISPI}" == "1"
  FBui = require './display/fb'
  fbui = new FBui
  do timer = ()->
    setInterval ()->
      fbui.draw()
    ,
    100

#web stuff
app = new express()

app.use (request, response, next)->
  console.log response.statusCode, request.path, ":", Date.now()
  next()

app.use "/public", express.static(__dirname + '/public')

app.get "/routes", (request, response)->
  response.json router.all()
  router.save()

app.get "/routes/:id", (request, response)->
  response.json router.byId(request.params.id)

app.post "/routes", (request, response)->
  response.json router.addRoute request.body
  router.save()

app.get "/update", (request, response)->
  response.json true
  fbui.updateData
    cast: Math.floor(Math.random()*100)
    odo: Date.now()

app.get "/updates", (request, response)->
  response.json true
  fbui.updateData
    cast: Math.floor(Math.random()*10)
    odo: Date.now() / 22

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