extensions [ time ]
breed [ people person ]
breed [ sensors sensor ]
breed [ things thing ]
breed [ doors door ]
patches-own [
  ground
  room
  is-wall?
]
sensors-own [
  sensing-radius ; Radius of sensing
  activated? ; Is the sensor activated? (Boolean)
  sensors-name sensor-name
  sensors-status sensor-status
]
people-own [
  position-clock
  target-x
  target-y
  current-room
]
globals [
  clock ; Simulated time of the day
  clock-hm ; Display of simulated time
  last-run-hour ; To calculate when the agent should make decisions (in the go procedure)
  start-time
  stop-simulation?
  input-file ; File with coordinates for the agent to move
  input-file-open? ; is input-file open?
  log-file ; File with the output of the simulation
  usage-list ; It saves the random numbers generated according to the agent's decisions
  number-app ; Randomly generated for the agent to decide to use or not the app
  number-app-2
  number-fall
  number-fall-2
  number-tremor
  fallen
  used-when ; To know the last time that the agent used the app
  x-fell ; How many times they fell
  x-called ; How many times they called for help using the app
  x-tried ; How many times they tried to call for help using the app but did not succeed
  x-total ; Total of times they called + they wanted to but didn't
  description
  possibilities
  ;clock clock-hm start-time stop-simulation? ;initial-time-0
]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SETUP ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to setup
  clear-all
  clear-output
  output-print "------------------------------------------------------------------------------------"

  set usage-list [ ] ; To start the list of random numbers

  let input-file-name (word "newSequenceMining" simulation-duration ".txt")
  print input-file-name
  set input-file input-file-name
  set input-file-open? false
  set log-file "output-file.txt"

  setup-house
  setup-sensors
  setup-person
  setup-clock

  reset-ticks
end

