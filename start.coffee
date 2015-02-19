# FBui = require './display/fb'
Router = require './rally/route-manager'
routes = require './data/routes.json'
express = require 'express'

## display stuff
# fbui = new FBui

# do timer = ()->
#   setInterval ()->
#     fbui.draw()
#   ,
#   100

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