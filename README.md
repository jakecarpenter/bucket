# bucket

## About

bucket is a rally computer/odo for TSD rally that is designed to work on the raspberry pi. It provides a drivers display via an attached screen (piTfT) and a remote/co-drivers display via a built in webserver. The co-driver can connect to the pi via wifi and setup routes, config bucket, and look at stats. During TSD rally, there is a websocket based display that will allow the tablet to act as a secondary display.

## Components

### Display

FBui and HDMIui are the physical, realtime display modules. they display the information screen or the rally screen.

### Rally

The rally module handles all the time keeping and calculations relevant to the route and its timing.

### RouteManager

The route manager handles all the routes and steps (including saving to the device and prepping the data for the web and rally components)

### Web

The web component allows configuration of the rally computer.