to setup-house
  ; Main bedroom ;
  ask patches [
    set ground pcolor
    if distancexy 3 -10 < 7 [ set ground 2 set room "bedroom" ]
  ]
  ask patches with [pycor = -3 AND pxcor > -4 AND pxcor < 10] [ set ground 2 set room "bedroom" ]
  ask patches with [pxcor = -3 AND pycor < -2 AND pycor >= -16] [ set ground 2 set room "bedroom" ]
  ask patches with [pxcor = -2 AND pycor < -2 AND pycor >= -16] [ set ground 2 set room "bedroom" ]
  ask patches with [pxcor = -1 AND pycor < -2 AND pycor >= -16] [ set ground 2 set room "bedroom" ]
  ask patches with [pxcor = 7 AND pycor < -2 AND pycor >= -16] [ set ground 2 set room "bedroom" ]
  ask patches with [pxcor = 8 AND pycor < -2 AND pycor >= -16] [ set ground 2 set room "bedroom" ]
  ask patches with [pxcor = 9 AND pycor < -2 AND pycor >= -16] [ set ground 2 set room "bedroom" ]

  ask patches with [pxcor = 0 and pycor = -10] [
    sprout-things 1 [
      set shape "bed"
      set heading 0
      set size 5.5
      set color brown
    ]
  ]
  ask patches with [pxcor = 2 and pycor = -4] [
    sprout-things 2 [
      set shape "drawer"
      set heading 0
      set size 2
      set color brown
    ]
  ]
  ask patches with [pxcor = 4 and pycor = -4] [
    sprout-things 2 [
      set shape "drawer"
      set heading 0
      set size 2
      set color brown
    ]
  ]
  ask patches with [pxcor = -3 and pycor = -7] [
    sprout-doors 1 [
      set shape "i beam"
      set size 2
      set heading 180
      set color 33
      set room "door"
    ]
  ]

  ; Closet ;
  ask patches [
    if distancexy 13 -13 < 4 [ set ground 89 set room "closet" ]
  ]
  ask patch 10 -10 [ set ground 89 set room "closet" ]
  ask patch 16 -16 [ set ground 89 set room "closet" ]
  ask patch 10 -16 [ set ground 89 set room "closet" ]
  ask patch 16 -10 [ set ground 89 set room "closet" ]

  ; Suite ;
  ask patches [
    if distancexy 13 -6 < 4 [ set ground 9.9 set room "suite" ]
  ]
  ask patch 10 -3 [ set ground 9.9 set room "suite" ]
  ask patch 16 -3 [ set ground 9.9 set room "suite" ]
  ask patch 10 -9 [ set ground 9.9 set room "suite" ]
  ask patch 16 -9 [ set ground 9.9 set room "suite" ]

  ask patches with [pxcor = 9 and pycor = -7] [
    sprout-doors 1 [
      set shape "i beam"
      set size 2
      set heading 180
      set color 33
      set room "door"
    ]
  ]

  ; Guest bedroom ;
  ask patches [
    if distancexy 11 3 < 6 [ set ground 5 set room "guest-bedroom" ]
  ]
  ask patches with [pycor = 7 AND pxcor > 5 AND pxcor <= 16] [ set ground 5 set room "guest-bedroom" ]
  ask patches with [pycor = -1 AND pxcor > 5 AND pxcor <= 16] [ set ground 5 set room "guest-bedroom" ]
  ask patches with [pycor = -2 AND pxcor > 5 AND pxcor <= 16] [ set ground 5 set room "guest-bedroom" ]
  ask patches with [pycor = 8 AND pxcor > 5 AND pxcor <= 16] [ set ground 3 set room "guest-bedroom" ]

  ask patches with [pxcor = 6 and pycor = 3] [
    sprout-doors 1 [
      set shape "i beam"
      set size 2
      set heading 180
      set color 33
      set room "door"
    ]
  ]
  ask patches with [pxcor = 9 and pycor = -1] [
    sprout-things 1 [
      set shape "bed"
      set heading 0
      set size 5.5
      set color blue
    ]
  ]

  ; Office ;
  ask patches [
    if distancexy 9 12 < 4 [ set ground 3 set room "office" ]
    if distancexy 13 12 < 4 [ set ground 3 set room "office" ]
  ]
  ask patches with [pycor = 16 AND pxcor > 5 AND pxcor <= 16] [ set ground 3 set room "office" ]
  ask patches with [pxcor = 16 AND pycor > 8 AND pycor <= 16] [ set ground 3 set room "office" ]
  ask patches with [pxcor = 6 AND pycor > 8 AND pycor <= 16] [ set ground 3 set room "office" ]

  ask patches with [pxcor = 6 and pycor = 11] [
    sprout-doors 1 [
      set shape "i beam"
      set size 2
      set heading 180
      set color 33
      set room "door"
    ]
  ]

  ; Bathroom ;
  ask patches [
    if distancexy -1 12 < 5 [ set ground 9.9 set room "bathroom" ]
  ]
  ask patches with [pxcor = -5 AND pycor > 7 AND pycor <= 16] [ set ground 9.9 set room "bathroom" ]
  ask patches with [pxcor = -4 AND pycor > 7 AND pycor <= 16] [ set ground 9.9 set room "bathroom" ]
  ask patches with [pxcor = 2 AND pycor > 7 AND pycor <= 16] [ set ground 9.9 set room "bathroom" ]
  ask patches with [pxcor = 3 AND pycor > 7 AND pycor <= 16] [ set ground 9.9 set room "bathroom" ]

  ask patches with [pxcor = 3 and pycor = 12] [
    sprout-doors 1 [
      set shape "i beam"
      set size 2
      set heading 0
      set color 33
      set room "door"
    ]
  ]

  ; Kitchen ;
  ask patches [
    if distancexy -12 12 < 5 [ set ground 8 set room "kitchen" ]
  ]
  ask patches with [pxcor = -16 AND pycor > 7 AND pycor <= 16] [ set ground 8 set room "kitchen" ]
  ask patches with [pxcor = -15 AND pycor > 7 AND pycor <= 16] [ set ground 8 set room "kitchen" ]
  ask patches with [pxcor = -9 AND pycor > 7 AND pycor <= 16] [ set ground 8 set room "kitchen" ]
  ask patches with [pxcor = -8 AND pycor > 7 AND pycor <= 16] [ set ground 8 set room "kitchen" ]

  ask patches with [pxcor = -10 and pycor = 8] [
    sprout-doors 1 [
      set shape "i beam"
      set size 2
      set heading 90
      set color 33
      set room "door"
    ]
  ]
  ask patches with [pxcor = -14 and pycor = 15] [
    sprout-things 1 [
      set shape "square"
      set size 1.5
      set color 33
    ]
  ]
  ask patches with [pxcor = -13 and pycor = 15] [
    sprout-things 1 [
      set shape "square"
      set size 1.5
      set color 33
    ]
  ]
  ask patches with [pxcor = -12 and pycor = 15] [
    sprout-things 1 [
      set shape "square"
      set size 1.5
      set color 33
    ]
  ]
  ask patches with [pxcor = -15 and pycor = 15] [
    sprout-things 1 [
      set shape "garbage can"
      set size 1
      set color white
    ]
  ]
  ask patches with [pxcor = -13 and pycor = 15] [
    sprout-things 1 [
      set shape "food"
      set size 1
      set color white
    ]
  ]

  ; Living room ;
  ask patches [
    if distancexy -10 -5 < 5 [ set ground 109 set room "living-room" ]
  ]
  ask patches with [pxcor = -16 and pycor = 5] [
    sprout-things 1 [
      set shape "square"
      set size 1.5
      set color 33
    ]
  ]
  ask patches with [pxcor = -16 and pycor = 4] [
    sprout-things 1 [
      set shape "square"
      set size 1.5
      set color 33
    ]
  ]
  ask patches with [pxcor = -16 and pycor = 3] [
    sprout-things 1 [
      set shape "square"
      set size 1.5
      set color 33
    ]
  ]
  ask patches with [pxcor = -16 and pycor = 2] [
    sprout-things 1 [
      set shape "square"
      set size 1.5
      set color 33
    ]
  ]
  ask patches with [pxcor = -16 and pycor = 3] [
    sprout-things 1 [
      set shape "book"
      set size 1.25
      set heading 100
      set color 95
    ]
  ]

  ; Walls ;
  ; Main bedroom walls ;
  ask patches with [pycor = -3 AND pxcor > -4 AND pxcor < 10] [ set ground 35 set room "wall" ]
  ask patches with [pycor = -16 AND pxcor > -4 AND pxcor < 10] [ set ground 35 set room "wall" ]
  ask patches with [pxcor = -3 AND pycor < -2 AND pycor >= -16] [ set ground 35 set room "wall" ]
  ask patches with [pxcor = 9 AND pycor < -2 AND pycor >= -16] [ set ground 35 set room "wall" ]

  ; Closet walls ;
  ask patches with [pycor = -16 AND pxcor > 9 AND pxcor <= 16] [ set ground 35 set room "wall" ]
  ask patches with [pycor = -3 AND pxcor > 9 AND pxcor <= 16] [ set ground 35 set room "wall" ]
  ask patches with [pycor = -10 AND pxcor > 9 AND pxcor <= 16] [ set ground 35 set room "wall" ]
  ask patches with [pxcor = 16 AND pycor <= 16 AND pycor >= -16] [ set ground 35 set room "wall" ]

  ; Office walls ;
  ask patches with [pxcor = 6 AND pycor > -3 AND pycor <= 16] [ set ground 35 set room "wall" ]
  ask patches with [pycor = 16 AND pxcor > 6 AND pxcor < 16] [ set ground 35 set room "wall" ]
  ask patches with [pycor = 7 AND pxcor > 6 AND pxcor < 16] [ set ground 35 set room "wall" ]

  ; Bathroom walls ;
  ask patches with [pxcor = -5 AND pycor > 7 AND pycor <= 16] [ set ground 35 set room "wall" ]
  ask patches with [pxcor = 3 AND pycor > 7 AND pycor <= 16] [ set ground 35 set room "wall" ]
  ask patches with [pycor = 16 AND pxcor < 3 AND pxcor > -6] [ set ground 35 set room "wall" ]
  ask patches with [pycor = 8 AND pxcor < 3 AND pxcor > -6] [ set ground 35 set room "wall" ]

  ; Kitchen walls ;
  ask patches with [pxcor = -16 AND pycor > 7 AND pycor <= 16] [ set ground 35 set room "wall" ]
  ask patches with [pxcor = -8 AND pycor > 7 AND pycor <= 16] [ set ground 35 set room "wall"  ]
  ask patches with [pycor = 16 AND pxcor < -7 AND pxcor > -16] [ set ground 35 set room "wall"  ]
  ask patches with [pycor = 8 AND pxcor < -7 AND pxcor > -16] [ set ground 35 set room "wall"  ]

  ask patches with [pcolor = black] [ set room "corridor" ]
  ask patches [
    ifelse pcolor = brown [ set is-wall? true ]
    [ set is-wall? false ]
  ]

  ask patches [ set pcolor ground ]
