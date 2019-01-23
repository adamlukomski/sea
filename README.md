# sea - Series Elastic Actuator prototype

This is a series of very rough sketches of how SEA work and how to design one,
based on a cheap servo (or two).

## sea1.scad

Just a visualization (a poor one) of how the inner wheels work and how to attach an elastic loop.

## sea2.scad

Actual prototype (but I will call it version 2), with a place for a servo and two potentiometers.

Just one bearing, to hold the front of the elastic part.

## sea3.scad

Version 3 lands with a custom bearing with 4mm balls (later on I'll do it with more available 6mm).

Encoders are no longer on-axis, I moved them to the side, they are multi-turn now, so extra
computation is needed at the start to get the hold of relative position.
