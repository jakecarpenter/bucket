FBui = require './display/fb'

fbui = new FBui

do timer = ()->
  setInterval ()->
    fbui.draw()
  ,
  100