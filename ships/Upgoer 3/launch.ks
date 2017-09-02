@lazyglobal off.
{
   launch_ctl["init"](
      lexicon(
              //Countdown type and length
              "launchTime",          "window", 
              "countDownLength",      30,
              //Windows parameters
              "lan",                  78, 
              "inclination",          6, 
              //Launch options
              "azimuthHemisphere",   "north",
              //Fudge factor
              "timeOfFlight",         100, 
              //Gravity turn parameters
              "pOverDeg",             7, 
              "pOverV0",              30, 
              "pOverVf",              100,
              //Throttle program parameters
              "throttleProgramType", "tableAPO", 
              "throttleProfile", list(
                                      15000, 1,
                                      30000, 0.5,
                                      50000, 0.3,
                                      55000, 0.75,
                                      80000, 0.5

//              "throttleProgramType", "tableMET", 
//              "throttleProfile", list(
//                                      60, 1,
//                                      120, 0.5,
//                                      240, 0.25,
//                                      320, 0.1

//              "throttleProgramType", "etaApo", 
//              "throttleProfile", list( 
//                                      20000, //Apo to Activate function, max prior
//                                      80000, //Apo to Deactivate function 
//                                      45     //Setpoint

                                    )
             )
   ).
   lock throttle to launch_ctl["throttleProgram"]().
   lock steering to launch_ctl["steeringProgram"]().

   MISSION_PLAN:add(launch_ctl["countdown"]).
   MISSION_PLAN:add(launch_ctl["launch"]).
   MISSION_PLAN:add({
     launch_ctl["staging"]().
     return launch_ctl["throttle_monitor"]().
   }).
   MISSION_PLAN:add({
      if ship:altitude > 70000 {
         
         maneuver_ctl["add_burn"]("ap", "circularize", 350, 72.83687236, launch_ctl["steeringProgram"]).

         maneuver_ctl["add_burn"]("pe", 900, 350, 72.83687236, "prograde").
         return OP_FINISHED.
      } else return OP_CONTINUE.
   }).
   MISSION_PLAN:add(maneuver_ctl["burn_monitor"]).
   kernel_ctl["start"]().
   set ship:control:pilotmainthrottle to 0.
}