end

to setup-sensors
  ; M001 ;
  create-sensors 1 [
    setxy 6 -13
  ; hide-turtle
    set room "bedroom"
    set label "M001"
    set sensor-name "M001"
    set shape "square"
    set color 65.2
    set sensing-radius (3 + size / 2)
    set activated? false
  ]

  ; M003 ;
  create-sensors 1 [
    setxy 0 -9
  ; hide-turtle
    set room "bedroom"
    set label "M003"
    set sensor-name "M003"
    set shape "square"
    set color 65.2
    set sensing-radius (3 + size / 2)
    set activated? false
  ]

  ; M002 ;
  create-sensors 1 [
    setxy 0 -11
  ; hide-turtle
    set room "bedroom"
    set label "M002"
    set sensor-name "M002"
    set shape "square"
    set color 65.2
    set sensing-radius (3 + size / 2)
    set activated? false
  ]

  ; M007 ;
  create-sensors 1 [
    setxy 3 -9
  ; hide-turtle
    set room "bedroom"
    set label "M007"
    set sensor-name "M007"
    set shape "square"
    set color 65.2
    set sensing-radius (3 + size / 2)
    set activated? false
  ]

  ; M005 ;
  create-sensors 1 [
    setxy 2 -6
  ; hide-turtle
    set room "bedroom"
    set label "M005"
    set sensor-name "M005"
    set shape "square"
    set color 65.2
    set sensing-radius (3 + size / 2)
    set activated? false
  ]

  ; M004 ;
  create-sensors 1 [
    setxy 9 -5
  ; hide-turtle
    set room "suite"
    set label "M004"
    set sensor-name "M004"
    set shape "square"
    set color 65.3
    set sensing-radius (3 + size / 2)
    set activated? false
  ]

  ; M024 ;
  create-sensors 1 [
    setxy 12 2
  ; hide-turtle
    set room "guest bedroom"
    set label "M024"
    set sensor-name "M024"
    set shape "square"
    set color 65.4
    ask patch 6 4 [set pcolor 65.4 set plabel "M023"] ; M023
    set sensing-radius (3 + size / 2)
    set activated? false
  ]

  ; M023 ;
  create-sensors 1 [
    setxy 6 4
  ; hide-turtle
    set room "guest bedroom"
    set label "M023"
    set sensor-name "M023"
    set shape "square"
    set color 65.4
    set sensing-radius (3 + size / 2)
    set activated? false
  ]

  ; M028 ;
  create-sensors 1 [
    setxy 6 10
  ; hide-turtle
    set room "office"
    set label "M028"
    set sensor-name "M028"
    set shape "square"
    set color 65.5
    set sensing-radius (3 + size / 2)
    set activated? false
  ]

  ; M025 ;
  create-sensors 1 [
    setxy 15 10
  ; hide-turtle
    set room "office"
    set label "M025"
    set sensor-name "M025"
    set shape "square"
    set color 65.5
    set sensing-radius (3 + size / 2)
    set activated? false
  ]

  ; M026 ;
  create-sensors 1 [
    setxy 11 15
  ; hide-turtle
    set room "office"
    set label "M026"
    set sensor-name "M026"
    set shape "square"
    set color 65.5
    set sensing-radius (3 + size / 2)
    set activated? false
  ]

  ; M027 ;
  create-sensors 1 [
    setxy 11 12
  ; hide-turtle
    set room "office"
    set label "M027"
    set sensor-name "M027"
    set shape "square"
    set color 65.5
    set sensing-radius (3 + size / 2)
    set activated? false
  ]

  ; M030 ;
  create-sensors 1 [
    setxy 4 16
  ; hide-turtle
    set room "garage door"
    set label "M030"
    set sensor-name "M030"
    set shape "square"
    set color 65.5
    set sensing-radius (3 + size / 2)
    set activated? false
  ]

  ; M029 ;
  create-sensors 1 [
    setxy 3 12
  ; hide-turtle
    set room "bathroom"
    set label "M029"
    set sensor-name "M029"
    set shape "square"
    set color 65.5
    set sensing-radius (3 + size / 2)
    set activated? false
  ]

  ; M031 ;
  create-sensors 1 [
    setxy -3 9
  ; hide-turtle
    set room "bathroom"
    set label "M031"
    set sensor-name "M031"
    set shape "square"
    set color 65.6
    set sensing-radius (3 + size / 2)
    set activated? false
  ]

  ; M016 ;
  create-sensors 1 [
    setxy -10 16
  ; hide-turtle
    set room "kitchen"
    set label "M016"
    set sensor-name "M016"
    set shape "square"
    set color 65.6
    set sensing-radius (3 + size / 2)
    set activated? false
  ]

  ; M017 ;
  create-sensors 1 [
    setxy -10 14
  ; hide-turtle
    set room "kitchen"
    set label "M017"
    set sensor-name "M017"
    set shape "square"
    set color 65.6
    set sensing-radius (3 + size / 2)
    set activated? false
  ]

  ; M019 ;
  create-sensors 1 [
    setxy -12 12
  ; hide-turtle
    set room "kitchen"
    set label "M019"
    set sensor-name "M019"
    set shape "square"
    set color 65.6
    set sensing-radius (3 + size / 2)
    set activated? false
  ]

  ; M018 ;
  create-sensors 1 [
    setxy -10 9
  ; hide-turtle
    set room "kitchen"
    set label "M018"
    set sensor-name "M018"
    set shape "square"
    set color 65.6
    set sensing-radius (3 + size / 2)
    set activated? false
  ]

  ; M015 ;
  create-sensors 1 [
    setxy -14 9
  ; hide-turtle
    set room "kitchen"
    set label "M015"
    set sensor-name "M015"
    set shape "square"
    set color 65.6
    set sensing-radius (3 + size / 2)
    set activated? false
  ]

  ; M012 ;
  create-sensors 1 [
    setxy -13 -14
  ; hide-turtle
    set room "corridor"
    set label "M012"
    set sensor-name "M012"
    set shape "square"
    set color 65.6
    set sensing-radius (3 + size / 2)
    set activated? false
  ]

  ; M013 ;
  create-sensors 1 [
    setxy -11 -5
  ; hide-turtle
    set room "living room"
    set label "M013"
    set sensor-name "M013"
    set shape "square"
    set color 65.6
    set sensing-radius (3 + size / 2)
    set activated? false
  ]

  ; M020 ;
  create-sensors 1 [
    setxy -10 -6
  ; hide-turtle
    set room "living room"
    set label "M020"
    set sensor-name "M020"
    set shape "square"
    set color 65.6
    set sensing-radius (3 + size / 2)
    set activated? false
  ]

  ; M014 ;
  create-sensors 1 [
    setxy -11 6
  ; hide-turtle
    set room "corridor"
    set label "M014"
    set sensor-name "M014"
    set shape "square"
    set color 65.6
    set sensing-radius (3 + size / 2)
    set activated? false
  ]

  ; M021 ;
  create-sensors 1 [
    setxy -4 5
  ; hide-turtle
    set room "corridor"
    set label "M021"
    set sensor-name "M021"
    set shape "square"
    set color 65.6
    set sensing-radius (3 + size / 2)
    set activated? false
  ]

  ; M022 ;
  create-sensors 1 [
    setxy 2 6
  ; hide-turtle
    set room "corridor"
    set label "M022"
    set sensor-name "M022"
    set shape "square"
    set color 65.6
    set sensing-radius (3 + size / 2)
    set activated? false
  ]

  ; M009 ;
  create-sensors 1 [
    setxy -7 -11
  ; hide-turtle
    set room "corridor"
    set label "M009"
    set sensor-name "M009"
    set shape "square"
    set color 65.6
    set sensing-radius (3 + size / 2)
    set activated? false
  ]

  ; M010 ;
  create-sensors 1 [
    setxy -7 -13
  ; hide-turtle
    set room "corridor"
    set label "M010"
    set sensor-name "M010"
    set shape "square"
    set color 65.6
    set sensing-radius (3 + size / 2)
    set activated? false
  ]

  ; M008 ;
  create-sensors 1 [
    setxy -4 -7
  ; hide-turtle
    set room "corridor"
    set label "M008"
    set sensor-name "M008"
    set shape "square"
    set color 65.6
    set sensing-radius (3 + size / 2)
    set activated? false
  ]

  ; M006 ;
  create-sensors 1 [
    setxy -2 -7
  ; hide-turtle
    set room "bedroom"
    set label "M006"
    set sensor-name "M006"
    set shape "square"
    set color 65.6
    set sensing-radius (3 + size / 2)
    set activated? false
  ]

  ; M011 ;
  create-sensors 1 [
    setxy -4 -16
  ; hide-turtle
    set room "front door"
    set label "M011"
    set sensor-name "M011"
    set shape "square"
    set color 65.6
    set sensing-radius (3 + size / 2)
    set activated? false
  ]
