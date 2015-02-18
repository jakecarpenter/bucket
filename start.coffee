fbui = require './display/fb'

do timer = ()->
  setInterval ()->
    fbui.draw()
  ,
  100