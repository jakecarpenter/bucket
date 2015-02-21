# things we need
Router = require './rally/route-manager'
RallyComputer = require './rally/rally-computer'
routes = require './data/routes.json'
express = require 'express'
bodyparser = require 'body-parser'
moment = require 'moment'
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
  console.log response.statusCode, request.path, ":", moment().format()
  next()

app.use bodyparser.json()

app.use "/public", express.static(__dirname + '/public')

app.get "/routes", (request, response)->
  response.json router.all()
  router.save()

app.get "/routes/:id", (request, response)->
  response.json router.byId(request.params.id)

app.get "/routes/:id/steps", (request, response)->
  route = router.byId(request.params.id)[0]
  response.json route.allsteps()

app.post "/routes/:id/steps", (request, response)->
  route = router.byId(request.params.id)[0]
  response.json route.addStep request.body
  router.save()

app.get "/routes/:id/activate", (request, response)->
  response.json router.activate(request.params.id)

app.post "/routes", (request, response)->
  response.json router.addRoute request.body
  router.save()

app.get "/time", (request, response)->
  response.json moment().format()

app.post "/time/:time", (request, response)->
  response.json setTime request.params.time

app.get "/update", (request, response)->
  response.json true
  fbui.updateData
    cast: Math.floor(Math.random()*100)
    odo: Date.now()

app.post "/routes/:id", (request, response)->
  response.json router.updateById request.body
  router.save()

app.get "/", (request, response)->
  response.sendfile(__dirname + '/web/index.html')

app.listen 8090

#basic time setting stuff. only works when started as superuserre
exec = require('child_process').exec

setTime = (time)->
  exec "date -s '#{time}'", (err, stdout, stderr)->
    return stdout or stderr
    if error != null
      console.log Error

