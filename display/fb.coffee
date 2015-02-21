pitft = require 'pitft'
moment = require 'moment'

class FBui
  #set some dimensions
  width: 320
  height: 240

  #ui settings
  uiLineWidth: 1
  uiLineColor:
    r: 1
    g: 1
    b: 1

  bars:
    left: 90
    right: 205
    top: 60
    middle: 120
    bottom: 180

  #label settings
  labelColor:
    r: 0
    g: 1
    b: 1

  labelFont: "fantasy"
  labelSize: 12
  labelPadding: 
    x: 4
    y: 12

  dataColor:
    main:
      r:0
      g:1
      b:0
    secondary:
      r:0
      g:0.5
      b:0.1      

  # things relevant to displaying real data
  currentOdo: 0
  currentInstruction: "--none loaded--"
  currentCast: 0

  constructor: ->
    @start = Math.floor(Date.now() / 1000)
    @counter = 0
    @fb = pitft "/dev/fb1", true
    @fb.clear()

  updateData: (data = {})->
    @currentInstruction = data.instruction or @currentInstruction
    @currentCast = data.cast or @currentCast
    @currentOdo = data.odo or @currentOdo
    @draw()

  scaleLines: ()->
    @fb.color(1,1,1)
    #horizontal markers
    for i in [1...24]  
      @fb.line(0, i * 10, @bars.left, i * 10)
    
  # position is the distance from 0 in 1/10 of a second so, -2 means .2 seconds late
  marker: (pos)->
    #a place to keep the actual y
    y = 0
    yoff= 0
    #if the position is negative, we add 120
    @fb.font("times", 30)
    if pos < -2
      @fb.color(1,0,0)
      y = (Math.abs(pos)*2.5) 
      yoff = y + 5
      @fb.rect(0, 120, @bars.left, y)
     else if pos > 2
      @fb.color(1,1,0)
      y = -(pos * 2.5)
      yoff = y - 5 
      @fb.rect(0, 120, @bars.left, y)
     else
      @fb.color(0,1,0)
      y = 120
      @fb.rect(0, 0, @bars.left, @height)
    
    @fb.color()
    @fb.rect(10, 100, 70, 40)
    @fb.color(1,1,1)
    @fb.text(14, 136, Math.abs(pos * 1)/10, false)

  uiLines: ()->
    @fb.color(@uiLineColor.r,@uiLineColor.g,@uiLineColor.b)
    @fb.line(@bars.left, 0, @bars.left, @height, @uiLineWidth)
    @fb.line(@bars.right, @bars.bottom, @bars.right, @height, @uiLineWidth)
    @fb.line(@bars.right, @bars.top, @bars.right, @bars.middle, @uiLineWidth)
    @fb.line(@bars.left, @bars.top, @width, @bars.top, @uiLineWidth)
    @fb.line(@bars.left, @bars.middle, @width, @bars.middle, @uiLineWidth)
    @fb.line(@bars.left, @bars.bottom, @width, @bars.bottom, @uiLineWidth)

  uiLabels: ()->
    @fb.color(@labelColor.r,@labelColor.g,@labelColor.b)
    @fb.font(@labelFont, @labelSize)
    @fb.text(@bars.left + @labelPadding.x, @labelPadding.y, "overall:")
    @fb.text(@bars.left + @labelPadding.x, @bars.top + @labelPadding.y, "until next:")
    @fb.text(@bars.right + @labelPadding.x, @bars.top + @labelPadding.y, "time rem.:")
    @fb.text(@bars.left + @labelPadding.x, @bars.middle + @labelPadding.y, "instruction:")
    @fb.text(@bars.left + @labelPadding.x, @bars.bottom + @labelPadding.y, "CAST")
    @fb.text(@bars.right + @labelPadding.x, @bars.bottom + @labelPadding.y, "Speed")


  odo: (reading)->
    reading = "#{reading}"
    reading = reading.split("").reverse() #string to array
    reading = reading.concat([0,0,0,0,0,0,0,0]).slice(0,8).reverse()
    @fb.color(@dataColor.main.r,@dataColor.main.g,@dataColor.main.b)
    @fb.font("arial", 45)
    # lets draw each digit sep. 
    offset = (@width - @bars.left) / 8 # 8 digit odo
    for i in [0..5]
      @fb.text(@bars.left + (offset * i), 50, reading[i])
    @fb.color(@dataColor.secondary.r,@dataColor.secondary.g,@dataColor.secondary.b)
    for i in [6..7]
      @fb.text(@bars.left + (offset * i), 50, reading[i])


  instruction: (instruction)->
    @fb.color(0,0,1)
    @fb.font("fantasy", 18)
    inst = instruction.match(/.{1,21}/g);
    @fb.text(@bars.left + @labelPadding.x, 150, inst[0])
    @fb.text(@bars.left + @labelPadding.x, 150 +@labelPadding.y * 2, inst[1] + "...") if inst.length > 1



  untilNext: (dtn)->
    stamp = Math.floor(Date.now() / 1000)
    @fb.color(0,0,1)
    @fb.font("fantasy", 45)
    @fb.text(145, 95, "."+dtn, true)  
    @fb.text(255, 95, ":"+(stamp-@start) , true) 


  speed: (speed)->
    @fb.color(0,0,1)
    @fb.font("fantasy", 45)
    @fb.text(255, 220, speed, true) 


  cast: (cast)->
    @fb.color(0,0,1)
    @fb.font("fantasy", 45)
    @fb.text(145, 220, cast, true)

  draw: ->
    if(@counter == 40)
      @counter = 0

    time = Math.floor(Date.now() / 1000);
    @fb.clear()
    @uiLines()
    @uiLabels()
    @scaleLines()
    # @marker(@counter - 20)
    @odo(@currentOdo)
    # @instruction(@currentInstruction)
    @instruction(moment().format())
    # @untilNext(33-@counter)
    # @speed(43 + Math.floor(@counter/3))
    @cast(@currentCast)
    @fb.blit()
    @counter++      

module.exports = FBui