var pitft = require('pitft');
var fb = pitft("/dev/fb1", true); // Returns a framebuffer in direct mode.  See the clock.js example for double buffering mode

// Clear the screen buffer
fb.clear();

var xMax = fb.size().width;
var yMax = fb.size().height;

var yPos = 0;
var yDir = 1;

var counter = 0;
var start = Math.floor(Date.now() / 1000);
var stamp = Math.floor(Date.now() / 1000);

draw = function(){
	if(counter == 40){
		counter = 0;
	}
	var time = Math.floor(Date.now() / 1000);
	fb.clear();
	uiLines();
	//console.log(time);
	//fb.text(11, 120, time, false); // Draw the text non-centered, rotated _a_ degrees
	scaleLines();
	testOffset = Math.random
	marker(counter - 20);
	odo(11222+counter);
	instruction("HARD RT at Stop Sign");
	untilNext(33-counter);
	speed(43 + Math.floor(counter/3));
	cast(45);
	fb.blit();
	counter++;
}

scaleLines = function(){
	fb.color(1,1,1);
	//vertical line
	//fb.line(20, 0, 20, 240);
	//horizontal markers
	var markers = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]
	for (i = 1; i <= markers.length; i++) { 
		y = i * 5 ;	
		fb.line(0, y, 90, y);
	}
	for (i = 1; i <= markers.length; i++) { 
		y = i * 5 + 120;	
		fb.line(0, y, 90, y);
	}
	//center line
	//fb.line(10,120,30,120);
}

arrow = function(centerX, centerY, color, size, rotation){
	fb.color(color[0],color[1],color[2]);
	var a = {},b={}, c={};
	var height = Math.sqrt(3) * size 
	a.x = centerX - size;
	a.y = centerY;
	b.x = centerX + size;
	b.y = centerY;
	c.x = centerX;
	if(rotation === 1){
		c.y = centerY - height;
	}
	else {
		c.y = centerY + height;
	}
	fb.line(a.x, a.y, b.x, b.y, 5);
	fb.line(b.x, b.y, c.x, c.y, 5);
	fb.line(c.x, c.y, a.x, a.y, 5);
}  
//position is the distance from 0 in 1/10 of a second so, -2 means .2 seconds late
var marker = function(pos){
	//a place to keep the actual y
	var y = 0, yoff=0;
	//if the position is negative, we add 120
	fb.font("times", 30);
	if(pos < -2){
		fb.color(1,0,0);
		y = (Math.abs(pos)*5) ;
		yoff = y + 5;
		fb.rect(0, 120, 90, y);
	} else if(pos > 2){
		fb.color(1,1,0);
		y = -(pos * 5)
		yoff = y - 5; 
		fb.rect(0, 120, 90, y);
		fb.color([0,1,1]);
		fb.text(14, 100, "AHEAD", false);
	} else {
		fb.color(0,1,0);
		y = 120
		fb.rect(0, 0, 90, yMax);
	}
	fb.color();
	fb.rect(10, 100, 70, 40);
	fb.color(1,1,1);
	fb.text(14, 136, Math.abs(pos * 1)/10, false);
};

var markerOld = function(pos){
	//a place to keep the actual y
	var y = 0, yoff=0;
	//if the position is negative, we add 120
	if(pos < 0){
		fb.color(1,0,0);
		y = (Math.abs(pos)*.10) + 120;
		yoff = y + 5;
	} else if(pos > 0){
		fb.color(0,1,0);
		y = 120 - (pos * .1)
		yoff = y - 5; 
	} else {
		fb.color(1,1,0);
		y = 120
	}
	fb.font("times",30);
	fb.text(36, 130, "0."+Math.abs(pos), false);
	fb.line(0, y, 28, y, 10);
	fb.line(28, yoff, 28, 120, 10);
};
var uiLines = function(){
	fb.color(1,1,1);
	fb.line(90, 0, 90, yMax, 3);
	fb.line(205, 180, 205, yMax, 3);
	fb.line(205, 60, 205, 120, 3);
	fb.line(90, 60, xMax, 60, 3);
	fb.line(90, 120, xMax, 120, 3);
	fb.line(90, 180, xMax, 180, 3);
	fb.font("fantasy", 12);
	fb.text(94, 10, "overall:");
	fb.text(94, 73, "until next:");
	fb.text(208, 73, "time rem.:");
	fb.text(94, 133, "instruction:");
	fb.text(94, 193, "CAST");
	fb.text(208, 193, "Speed");
};

var odo = function(reading){
	fb.color(0,0,1);
	fb.font("arial", 45);
	fb.text(205, 30, reading, true);
};

var instruction = function(instruction){
	fb.color(0,0,1);
	fb.font("fantasy", 18);
	fb.text(205, 150, instruction, true);
};

var untilNext = function(dtn){
	var stamp = Math.floor(Date.now() / 1000);
	fb.color(0,0,1);
	fb.font("fantasy", 45);
	fb.text(145, 95, "."+dtn, true);	
	fb.text(255, 95, ":"+(stamp-start) , true);	
};

var speed = function(speed){
	fb.color(0,0,1);
	fb.font("fantasy", 45);
	fb.text(255, 220, speed, true);	
};

var cast = function(cast){
	fb.color(0,0,1);
	fb.font("fantasy", 45);
	fb.text(145, 220, cast, true);	
};

draw();

var timer = setInterval(function(){draw();}, 80);