end

to setup-person
  file-close-all
  file-open input-file
  set input-file-open? true

  let x 0
  let y 0
  let initial-time 0
  let final-time 0

  if file-at-end? [
    set input-file-open? false
    stop ]
  set x file-read

  if file-at-end? [
    set input-file-open? false
    stop ]
  set y file-read

  if file-at-end? [
    set input-file-open? false
    stop ]
  set initial-time file-read

  if file-at-end? [
    set input-file-open? false
    stop ]
  set final-time file-read

  create-people 1 [
    setxy x y
    print (word "I'm in the " room " (coordinates " xcor " " ycor ").")
    set target-x x
    set target-y y
    set position-clock (final-time - initial-time)

    set shape "person"
  ; setxy 0 -10 ; In bed
    set color yellow
    set size 3
    set age age
    set speed speed
    set current-room [room] of patch-here
  ]
  reset-ticks
end

to setup-clock
  set clock time:create initial-time-0
  set clock-hm time:show clock "HH:mm:ss"
  set start-time clock
  set stop-simulation? false
end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; GO ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to go
  increment-time
  let current-hour time:get "hour" clock
  let current-minute time:get "minute" clock
  let current-second time:get "second" clock

  let total-duration (simulation-duration * -1)
  if (time:difference-between clock start-time "hours") <= total-duration [
    set stop-simulation? true
    print (word clock-hm  " end-of-simulation")
  ]

  if stop-simulation? [ stop ]

  ask people [
    if current-minute = 0 and current-hour mod application-use-frequency = 0 and current-hour != last-run-hour [
      set last-run-hour current-hour
      use-app
    ]
    if current-minute = 30 and current-hour mod application-use-frequency = 0 and current-second = 00 [
      set last-run-hour current-hour
      fall
    ]
  ; tremble
    check-room
  ]

