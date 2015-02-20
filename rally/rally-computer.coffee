onoff = require 'onoff'

class RallyComputer
  constructor: ->
    true

  data: ->
    return {odo: Date.now()}

module.exports = RallyComputer