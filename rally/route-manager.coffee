fs = require 'fs'

#this file handles the routing portion (as in TSD routes.)

class RouteStep
  cast: 0
  startMile: 0
  endMile: 0
  instruction: ""
  notes: "asdf"
  hazard: false

  constructor: (step)->
    @cast = step.cast or step.speed or 0
    @startMile = step.startMile or 0
    @endMile = step.endMile or 0
    @instruction = step.instruction or ""
    @notes = step.notes = ""
    @distance = @endMile - @startMile
    @length = @computeLength()

  computeLength: ->
    # find out how long it takes to go the distance at the CAST
    (6 * @distance) / @cast

class Route

  name: ""
  id: 0
  steps: []
  startTime: "" # unix timestamp
  startOffset: "" # in 10ths of a second. so, for a 23 second offset, 230

  constructor: (route)->
    @steps = []
    @name = route.name or ""
    @id = route.id or Math.floor(Math.random()*1000+1)
    @startTime = route.startTime or Date.now() + 86400000
    @startOffset = route.startOffset or 0
    @description = route.description or "a bucket route"
    @length = 0
    @distance = 0
    @startMileage = 0
    @totalSteps = 0
    if route.steps
      for step in route.steps
        @addStep step
    @compute()

  addStep: (step)->
    @steps.push new RouteStep(step)
    @compute()

  routeLength: ->
    total = 0
    for step in @steps
      total += step.length
    total

  routeDistance: ->
    total = 0
    for step in @steps
      total += (step.endMile - step.startMile)
    total

  compute: ->
    @length = @routeLength()
    @distance = @routeDistance()
    @startMileage = @steps[0].startMile
    @totalSteps = @steps.length
  allsteps: ->
    @steps

class RouteManager

  routes = []

  constructor: (routes)->
    @routes = []
    for route in routes
      @addRoute route

  addRoute: (route)->
    @routes.push new Route(route)

  listByName: ->
    byname = []
    for route in @routes
      name = route.name or "Unnamed route"
      byname.push 
        name:
          route
    byname

  byId: (id)->
    results = []
    for route in @routes
      if route?.id.toString() == id.toString()
        results.push route
    results

  all: ->
    @routes

  first: ->
    @routes[0]

  save: ->
    fs.writeFile './data/routes.json', JSON.stringify(@all()), (err)->
      if (err) 
        console.log(err)

module.exports = RouteManager