; ask sensors [ log-event clock-hm xcor ycor sensor-name sensor-status room ]
  update-people
  update-sensors
; person-at

  if input-file-open? = false [ stop ]

  tick
end

to update-people
  ask people [
    ;ifelse (xcor = target-x) and (ycor = target-y) [
    ifelse ((xcor - target-x) < speed) and ((ycor - target-y) < speed) [
      ifelse position-clock > 0 [
        set position-clock position-clock - 1
      ] [
        move-file
        ]
    ]
    [
      move
    ]
  ]
end

to move
  ;let next-patch patch-ahead 1
  ;ifelse [pcolor] of next-patch != 35 [
    fd speed
    facexy target-x target-y
  ;]
  ;[ rt random 360 ]
end

to move-file
  file-open input-file

  ifelse file-at-end? = false [
    ;if file-at-end? [ stop ]
    if file-at-end? [
      set input-file-open? false
      stop
    ]
    let x file-read

    if file-at-end? [
      set input-file-open? false
      stop
    ]
    let y file-read

    if file-at-end? [
      set input-file-open? false
      stop
    ]
    let initial-time file-read

    if file-at-end? [
      set input-file-open? false
      stop
    ]
    let final-time file-read

    set target-x x
    set target-y y
    set position-clock (final-time - initial-time)

    facexy target-x target-y
  ]
  [
    file-close
    set input-file-open? false
  ]
end

to update-sensors
  ask-concurrent sensors [
    let was-activated? activated?

    ifelse any? people in-radius sensing-radius [
      set activated? true
      if not was-activated? [
        print (word clock-hm " sensor " sensor-name " ON")
        set sensor-status "ON"
      ]
      ask patches in-radius sensing-radius [ set pcolor red ]
    ] [
      set activated? false
      if was-activated? [
        print (word clock-hm " sensor " sensor-name " OFF" )
        set sensor-status "OFF"
      ]
      ask patches in-radius sensing-radius [ set pcolor ground ]
    ]
  ]
end

to check-room
  let new-room [room] of patch-here
  if current-room != new-room [
    print (word clock-hm " room_changing " current-room " " new-room)
    set current-room new-room
  ]
end

to log-event [tp a b x y z]
  file-open log-file
  file-print (word clock-hm " " a ", " b ", sensor " x " " y ", " z)
  file-close
end

to use-app
  ; let number-app random 10 ; The random number provided has to be a global variable so that it is properly saved in NetLogo's log. Therefore, we have to use SET instead of LET

  if (tremor-frequency = 0) [ set number-app random 8 set possibilities "[0..7]" ]
  if (tremor-frequency = 1) [ set number-app random 10 set possibilities "[0..9]" ]
  if (tremor-frequency = 2) [ set number-app random 12 set possibilities "[0..11]" ]
  if (tremor-frequency = 3) [ set number-app random 14 set possibilities "[0..13]" ]
  if (tremor-frequency = 4) [ set number-app random 16 set possibilities "[0..15]" ]
  if (tremor-frequency = 5) [ set number-app random 18 set possibilities "[0..17]" ]

  if (number-app = 0) or (number-app) = 1 or (number-app = 2) or (number-app = 3) [ set description "[did not use the application.]" ]
  if (number-app = 4) [ set description "[used the application with no message.]" ]
  if (number-app = 5) [ set description "[message: I have a headache.]" ]
  if (number-app = 6) [ set description "[message: I need help with my medicine.]" ]
  if (number-app = 7) [ set description "[message: I broke something.]" ]
  if (number-app >= 8) [ set description "[could not use the application.]" ]

  ifelse ((room = "bedroom") or (room = "office")) and ((number-app = 4) or (number-app = 5) or (number-app = 6) or (number-app = 7)) [
    set number-app-2 random 4
    if (number-app-2 = 0) [ set description "[message: I have a headache.]" ]
    if (number-app-2 = 1) or (number-app-2 = 2) [ set description "[message: I need help with my medicine.]" ]
    if (number-app-2 = 3) [ set description "[message: I broke something.]" ]

    print (word clock-hm " number-app: " number-app ", number-app-2: " number-app-2 " " description " " possibilities " I am in the " room ".")
  ] [
    print (word clock-hm " random number 1: " number-app " " description " " possibilities " I am in the " room ".")
  ]

  if (number-app = 4) or (number-app = 5) or (number-app = 6) or (number-app = 7) [
     set used-when clock-hm ; Saves the last time the app was used
     set x-called x-called + 1
     set x-total x-total + 1 ; Total of intended times whether the agent could use the app or not
  ]
  if (number-app >= 8) [
    set x-tried x-tried + 1
    set x-total x-total + 1
  ]

  set usage-list lput number-app usage-list ; Saves all generated numbers

end

to fall
; if (falling-frequency = 0) [ set number-fall random 200 ]
  ifelse ((room = "kitchen") or (room = "bathroom")) [
    if (falling-frequency = 1) [ set number-fall random 100 ]
    if (falling-frequency = 2) [ set number-fall random 40 ]
    if (falling-frequency = 3) [ set number-fall random 20 ]
    if (falling-frequency = 4) [ set number-fall random 10 ]
    if (falling-frequency = 5) [ set number-fall random 4 ]
  ] [
    if (falling-frequency = 1) [ set number-fall random 50 ]
    if (falling-frequency = 2) [ set number-fall random 20 ]
    if (falling-frequency = 3) [ set number-fall random 10 ]
    if (falling-frequency = 4) [ set number-fall random 5 ]
    if (falling-frequency = 5) [ set number-fall random 2 ]
  ]

  ifelse (number-fall <= 5) [
    ;set shape "fallen"
    set fallen 0
    print (word clock-hm " I fell in the " room)
  ]
  [
    ;set shape "person"
    set fallen 1
    print (word clock-hm " I am walking in the " room)
  ]
end

to tremble
  ask people [
    if (tremor-frequency = 1) [
      ifelse random 50 < 1 [
        set color red
        print (word "I am shaking")
      ][
        set color yellow
      ]
    ]

    if (tremor-frequency = 2) [
      ifelse random 40 < 1 [
        set color red
        print (word "I am shaking")
      ][
        set color yellow
      ]
    ]

    if (tremor-frequency = 3) [
      ifelse random 30 < 1 [
        set color red
        print (word "I am shaking")
      ][
        set color yellow
      ]
    ]

    if (tremor-frequency = 4) [
      ifelse random 20 < 1 [
        set color red
        print (word "I am shaking")
      ][
        set color yellow
      ]
    ]

    if (tremor-frequency = 5) [
      ifelse random 10 < 1 [
        set color red
        print (word "I am shaking")
      ][
        set color yellow
      ]
    ]
  ]
end

to increment-time
  set clock time:plus clock 1 "seconds"
  set clock-hm time:show clock "HH:mm:ss"
end

to person-at
    show [list xcor ycor] of people
end
@#$#@#$#@
GRAPHICS-WINDOW
198
10
569
382
-1
-1
11.0
1
10
1
1
1
0
0
0
1
-16
16
-16
16
1
1
1
ticks
30.0

BUTTON
68
10
131
43
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
132
10
195
43
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
122
45
195
90
clock
clock-hm
17
1
11

SLIDER
649
10
821
43
age
age
1
100
73.0
1
1
NIL
HORIZONTAL

SLIDER
23
154
195
187
speed
speed
0
5
2.0
1
1
NIL
HORIZONTAL

SLIDER
23
189
195
222
tremor-frequency
tremor-frequency
0
5
1.0
1
1
NIL
HORIZONTAL

CHOOSER
650
45
823
90
gender
gender
"feminine" "masculine"
0

SLIDER
23
224
195
257
falling-frequency
falling-frequency
0
5
5.0
1
1
NIL
HORIZONTAL

SLIDER
20
341
198
374
application-use-frequency
application-use-frequency
1
24
3.0
1
1
NIL
HORIZONTAL

TEXTBOX
8
312
198
351
In what period of time (hours) should the agent \"think\" about using the application?
10
0.0
1

TEXTBOX
27
262
200
288
How long should the simulation last?
10
0.0
1

SLIDER
25
277
197
310
simulation-duration
simulation-duration
1
24
2.0
1
1
NIL
HORIZONTAL

INPUTBOX
63
91
195
151
Initial-time-0
2024-01-01 08:00:00
1
0
String

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

bed
true
0
Rectangle -7500403 true true 45 75 75 210
Rectangle -7500403 true true 75 150 210 150
Rectangle -7500403 true true 75 150 240 180
Rectangle -7500403 true true 240 150 270 210
Rectangle -7500403 true true 60 180 75 195
Rectangle -1 true false 75 105 105 150
Rectangle -2674135 true false 105 105 270 150

book
false
0
Polygon -7500403 true true 30 195 150 255 270 135 150 75
Polygon -7500403 true true 30 135 150 195 270 75 150 15
Polygon -7500403 true true 30 135 30 195 90 150
Polygon -1 true false 39 139 39 184 151 239 156 199
Polygon -1 true false 151 239 254 135 254 90 151 197
Line -7500403 true 150 196 150 247
Line -7500403 true 43 159 138 207
Line -7500403 true 43 174 138 222
Line -7500403 true 153 206 248 113
Line -7500403 true 153 221 248 128
Polygon -1 true false 159 52 144 67 204 97 219 82

bottle
false
0
Circle -7500403 true true 90 240 60
Rectangle -1 true false 135 8 165 31
Line -7500403 true 123 30 175 30
Circle -7500403 true true 150 240 60
Rectangle -7500403 true true 90 105 210 270
Rectangle -7500403 true true 120 270 180 300
Circle -7500403 true true 90 45 120
Rectangle -7500403 true true 135 27 165 51

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

computer server
false
0
Rectangle -7500403 true true 75 30 225 270
Line -16777216 false 210 30 210 195
Line -16777216 false 90 30 90 195
Line -16777216 false 90 195 210 195
Rectangle -10899396 true false 184 34 200 40
Rectangle -10899396 true false 184 47 200 53
Rectangle -10899396 true false 184 63 200 69
Line -16777216 false 90 210 90 255
Line -16777216 false 105 210 105 255
Line -16777216 false 120 210 120 255
Line -16777216 false 135 210 135 255
Line -16777216 false 165 210 165 255
Line -16777216 false 180 210 180 255
Line -16777216 false 195 210 195 255
Line -16777216 false 210 210 210 255
Rectangle -7500403 true true 84 232 219 236
Rectangle -16777216 false false 101 172 112 184

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dish
false
0
Circle -7500403 true true 60 60 180
Rectangle -7500403 true true 255 90 270 225
Rectangle -7500403 true true 30 90 45 225
Polygon -7500403 true true 45 90 75 90 75 45 75 30 60 30 60 75 45 75 45 30 30 30 30 75 15 75 15 30 0 30 0 90 30 90 45 90 30 90 75 90 75 90 45 90 30 90 75 90 0 90 0 30 15 30 15 75 30 75 30 30 45 30 45 75 60 75 60 30 75 30 75 90 60 90 45 90 30 90
Rectangle -7500403 true true 269 49 275 92
Rectangle -7500403 true true 260 50 266 93
Rectangle -7500403 true true 251 49 257 92
Circle -7500403 true true 17 51 42

dot
false
0
Circle -7500403 true true 90 90 120

drawer
true
0
Rectangle -6459832 true false 15 90 285 225
Line -16777216 false 15 135 285 135
Line -16777216 false 15 165 285 165
Circle -16777216 true false 135 135 30
Line -16777216 false 15 195 285 195
Circle -16777216 true false 135 165 30
Line -16777216 false 15 105 285 105
Circle -16777216 true false 135 105 30

drop
false
0
Circle -7500403 true true 73 133 152
Polygon -7500403 true true 219 181 205 152 185 120 174 95 163 64 156 37 149 7 147 166
Polygon -7500403 true true 79 182 95 152 115 120 126 95 137 64 144 37 150 6 154 165

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fallen
false
0
Circle -7500403 true true 215 110 80
Polygon -7500403 true true 210 105 105 120 15 90 0 105 0 135 75 150 0 165 0 195 15 210 105 180 210 195
Rectangle -7500403 true true 206 127 221 172
Polygon -7500403 true true 210 195 150 240 120 225 195 165
Polygon -7500403 true true 210 105 150 60 120 75 195 135

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

food
false
0
Polygon -7500403 true true 30 105 45 255 105 255 120 105
Rectangle -7500403 true true 15 90 135 105
Polygon -7500403 true true 75 90 105 15 120 15 90 90
Polygon -7500403 true true 135 225 150 240 195 255 225 255 270 240 285 225 150 225
Polygon -7500403 true true 135 180 150 165 195 150 225 150 270 165 285 180 150 180
Rectangle -7500403 true true 135 195 285 210

garbage can
false
0
Polygon -16777216 false false 60 240 66 257 90 285 134 299 164 299 209 284 234 259 240 240
Rectangle -7500403 true true 60 75 240 240
Polygon -7500403 true true 60 238 66 256 90 283 135 298 165 298 210 283 235 256 240 238
Polygon -7500403 true true 60 75 66 57 90 30 135 15 165 15 210 30 235 57 240 75
Polygon -7500403 true true 60 75 66 93 90 120 135 135 165 135 210 120 235 93 240 75
Polygon -16777216 false false 59 75 66 57 89 30 134 15 164 15 209 30 234 56 239 75 235 91 209 120 164 135 134 135 89 120 64 90
Line -16777216 false 210 120 210 285
Line -16777216 false 90 120 90 285
Line -16777216 false 125 131 125 296
Line -16777216 false 65 93 65 258
Line -16777216 false 175 131 175 296
Line -16777216 false 235 93 235 258
Polygon -16777216 false false 112 52 112 66 127 51 162 64 170 87 185 85 192 71 180 54 155 39 127 36

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

i beam
true
0
Polygon -7500403 true true 165 15 240 15 240 45 195 75 195 240 240 255 240 285 165 285
Polygon -7500403 true true 135 15 60 15 60 45 105 75 105 240 60 255 60 285 135 285

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

washingmachine
false
0
Rectangle -1 true false 45 45 255 255
Circle -7500403 true true 88 103 124

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <enumeratedValueSet variable="age">
      <value value="51"/>
      <value value="52"/>
      <value value="53"/>
      <value value="63"/>
      <value value="65"/>
      <value value="66"/>
      <value value="69"/>
      <value value="71"/>
      <value value="77"/>
      <value value="78"/>
      <value value="82"/>
    </enumeratedValueSet>
    <steppedValueSet variable="speed" first="0.15" step="0.15" last="1"/>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
