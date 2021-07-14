// Note: functions MUST ACCEPT, but NOT REQUIRE a single parameter.  
//       So, give the parameter a sensible default.
global throttle_functions is lexicon().

// Maintains a constant TWR during ascent.
throttle_functions:add("constantTWR", {
   parameter twr is 1.5.
   // Adapted from:
   //https://pastebin.com/z3i4WbKD
   local r is ship:altitude+ship:body:radius.
   return twr*(ship:body:mu/(r^2))*(ship:mass/max(0.1, ship:availablethrust)).
}).

// Experimental
// Vertical Acceleration needed to achieve
// target apo by within half an orbit.
//
//throttle_functions:add("half-orbit-apo", {
//   parameter target is 80000.
//
//   local VertThrust is ship:availablethrust*sin(vang(up:forevector, ship:facing:forevector)).
//   local thrott is (2*(target-ship:orbit:body:radius-ship:orbit:apoapsis)*ship:mass)/(ship:orbit:period*ship:orbit:eta:apoapsis*VertThrust)+ship:mass*ship:mass*constant:g0/VertThrust.
//   return thrott.
//}).


//Throttle decreases as horizontal velocity approaches orbital velocity.
throttle_functions:add("vOV", {
   parameter minimum is 0.1.
   return max(minimum, 1-(ship:velocity:orbit:mag/phys_lib["OVatAlt"](Kerbin, ship:altitude))).
   //return max(minimum, 1-(vang(up:forevector, facing:forevector))*(ship:velocity:orbit:mag/phys_lib["OVatAlt"](Kerbin, ship:altitude))).
}).
