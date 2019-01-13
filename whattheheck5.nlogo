globals
[ frameNum frameTime
  towalk
  forcarrotx forcarroty
  level
  gravity
  bunnyWho carrotWho
  bunnyAniFrame
  time-left
  gameover
  scene
]
turtles-own [name velX velY acelY grounded baseShape weaponWho aniFrame state hp HPBarWho power onWhichPlat shapeRatio]
;   name is used to identify special turtles
;   grounded is for  jump logic
;   baseShape is for changing shapes easily with suffix
;shapeRatio describes hoow big the actual shape of turtle is vs size
platforms-own [isEdge]
bunnies-own [moveCounter toJump]
snakes-own [lastTurnPlat]

breed [platforms platform]
breed [portals portal]
breed [bunnies bunny]
breed [carrots carrot]
breed [snakes snake]
breed [HPbars HPbar]
breed [texts text]


;--------------------------------------------------------------------------------------------setup, go , create functions
to setup
 ca
 ;variables
 set-default-shape bunnies "bunnyr"
 set-default-shape carrots "carrot"
 set-default-shape platforms "tile water"
 set-default-shape HPbars "healthbar8"
 set-default-shape snakes "snakel"
 set-default-shape portals "portal"
 set gravity -25
 set frameTime 0.1

 ;setups
 ask patches [set pcolor 2]
 words "start" -150 0 50 red
 words "game?" -0 0 50 red
 words "bunny" -150 100 50 127
 words "fight" 0 100 50 127
 createBunny 0 -100
 ask patch 270 -200 [set plabel "by Eve Lin"]
 set gameover "false"
 set scene 1
end

to go
  every frameTime [
    no-display
    if frameNum = 0 [  ;setup scene
      clear-drawing
      clear-patches
      ask turtles [if breed != bunnies and breed != carrots [die]]
      reset-timer
      set time-left 150
      ask patch 270 220 [set plabel "WELCOME. You are the bunny."]
    ;frameNum != 0  ; do scene logics
      setUpScenes
    ]
    if scene = 1 [
      if frameNum = 10
      [createSnake 180 130
      createSnake 120 130
      createSnake 300 -100
      createSnake 250 -100
      createSnake 150 -100
      ask patch 270 220 [set plabel "Defeat all monsters to move to the next scene"]
      ]
    ]
    ;stayonplatform
    ask (turtle-set bunnies snakes) [update]
    domonsterlogic
    time
    updateSceneclear
    ;if gameover = "true" [stop]
    set frameNum frameNum + 1
    display
  ]
end

to setUpScenes
  if scene = 1
    [
      import-drawing "village.jpg"
      create-platforms 1 [set shapeRatio 1 set size 50 setxy 50 90 set color 11 set isEdge true]
      create-platforms 1 [set shapeRatio 1 set size 50 setxy 100 90 set color 11]
      create-platforms 1 [set shapeRatio 1 set size 50 setxy 150 90 set color 11]
      create-platforms 1 [set shapeRatio 1 set size 50 setxy 200 90 set color 11 ]
      create-platforms 1 [set shapeRatio 1 set size 50 setxy 250 90 set color 11 set isEdge true]
      create-platforms 1 [set shapeRatio 1 set size 50 setxy -80 50 set color 11]
      create-platforms 1 [set shapeRatio 1 set size 50 setxy -150 -45 set color 11]
      crt 1 [set shape "healthbar8" set baseShape "healthbar" setxy -240 -220 set size 200 set heading 0]
      ask bunnies [setxy -340 -100]
    ]

    if scene = 2
    [  show "setting scene 2"
      import-drawing "treeplace.png"
      ask bunnies [setxy -340 -100]
      create-platforms 1 [set shapeRatio 1 set size 50 setxy 100 90 set color 11 set isEdge true]
      create-platforms 1 [set shapeRatio 1 set size 50 setxy 150 90 set color 11]
      create-platforms 1 [set shapeRatio 1 set size 50 setxy 200 90 set color 11 ]
      create-platforms 1 [set shapeRatio 1 set size 50 setxy 250 90 set color 11 ]
      create-platforms 1 [set shapeRatio 1 set size 50 setxy 300 90 set color 11 set isEdge true]
      create-platforms 1 [set shapeRatio 1 set size 50 setxy -50 40 set color 11]
      create-platforms 1 [set shapeRatio 1 set size 50 setxy 0 40 set color 11]
      create-platforms 1 [set shapeRatio 1 set size 50 setxy -150 -45 set color 11]
      create-platforms 1 [set shapeRatio 1 set size 50 setxy -180 90 set color 11 set isEdge true]
      create-platforms 1 [set shapeRatio 1 set size 50 setxy -230 90 set color 11]
      create-platforms 1 [set shapeRatio 1 set size 50 setxy -280 90 set color 11]
      create-platforms 1 [set shapeRatio 1 set size 50 setxy -330 90 set color 11 set isEdge true]
    ]

    if scene = 3
      [
       import-drawing "forest.png"
       ask bunnies [ setxy -340 -100]
        create-platforms 1 [set shapeRatio 1 set size 50 setxy 100 40 set color 11 set isEdge true]
        create-platforms 1 [set shapeRatio 1 set size 50 setxy 150 40 set color 11]
        create-platforms 1 [set shapeRatio 1 set size 50 setxy 200 40 set color 11 ]
        create-platforms 1 [set shapeRatio 1 set size 50 setxy 250 40 set color 11 ]
        create-platforms 1 [set shapeRatio 1 set size 50 setxy 300 40 set color 11 set isEdge true]
        create-platforms 1 [set shapeRatio 1 set size 50 setxy -50 -45 set color 11]
        create-platforms 1 [set shapeRatio 1 set size 50 setxy 0 40 set color 11]
        create-platforms 1 [set shapeRatio 1 set size 50 setxy -130 90 set color 11 set isEdge true]
        create-platforms 1 [set shapeRatio 1 set size 50 setxy -180 90 set color 11]
        create-platforms 1 [set shapeRatio 1 set size 50 setxy -230 90 set color 11]
        create-platforms 1 [set shapeRatio 1 set size 50 setxy -280 90 set color 11]
        create-platforms 1 [set shapeRatio 1 set size 50 setxy -330 90 set color 11 set isEdge true]
      ]
end
to time
  if int (150 - timer) != time-left and time-left >= 0 [
        set time-left int (150 - timer)
    ShowTimeLeft time-left
  ]
  if time-left <= 0
    [ShowTimeLeft 0
     ask patch 270 220 [set plabel "LOL. You ran out of time. Click setup to play again."]
     ask bunnies [set shape "skull"]
     set gameover "true"]
end
to ShowTimeleft [tl]
  ask patch (max-pxcor - 50) (min-pycor + 20) [set plabel-color red + 3 set plabel tl]
end

to createBunny [x y]
  ;create bunny and immdediatly create carrot after
  ;attach carrot's who as my bunny's weaponWho
  create-bunnies 1 [
    set name "bunny"
    setxy x y set size 100 set heading 0 set grounded true
    set baseShape "bunny"
    set shapeRatio 1
    set toJump false
    set weaponWho who + 1
    set bunnyWho who
    set power 1
    set hp 8
  ]
  create-carrots 1 [
    set baseShape "carrot"
   setxy x + 40 y - 10 set size 80 set heading 180
    set carrotWho who
  ]
end

to createSnake [x y]
  create-snakes 1 [
    set name "snake"
    set baseshape "snake"
    set shapeRatio 0.5
    setxy x y set size 80 set heading 0 set grounded true
    set HPBarWho who + 1
    set hp 8
    set power 0.2
    set state "walking"
  ]
  create-HPbars 1 [
    set baseshape "healthbar"
    setxy x y + 30 set size 50 set heading 0
  ]
end

to words [string startx starty big hue]   ;create  turtle letters on screen based on string given
  ;converts string to list ["a", "b", "c", ...]
  ;"a" will be print at x, y. B after it and so on
  let charList (string-to-list string)
  let x startx
  let y starty
  foreach charList
  [char -> create-texts 1
    [ set shape char
      set size big
      set color hue
      set heading 0
      setxy x y
    ]
    set x x + big / 2
  ]

end
;---------------------------------------------------------------------------Bunny/player logic
to swing
  ask bunnies [
    if state != "swing" and state != "throw" [
       set state "swing"
       set aniFrame 3
    ]
  ]
end
to throw
  ask bunnies [
    if state != "throw" and state != "swing" [
       set state "throw"
       set aniFrame 3
    ]
  ]
end

to walkLeft
  let moveNum 20
  ask bunnies [
    ifelse VelX > moveNum[
     set velX 0
    ][
      set velX velX - moveNum
    ]
  ]
end
to walkRight
  let moveNum 20
  ask bunnies [
    ifelse VelX < -1 * moveNum [
     set velX 0
    ][
      set velX velX + moveNum
    ]
  ]
end
to down
  ask bunnies [set velX 0]
end


to jumpUp
  ask bunnies [
    if grounded [
      set velY 250
      set grounded false
      set toJump true
    ]
  ]
end

;-----------------------------------------------------------------------------updates

to update ; use only on moving turtles
  checkGrounded
  updateVel
  updatePos
  updateAni
  updateHealth
end

to updatePos ;called from update
  let shiftX velX * frameTime
  let shiftY velY * frameTime
  ifelse canShiftX? shiftX[
    shiftXY shiftX 0
  ][set velX 0]
  ifelse canShiftY? shiftY[
    shiftXY 0 shiftY
  ][set velY 0]  ;reset speed when hit walls/ceiling
  if canShiftXY? shiftX shiftY[
    shiftXY shiftX shiftY
  ]
end

to moveXY [newX newY]
  let shiftX newX - xcor
  let shiftY newY - ycor
  if canShiftXY? shiftX shiftY[
    shiftXY shiftX shiftY
  ]
end

to shiftXY [shiftX shiftY] ;don't call this without a check to canShiftXY?
  setxy xcor + shiftX ycor + shiftY
  if hasWeapon? [
    ask turtle weaponWho [shiftXY shiftX shiftY]
  ]
  if hasHPBar? [
    ask turtle HPBarWho [shiftXY shiftX shiftY]
  ]
end

to updateVel ;turtle function. called in ask turtle
  ;turtle must be a moving object.
  ;check Grounded

  ;gravity: a global to test and adjust - -3?
  let accelY gravity  ;change accel if want more factors
  let capX 100;
  let capY 500;

  ;jumping
  if is-bunny? self [
    ifelse grounded and not toJump [
    set velY 0
    ][
    set velY velY + accelY
    set toJump false
    ]
  ]

  ;cap horizontal movement speed
  if velX > capX [set velX capX ]
  if velX < -1 * capX [set velX -1 * capX]
  ;cap vertical move speed
  if velY > capY [set velY capY ]
  if velY < -1 * capY [set velY -1 * capY]
end


to updateAni ;called for bunny and monsters
  ;update animations based on state and aniFrame num

  let stateSuffix ""
  let dirSuffix "r" ;should only be r or l
  let aniSuffix ""

  ;set stateSuffix
  if state = "attacking" [
    set stateSuffix "a"
  ]
  if state = "none" [
    set stateSuffix ""
  ]
  ;set dirSuffix
  ifelse velX >= 0 [ set dirSuffix "r"][ set dirSuffix "l" ]

  ifelse aniFrame = 0  [
    set state "none"
  ][ set aniFrame aniFrame - 1 ]


  changeShape (word DirSuffix stateSuffix aniSuffix)

  ;extras
  if breed = bunnies
   [
      if state = "swing"[
        let rotateNum 60
        if dirSuffix = "l" [set rotateNum rotateNum * -1]
        ask turtle weaponWho
        [set heading heading + rotateNum]
        ask snakes [if isCollideWithTurt? bunnyAgent "circle" [
          set hp hp - 1]]
      ]
      if state = "none"[
        let bunnyx xcor
        let bunnyy ycor
        ask turtle weaponWho
        [
         setxy bunnyx + 40 bunnyy - 10
         set heading 180
        ]
      ]
      if state = "throw" [
        let throwdistance 90
        let throwheading 180 + 90
         if dirSuffix = "l"
        [ set throwheading throwheading * -1
          set throwdistance throwdistance * -1
        ]
        ask turtle weaponWho [if xcor < 310 and xcor > -310 [ set heading throwheading set xcor xcor + throwdistance]]
      ask snakes [if isCollideWithTurt? carrotAgent "circle" [
          set hp hp - 1]]
      ]
  ]

end

to changeShape [suffix]
  ;show suffix ;debug
  let newShape word baseShape suffix
  let toChange false
  if shape != newShape [
    set toChange true
  ]

  ;specific turtle logic
  if name = "bunny" [
      ;move the carrot when changing shape
      let shiftX 80
      if suffix = "l" [set shiftX -80]
      let canCarrotMove [canShiftXY? shiftX 0] of turtle weaponWho
      ifelse toChange and canCarrotMove [
        ask turtle weaponWho [shiftXY shiftX 0]
      ][
        set toChange false
      ]
  ]
  if toChange [
  set shape newShape
  ]
end

to updateHealth
   if breed != bunnies [if hp <= 0 [ask turtle HPBarwho [die] set hp 0 die]
  if hasHPBar? and state != "dead" [
    ask turtle HPBarWho[changeShape [hp] of myself]
  ]
  ]

  ask bunnies [ if state != "dead" [
    ;ask turtle 7 [changeShape [int hp] of myself]
    if hp <= 0 [set hp 0 set state "dead" set shape "bunnyskull"
   ask patch 270 220 [set plabel "LOL. You dead. Click setup to play again."]
       set gameover "true"]]
  ]
end

to updateSceneclear
  let sceneclear false

if count snakes <= 0
  [set sceneclear true]

  if sceneclear
  [ if scene = 1
    [ask patch 270 220 [set plabel "Scene 1 CLEARED! Go to the portal"]
    createportal -80 80
     ask portals [if isCollideWithTurt? bunnyagent "circle"
        [
          set frameNum -1
          set scene 2
          ]
        ]
      ]
    ]

end

to createportal [x y]
  create-portals 1 [setxy x y set size 150 set heading 0 set shapeRatio 1]
end
;--------------------------------------------enemies AI

to doMonsterLogic ;observer call
  ask snakes [
    wanderingAI
    attackAi
  ]
end
to wanderingAI
  let defaultSpeed 50
  ;state check
  if state = "none" [
    set state "walking"
  ]
  if state = "walking" [
    if velX = 0 or xcor = min-pxcor[
      set velx defaultSpeed
    ]

    ;turn if on edge of world
    if xcor = max-pxcor[set velx -1 * defaultSpeed]

    ;turn if on edge of plat
    if onWhichPlat != 0 [
      if ([isEdge] of onWhichPlat) = true and lastTurnPlat != onWhichPlat[
        set velx velx * -1
        set lastTurnPlat onWhichPlat
      ]
    ]
  ]
end
to attackBunny ; what happens what monsters att bunny
  ;let variables
  ;set variables
  if breed = snakes [
    set aniFrame 5
  ]

  ;change state
  set state  "attacking"

  ;do damage
  ask bunnyAgent [
    set hp hp - [power] of myself
  ]
end

;---------------------------
to attackAi ; call on all monsters
  ;checkState
  if state = "walking" [
    if isCollideWithTurt? bunnyAgent "circle" [
      ;change state to "attacking"
      attackBunny
    ]
  ]
end


;--------------------------------------------------------------------------------checks
to checkGrounded ;turtle function
  set grounded false
  ;the ground
  if ycor - 5 <= -105 [set grounded true]

 ;check if on platforms
  set onWhichPlat 0 ;no plats
  ask platforms [
    let isColliding false
    set isColliding isCollideWithTurt? myself "rect"
    let turtBot ([rectBot] of myself)
    if isColliding and turtBot >= ycor[
      let plat self
      ask myself [
        ;what turtle does
        set grounded true
        if onWhichPlat = 0 or distance plat < distance onWhichPlat[
          ;update onWhichPlat to closer on
          set onWhichPlat plat
        ]
      ]
    ]
  ]
  ;show onwhichplat debug
end
;------------------------------------------------------------------------- reporters
to-report string-to-list [ s ]
  ;report a list of one letter characters given a string
  report ifelse-value empty? s
    [ [] ]
    [ fput first s string-to-list but-first s ]
end

;--------------------------------------------------------------------------turtle reporters

to-report bunnyAgent
  report turtle bunnyWho
end

to-report carrotAgent
  report turtle carrotWho
end
;-----------------------------------------------------------report true/false

to-report canShiftXY? [shiftX shiftY]
  ;return true if can move distance of shiftX and shiftY

  report canShiftX? shiftX and canShiftY? shiftY
end

to-report canShiftX? [shiftX]
  let ans true
  let newX xcor + shiftX
  if newX > max-pxcor [set ans false]
  if newX < min-pxcor [set ans false]

  if hasWeapon? [
    if not ([canShiftX? shiftX] of turtle weaponWho) [set ans false]
  ]
  if hasHPBar? [
    if not ([canShiftX? shiftX] of turtle HPBarWho) [set ans false]
  ]
  report ans
end

to-report canShiftY? [shiftY]
  let ans true
  let newY ycor + shiftY
  if newY > max-pycor [set ans false]
  if newY < min-pycor [set ans false]

  if hasWeapon? [
    if not ([canShiftY? shiftY] of turtle weaponWho) [set ans false]
  ]
  if hasHPBar? [
    if not ([canShiftX? shiftY] of turtle HPBarWho) [set ans false]
  ]
  report ans
end


to-report hasWeapon?   ;return true or false
  report weaponWho != 0
end

to-report hasHPBar?
  report HPBarWho != 0
end
to-report  isCollidingRectToRect? [right1 left1 top1 bot1 right2 left2 top2 bot2]
  ;return true if rect1 intersects rect2
  ;rect = [right: xcor of right side, left: xcor of left side, top: ycor of top side, bot: ycor of bottom side]
  let isCollide  true
  if (right1 < left2) or (left1 > right2) or (top1 < bot2) or (bot1 > top2) [
    set isCollide false
  ]
  report isCollide
end

to-report  isCollidingCircleToCicle? [x1 y1 r1 x2 y2 r2]
  ;return true if circle1 intersects circles two
  ;circle =  x, y radius
  report (x2 - x1) ^ 2 + (y2 - y1) ^ 2 <= ((r1 + r2) / 2) ^ 2
end


to-report isCollideWithTurt? [otherTurt mode] ;turtle call
  ;mode = "circle" or "rect"
  ;report true if self turtle intersects otherTurt
  let ans false
  ifelse mode = "rect"[
    set ans isCollidingRectToRect? rectRight rectLeft rectTop rectBot
                                  [rectRight] of otherTurt
                                  [rectLeft] of otherTurt
                                  [rectTop] of otherTurt
                                  [rectBot] of otherTurt
  ][ ;default is circle-circle collision
    set ans isCollidingCircleToCicle? xcor ycor (size * shapeRatio)
                                      [xcor] of otherTurt
                                      [ycor] of otherTurt
                                      ([size] of otherTurt * shapeRatio)

  ]
  report ans
end

;report platRight, left, top, bot reports edges of platform
to-report rectRight
  report xcor + size * shapeRatio / 2
end

to-report rectLeft
  report xcor - size * shapeRatio / 2
end

to-report rectTop
  report ycor + size * shapeRatio / 2
end

to-report rectBot
  report ycor - size * shapeRatio / 2
end


@#$#@#$#@
GRAPHICS-WINDOW
210
10
1019
520
-1
-1
1.0
1
17
1
1
1
0
0
0
1
-400
400
-250
250
0
0
1
ticks
30.0

BUTTON
41
38
104
71
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
45
89
100
122
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

BUTTON
70
156
133
189
Jump
jumpUp
NIL
1
T
TURTLE
NIL
W
NIL
NIL
1

BUTTON
122
210
185
243
Right
walkright
NIL
1
T
OBSERVER
NIL
D
NIL
NIL
1

BUTTON
19
210
82
243
Left
walkleft
NIL
1
T
OBSERVER
NIL
A
NIL
NIL
1

BUTTON
30
351
93
384
NIL
swing
NIL
1
T
OBSERVER
NIL
J
NIL
NIL
1

BUTTON
69
262
132
295
Stop
down
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

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

?
true
0
Rectangle -7500403 true true 120 90 135 105
Rectangle -7500403 true true 135 75 165 90
Rectangle -7500403 true true 165 90 195 135
Rectangle -7500403 true true 150 135 165 150
Rectangle -7500403 true true 135 150 150 195
Rectangle -7500403 true true 90 210 105 210
Rectangle -7500403 true true 135 210 150 225

a
true
0
Rectangle -7500403 true true 97 195 127 210
Rectangle -7500403 true true 180 105 195 195
Rectangle -7500403 true true 173 195 203 210
Rectangle -7500403 true true 105 105 120 195
Rectangle -7500403 true true 120 135 180 150
Rectangle -7500403 true true 120 90 135 105
Rectangle -7500403 true true 135 75 165 90
Rectangle -7500403 true true 165 90 180 105

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

b
false
0
Rectangle -7500403 true true 90 210 195 225
Rectangle -7500403 true true 105 105 120 210
Rectangle -7500403 true true 90 90 195 105
Rectangle -7500403 true true 195 105 210 150
Rectangle -7500403 true true 195 165 210 210
Rectangle -7500403 true true 120 150 195 165

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

bunnyl
false
11
Polygon -1 true false 225 165 225 120 180 120 180 105 165 105 165 90 150 90 150 105 105 105 105 90 90 90 90 105 75 105 75 135 60 135 60 150 60 165 45 165 45 180 30 180 30 195 60 195 60 210 75 210 75 225 90 225 90 240 210 240 210 225 210 210 225 210 225 195 240 195 240 210 255 210 255 195 270 195 270 180 255 180 255 165 225 165 225 165
Polygon -7500403 true false 270 195 270 210 255 210 255 225 210 225 210 255 90 255 90 240 75 240 75 225 60 225 60 210 30 210 30 165 45 165 60 165 45 165 45 135 60 135 60 105 75 105 75 45 90 30 105 30 105 45 90 45 105 45 90 60 105 60 105 90 105 105 105 90 120 90 120 75 135 75 135 90 150 90 150 45 165 30 180 30 180 45 165 45 165 60 180 45 165 60 180 60 180 105 225 105 225 120 240 120 240 165 270 165 270 180 270 195 255 195 255 210 240 210 240 195 225 195 225 210 210 210 210 225 210 240 90 240 90 225 75 225 75 210 60 210 60 195 30 195 30 180 45 180 45 165 60 165 60 135 75 135 75 105 90 105 90 90 105 90 105 105 150 105 150 90 165 90 165 105 180 105 180 120 225 120 225 165 240 165 255 165 255 180 270 180 270 180
Rectangle -16777216 true false 75 135 90 180
Rectangle -16777216 true false 135 135 150 180
Rectangle -2064490 true false 105 165 120 180
Circle -13345367 true false 84 249 42
Circle -13345367 true false 174 249 42
Rectangle -1 true false 165 30 225 45
Rectangle -1 true false 90 30 150 45
Rectangle -2064490 true false 165 45 225 60
Rectangle -2064490 true false 90 45 150 60
Polygon -7500403 true false 180 60 165 45 165 60 180 60
Polygon -7500403 true false 105 60 90 45 90 75 105 60 105 60
Rectangle -1184463 true false 195 120 210 195
Polygon -11221820 true false 210 195 210 240 90 240 90 225 75 225 75 210 60 210 60 195 90 195 105 195 210 195 210 195
Circle -6459832 true false 180 180 30

bunnyr
false
11
Polygon -1 true false 75 165 75 120 120 120 120 105 135 105 135 90 150 90 150 105 195 105 195 90 210 90 210 105 225 105 225 135 240 135 240 150 240 165 255 165 255 180 270 180 270 195 240 195 240 210 225 210 225 225 210 225 210 240 90 240 90 225 90 210 75 210 75 195 60 195 60 210 45 210 45 195 30 195 30 180 45 180 45 165 75 165 75 165
Polygon -7500403 true false 30 195 30 210 45 210 45 225 90 225 90 255 210 255 210 240 225 240 225 225 240 225 240 210 270 210 270 165 255 165 240 165 255 165 255 135 240 135 240 105 225 105 225 45 210 30 195 30 195 45 210 45 195 45 210 60 195 60 195 90 195 105 195 90 180 90 180 75 165 75 165 90 150 90 150 45 135 30 120 30 120 45 135 45 135 60 120 45 135 60 120 60 120 105 75 105 75 120 60 120 60 165 30 165 30 180 30 195 45 195 45 210 60 210 60 195 75 195 75 210 90 210 90 225 90 240 210 240 210 225 225 225 225 210 240 210 240 195 270 195 270 180 255 180 255 165 240 165 240 135 225 135 225 105 210 105 210 90 195 90 195 105 150 105 150 90 135 90 135 105 120 105 120 120 75 120 75 165 60 165 45 165 45 180 30 180 30 180
Rectangle -16777216 true false 210 135 225 180
Rectangle -16777216 true false 150 135 165 180
Rectangle -2064490 true false 180 165 195 180
Circle -13345367 true false 84 249 42
Circle -13345367 true false 174 249 42
Rectangle -1 true false 75 30 135 45
Rectangle -1 true false 150 30 210 45
Rectangle -2064490 true false 75 45 135 60
Rectangle -2064490 true false 150 45 210 60
Polygon -7500403 true false 120 60 135 45 135 60 120 60
Polygon -7500403 true false 195 60 210 45 210 75 195 60 195 60
Rectangle -1184463 true false 90 120 105 195
Polygon -11221820 true false 90 195 90 240 210 240 210 225 225 225 225 210 240 210 240 195 210 195 195 195 90 195 90 195
Circle -6459832 true false 90 180 30

bunnyrest
false
11
Polygon -1 true false 90 165 90 120 135 120 135 105 150 105 150 90 165 90 165 105 210 105 210 90 225 90 225 105 240 105 240 135 255 135 255 150 255 165 270 165 270 180 285 180 285 195 255 195 255 210 240 210 240 225 225 225 225 240 105 240 105 225 105 210 90 210 90 195 75 195 75 210 60 210 60 195 45 195 45 180 60 180 60 165 90 165 90 165
Polygon -7500403 true false 45 195 45 210 60 210 60 225 105 225 105 255 225 255 225 240 240 240 240 225 255 225 255 210 285 210 285 165 270 165 255 165 270 165 270 135 255 135 255 105 240 105 240 45 225 30 210 30 210 45 225 45 210 45 225 60 210 60 210 90 210 105 210 90 195 90 195 75 180 75 180 90 165 90 165 45 150 30 135 30 135 45 150 45 150 60 135 45 150 60 135 60 135 105 90 105 90 120 75 120 75 165 45 165 45 180 45 195 60 195 60 210 75 210 75 195 90 195 90 210 105 210 105 225 105 240 225 240 225 225 240 225 240 210 255 210 255 195 285 195 285 180 270 180 270 165 255 165 255 135 240 135 240 105 225 105 225 90 210 90 210 105 165 105 165 90 150 90 150 105 135 105 135 120 90 120 90 165 75 165 60 165 60 180 45 180 45 180
Rectangle -16777216 true false 210 135 225 180
Rectangle -16777216 true false 150 135 165 180
Rectangle -2064490 true false 180 165 195 180
Circle -13345367 true false 99 249 42
Circle -13345367 true false 189 249 42
Rectangle -1 true false 90 30 150 45
Rectangle -1 true false 165 30 225 45
Rectangle -2064490 true false 90 45 150 60
Rectangle -2064490 true false 165 45 225 60
Polygon -7500403 true false 135 60 150 45 150 60 135 60
Polygon -7500403 true false 210 60 225 45 225 75 210 60 210 60
Rectangle -1184463 true false 105 120 120 195
Polygon -11221820 true false 105 195 105 240 225 240 225 225 240 225 240 210 255 210 255 195 225 195 210 195 105 195 105 195
Circle -6459832 true false 105 180 30
Polygon -955883 true false 17 150
Polygon -14835848 true false 13 153 12 123 26 136 32 99 43 128 61 123 59 153 50 156 40 157 35 158 29 152 29 153
Polygon -955883 true false 15 165 15 150 30 150 33 151 42 150 45 150 60 150 37 243

bunnyskull
false
0
Rectangle -16777216 true false 135 120 165 225
Polygon -1 true false 75 165 90 210 210 210 225 165 255 135 255 60 180 15 120 15 45 60 45 135
Circle -2674135 true false 173 75 60
Circle -2674135 true false 73 75 60
Polygon -1 true false 90 165 75 240 105 240 135 120
Rectangle -1 true false 135 135 165 240
Polygon -1 true false 209 170 224 245 194 245 164 125
Polygon -2674135 true false 151 120 175 164 151 150
Polygon -2674135 true false 152 121 130 162 152 151
Polygon -16777216 true false 194 239 167 239 164 212 186 211 191 238 191 238
Polygon -16777216 true false 100 238 115 208 134 208 136 238
Polygon -1 true false 65 282 256 199 268 224 82 298
Rectangle -1 true false 76 240 226 254
Polygon -1 true false 240 281 49 198 38 229 223 297

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

c
true
0
Rectangle -7500403 true true 105 210 195 225
Rectangle -7500403 true true 195 195 210 210
Rectangle -7500403 true true 90 90 105 210
Rectangle -7500403 true true 105 75 195 90
Rectangle -7500403 true true 195 90 210 105

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

carrot
true
0
Polygon -955883 true false 105 165 150 315 195 165
Polygon -14835848 true false 105 165 75 135 135 150 150 120 165 150 225 135 195 165
Line -5825686 false 165 165 172 225
Line -5825686 false 135 165 150 315
Line -5825686 false 135 225 180 195
Line -5825686 false 129 206 185 164
Polygon -2674135 true false 105 165 148 313 195 165 180 165 151 314 120 165

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

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

dot
false
0
Circle -7500403 true true 90 90 120

e
true
0
Rectangle -7500403 true true 105 75 195 90
Rectangle -7500403 true true 180 90 195 105
Rectangle -7500403 true true 120 90 135 210
Rectangle -7500403 true true 135 120 180 135
Rectangle -7500403 true true 105 210 195 225
Rectangle -7500403 true true 180 195 195 210

f
false
0
Rectangle -7500403 true true 90 210 150 225
Rectangle -7500403 true true 195 90 210 105
Rectangle -7500403 true true 195 75 210 90
Rectangle -7500403 true true 105 90 120 210
Rectangle -7500403 true true 90 75 195 90
Rectangle -7500403 true true 120 135 180 150

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

g
true
0
Polygon -7500403 true true 195 90 210 90 210 105 195 105 195 75 120 75 120 90 105 90 105 210 120 225 135 225 195 225 195 210 210 210 210 165 180 165 180 180 195 180 195 210 120 210 120 90 195 90

h
true
0
Rectangle -7500403 true true 180 90 195 210
Rectangle -7500403 true true 120 135 180 150
Rectangle -7500403 true true 98 208 128 223
Rectangle -7500403 true true 172 208 202 223
Rectangle -7500403 true true 98 77 128 92
Rectangle -7500403 true true 172 77 202 92
Rectangle -7500403 true true 105 90 120 210

healthbar0
true
0
Polygon -16777216 true false 60 105 75 105 75 90 90 90 90 75 120 75 120 90 135 90 135 150 120 150 120 165 105 165 105 180 90 180 75 180 75 195 75 180 90 180 90 195 75 195 75 210 60 210 60 195 45 195 45 180 30 180 30 165 15 165 15 150 0 150 0 90 15 90 15 75 45 75 45 90 60 90 60 105 45 105 45 90 15 90 15 150 30 150 30 165 45 165 45 180 60 180 60 195 75 195 75 180 90 180 90 165 105 165 105 150 120 150 120 90 90 90 90 105 75 105 75 120 60 120
Polygon -2064490 true false 15 150 15 90 45 90 45 90 45 105 60 105 60 120 75 120 75 105 90 105 90 90 120 90 120 150 105 150 105 165 90 165 90 180 75 180 75 195 60 195 60 180 45 180 45 165 30 165 30 150 15 150 15 150 15 150
Rectangle -1 true false 90 105 105 120
Polygon -1 true false 135 90 285 90 300 135 285 180 105 180 105 165 120 165 120 150 135 150

healthbar1
true
0
Polygon -16777216 true false 60 105 75 105 75 90 90 90 90 75 120 75 120 90 135 90 135 150 120 150 120 165 105 165 105 180 90 180 75 180 75 195 75 180 90 180 90 195 75 195 75 210 60 210 60 195 45 195 45 180 30 180 30 165 15 165 15 150 0 150 0 90 15 90 15 75 45 75 45 90 60 90 60 105 45 105 45 90 15 90 15 150 30 150 30 165 45 165 45 180 60 180 60 195 75 195 75 180 90 180 90 165 105 165 105 150 120 150 120 90 90 90 90 105 75 105 75 120 60 120
Polygon -2064490 true false 15 150 15 90 45 90 45 90 45 105 60 105 60 120 75 120 75 105 90 105 90 90 120 90 120 150 105 150 105 165 90 165 90 180 75 180 75 195 60 195 60 180 45 180 45 165 30 165 30 150 15 150 15 150 15 150
Rectangle -1 true false 90 105 105 120
Polygon -1 true false 135 90 285 90 300 135 285 180 105 180 105 165 120 165 120 150 135 150
Polygon -5825686 true false 135 90 135 150 120 150 120 165 105 165 105 180 150 180 150 135 150 90

healthbar2
true
0
Polygon -16777216 true false 60 105 75 105 75 90 90 90 90 75 120 75 120 90 135 90 135 150 120 150 120 165 105 165 105 180 90 180 75 180 75 195 75 180 90 180 90 195 75 195 75 210 60 210 60 195 45 195 45 180 30 180 30 165 15 165 15 150 0 150 0 90 15 90 15 75 45 75 45 90 60 90 60 105 45 105 45 90 15 90 15 150 30 150 30 165 45 165 45 180 60 180 60 195 75 195 75 180 90 180 90 165 105 165 105 150 120 150 120 90 90 90 90 105 75 105 75 120 60 120
Polygon -2064490 true false 15 150 15 90 45 90 45 90 45 105 60 105 60 120 75 120 75 105 90 105 90 90 120 90 120 150 105 150 105 165 90 165 90 180 75 180 75 195 60 195 60 180 45 180 45 165 30 165 30 150 15 150 15 150 15 150
Rectangle -1 true false 90 105 105 120
Polygon -1 true false 135 90 285 90 300 135 285 180 105 180 105 165 120 165 120 150 135 150
Polygon -5825686 true false 135 90 135 150 120 150 120 165 105 165 105 180 173 180 171 134 171 90

healthbar3
true
0
Polygon -16777216 true false 60 105 75 105 75 90 90 90 90 75 120 75 120 90 135 90 135 150 120 150 120 165 105 165 105 180 90 180 75 180 75 195 75 180 90 180 90 195 75 195 75 210 60 210 60 195 45 195 45 180 30 180 30 165 15 165 15 150 0 150 0 90 15 90 15 75 45 75 45 90 60 90 60 105 45 105 45 90 15 90 15 150 30 150 30 165 45 165 45 180 60 180 60 195 75 195 75 180 90 180 90 165 105 165 105 150 120 150 120 90 90 90 90 105 75 105 75 120 60 120
Polygon -2064490 true false 15 150 15 90 45 90 45 90 45 105 60 105 60 120 75 120 75 105 90 105 90 90 120 90 120 150 105 150 105 165 90 165 90 180 75 180 75 195 60 195 60 180 45 180 45 165 30 165 30 150 15 150 15 150 15 150
Rectangle -1 true false 90 105 105 120
Polygon -1 true false 135 90 285 90 300 135 285 180 105 180 105 165 120 165 120 150 135 150
Polygon -5825686 true false 135 90 135 150 120 150 120 165 105 165 105 180 180 180 180 135 180 90

healthbar4
true
0
Polygon -16777216 true false 60 105 75 105 75 90 90 90 90 75 120 75 120 90 135 90 135 150 120 150 120 165 105 165 105 180 90 180 75 180 75 195 75 180 90 180 90 195 75 195 75 210 60 210 60 195 45 195 45 180 30 180 30 165 15 165 15 150 0 150 0 90 15 90 15 75 45 75 45 90 60 90 60 105 45 105 45 90 15 90 15 150 30 150 30 165 45 165 45 180 60 180 60 195 75 195 75 180 90 180 90 165 105 165 105 150 120 150 120 90 90 90 90 105 75 105 75 120 60 120
Polygon -2064490 true false 15 150 15 90 45 90 45 90 45 105 60 105 60 120 75 120 75 105 90 105 90 90 120 90 120 150 105 150 105 165 90 165 90 180 75 180 75 195 60 195 60 180 45 180 45 165 30 165 30 150 15 150 15 150 15 150
Rectangle -1 true false 90 105 105 120
Polygon -1 true false 135 90 285 90 300 135 285 180 105 180 105 165 120 165 120 150 135 150
Polygon -5825686 true false 135 90 135 150 120 150 120 165 105 165 105 180 195 180 195 135 195 90

healthbar5
true
0
Polygon -16777216 true false 60 105 75 105 75 90 90 90 90 75 120 75 120 90 135 90 135 150 120 150 120 165 105 165 105 180 90 180 75 180 75 195 75 180 90 180 90 195 75 195 75 210 60 210 60 195 45 195 45 180 30 180 30 165 15 165 15 150 0 150 0 90 15 90 15 75 45 75 45 90 60 90 60 105 45 105 45 90 15 90 15 150 30 150 30 165 45 165 45 180 60 180 60 195 75 195 75 180 90 180 90 165 105 165 105 150 120 150 120 90 90 90 90 105 75 105 75 120 60 120
Polygon -2064490 true false 15 150 15 90 45 90 45 90 45 105 60 105 60 120 75 120 75 105 90 105 90 90 120 90 120 150 105 150 105 165 90 165 90 180 75 180 75 195 60 195 60 180 45 180 45 165 30 165 30 150 15 150 15 150 15 150
Rectangle -1 true false 90 105 105 120
Polygon -1 true false 135 90 285 90 300 135 285 180 105 180 105 165 120 165 120 150 135 150
Polygon -5825686 true false 135 90 135 150 120 150 120 165 105 165 105 180 225 180 225 135 225 90

healthbar6
true
0
Polygon -16777216 true false 60 105 75 105 75 90 90 90 90 75 120 75 120 90 135 90 135 150 120 150 120 165 105 165 105 180 90 180 75 180 75 195 75 180 90 180 90 195 75 195 75 210 60 210 60 195 45 195 45 180 30 180 30 165 15 165 15 150 0 150 0 90 15 90 15 75 45 75 45 90 60 90 60 105 45 105 45 90 15 90 15 150 30 150 30 165 45 165 45 180 60 180 60 195 75 195 75 180 90 180 90 165 105 165 105 150 120 150 120 90 90 90 90 105 75 105 75 120 60 120
Polygon -2064490 true false 15 150 15 90 45 90 45 90 45 105 60 105 60 120 75 120 75 105 90 105 90 90 120 90 120 150 105 150 105 165 90 165 90 180 75 180 75 195 60 195 60 180 45 180 45 165 30 165 30 150 15 150 15 150 15 150
Rectangle -1 true false 90 105 105 120
Polygon -1 true false 135 90 285 90 300 135 285 180 105 180 105 165 120 165 120 150 135 150
Polygon -5825686 true false 135 90 135 150 120 150 120 165 105 165 105 180 255 180 255 135 255 90

healthbar7
true
0
Polygon -16777216 true false 60 105 75 105 75 90 90 90 90 75 120 75 120 90 135 90 135 150 120 150 120 165 105 165 105 180 90 180 75 180 75 195 75 180 90 180 90 195 75 195 75 210 60 210 60 195 45 195 45 180 30 180 30 165 15 165 15 150 0 150 0 90 15 90 15 75 45 75 45 90 60 90 60 105 45 105 45 90 15 90 15 150 30 150 30 165 45 165 45 180 60 180 60 195 75 195 75 180 90 180 90 165 105 165 105 150 120 150 120 90 90 90 90 105 75 105 75 120 60 120
Polygon -2064490 true false 15 150 15 90 45 90 45 90 45 105 60 105 60 120 75 120 75 105 90 105 90 90 120 90 120 150 105 150 105 165 90 165 90 180 75 180 75 195 60 195 60 180 45 180 45 165 30 165 30 150 15 150 15 150 15 150
Rectangle -1 true false 90 105 105 120
Polygon -1 true false 135 90 285 90 300 135 285 180 105 180 105 165 120 165 120 150 135 150
Polygon -5825686 true false 135 90 135 150 120 150 120 165 105 165 105 180 260 180 259 125 259 89

healthbar8
true
0
Polygon -16777216 true false 60 105 75 105 75 90 90 90 90 75 120 75 120 90 135 90 135 150 120 150 120 165 105 165 105 180 90 180 75 180 75 195 75 180 90 180 90 195 75 195 75 210 60 210 60 195 45 195 45 180 30 180 30 165 15 165 15 150 0 150 0 90 15 90 15 75 45 75 45 90 60 90 60 105 45 105 45 90 15 90 15 150 30 150 30 165 45 165 45 180 60 180 60 195 75 195 75 180 90 180 90 165 105 165 105 150 120 150 120 90 90 90 90 105 75 105 75 120 60 120
Polygon -2064490 true false 15 150 15 90 45 90 45 90 45 105 60 105 60 120 75 120 75 105 90 105 90 90 120 90 120 150 105 150 105 165 90 165 90 180 75 180 75 195 60 195 60 180 45 180 45 165 30 165 30 150 15 150 15 150 15 150
Rectangle -1 true false 90 105 105 120
Polygon -1 true false 135 90 285 90 300 135 285 180 105 180 105 165 120 165 120 150 135 150
Polygon -5825686 true false 135 90 135 150 120 150 120 165 105 165 105 180 285 180 300 135 285 90

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

i
true
0
Rectangle -7500403 true true 120 75 180 90
Rectangle -7500403 true true 120 210 180 225
Rectangle -7500403 true true 143 87 158 216

l
true
0
Rectangle -7500403 true true 120 195 195 210
Rectangle -7500403 true true 180 195 195 195
Rectangle -7500403 true true 180 180 195 195
Rectangle -7500403 true true 105 195 120 210
Rectangle -7500403 true true 111 91 126 196
Rectangle -7500403 true true 105 78 134 91

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

m
true
0
Rectangle -7500403 true true 91 197 136 212
Rectangle -7500403 true true 180 96 195 210
Rectangle -7500403 true true 164 82 209 97
Rectangle -7500403 true true 168 107 183 122
Rectangle -7500403 true true 156 121 171 136
Rectangle -7500403 true true 143 149 158 164
Rectangle -7500403 true true 143 136 158 151
Rectangle -7500403 true true 91 82 136 97
Rectangle -7500403 true true 105 96 120 210
Rectangle -7500403 true true 129 121 144 136
Rectangle -7500403 true true 117 107 132 122
Rectangle -7500403 true true 164 197 209 212

mushroom
true
3
Rectangle -7500403 true false 270 120 285 150
Rectangle -7500403 true false 255 105 270 120
Rectangle -7500403 true false 225 75 255 90
Rectangle -7500403 true false 210 45 225 75
Rectangle -7500403 true false 90 30 105 45
Rectangle -7500403 true false 120 15 180 30
Rectangle -7500403 true false 195 30 210 45
Rectangle -7500403 true false 75 45 90 75
Rectangle -7500403 true false 45 75 75 90
Rectangle -7500403 true false 30 90 45 105
Rectangle -7500403 true false 15 120 30 150
Rectangle -7500403 true false 255 150 270 165
Rectangle -7500403 true false 240 165 270 180
Rectangle -7500403 true false 225 180 240 195
Rectangle -7500403 true false 240 195 255 255
Rectangle -7500403 true false 30 150 45 165
Rectangle -7500403 true false 30 165 60 180
Rectangle -7500403 true false 60 180 75 195
Rectangle -7500403 true false 45 195 60 255
Rectangle -7500403 true false 225 255 240 270
Rectangle -7500403 true false 60 255 75 270
Rectangle -7500403 true false 90 285 210 300
Rectangle -1184463 true false 150 45 165 75
Rectangle -1184463 true false 165 60 180 75
Rectangle -1184463 true false 165 60 165 75
Rectangle -1184463 true false 165 45 180 60
Rectangle -1184463 true false 195 90 165 75
Rectangle -1184463 true false 165 75 195 90
Rectangle -1184463 true false 180 60 195 75
Rectangle -1184463 true false 105 105 120 150
Rectangle -1184463 true false 90 120 135 135
Polygon -955883 true false 45 120 60 120 60 105 90 105 90 90 105 90 105 60 120 60 120 45 180 45 180 60 195 60 195 90 210 90 210 105 240 105 240 120 255 120 255 150 240 150 240 165 210 165 90 165 75 165 60 165 60 150 45 150
Polygon -1 true false 75 195 75 255 90 255 90 270 210 270 210 255 225 255 225 195 210 195 210 150 195 150 195 135 165 135 165 150 120 150 105 165 90 165 90 195 75 195
Rectangle -16777216 true false 180 180 195 210
Rectangle -16777216 true false 180 180 195 210
Rectangle -16777216 true false 105 180 120 210
Rectangle -16777216 true false 144 196 159 211
Rectangle -1184463 true false 49 125 62 126
Polygon -1184463 true false 45 120 60 120 60 105 90 105 90 135 75 135 75 150 60 150 45 150
Rectangle -1184463 true false 135 75 150 120
Rectangle -1184463 true false 120 90 165 105
Polygon -1184463 true false 180 60 195 90 195 105 210 105 210 120 240 120 240 105 210 105 210 90 195 90 195 60 180 60 180 60
Polygon -16777216 true false 30 150 30 105 45 105 45 90 75 90 75 75 90 75 90 45 105 45 105 30 195 30 195 45 210 45 210 75 225 75 225 90 255 90 255 120 270 120 270 150 255 150 255 165 240 165 240 180 225 180 225 195 240 195 240 255 225 255 225 285 90 285 75 285 75 255 60 255 60 195 75 195 75 180 60 180 60 165 45 165 45 150 30 150 45 150 45 120 60 120 60 105 90 105 90 90 105 90 105 60 120 60 120 45 180 45 180 60 195 60 195 90 210 90 210 105 240 105 240 120 255 120 255 150 240 150 240 165 210 165 210 195 225 195 225 255 210 255 210 270 90 270 90 255 75 255 75 195 90 195 90 165 60 165 60 150 45 150

mushroomdown
true
3
Polygon -1 true false 45 195 45 255 75 255 90 255 210 255 240 255 255 255 255 195 210 195 210 150 195 150 195 135 165 135 165 150 120 150 105 165 90 165 90 195 75 195
Rectangle -16777216 true false 180 180 195 210
Rectangle -16777216 true false 180 180 195 210
Rectangle -16777216 true false 144 196 159 211
Rectangle -16777216 true false 105 180 120 210
Rectangle -7500403 true false 270 120 285 150
Rectangle -7500403 true false 255 105 270 120
Rectangle -7500403 true false 225 75 255 90
Rectangle -7500403 true false 210 45 225 75
Rectangle -7500403 true false 90 30 105 45
Rectangle -7500403 true false 120 15 180 30
Rectangle -7500403 true false 195 30 210 45
Rectangle -7500403 true false 75 45 90 75
Rectangle -7500403 true false 45 75 75 90
Rectangle -7500403 true false 30 90 45 105
Rectangle -7500403 true false 15 120 30 150
Rectangle -7500403 true false 270 150 285 165
Rectangle -7500403 true false 240 165 270 180
Rectangle -7500403 true false 225 180 240 195
Rectangle -7500403 true false 15 150 30 165
Rectangle -7500403 true false 30 165 60 180
Rectangle -7500403 true false 60 180 75 195
Rectangle -1184463 true false 165 60 165 75
Rectangle -1184463 true false 195 75 165 60
Rectangle -1184463 true false 49 125 62 126
Circle -1 true false 225 195 60
Circle -1 true false 15 195 60
Polygon -16777216 true false 30 165 30 105 45 105 45 90 75 90 75 75 90 75 90 45 105 45 105 30 195 30 195 45 210 45 210 75 225 75 225 90 255 90 255 120 270 120 270 165 240 165 240 180 225 180 225 195 210 195 210 150 195 150 195 135 165 135 165 150 120 150 105 165 90 165 90 195 75 195 75 180 60 180 60 165 30 165 45 165 45 105 75 105 75 90 90 90 90 75 105 75 105 45 195 45 195 75 210 75 210 90 225 90 225 105 255 105 255 120 255 165 225 165 225 180 210 150 195 150 195 135 165 135 165 150 120 150 105 165 90 165 90 195 75 195 75 165 60 165
Polygon -955883 true false 45 165 45 105 75 105 75 90 90 90 90 75 105 75 105 45 180 45 195 45 195 75 210 75 210 90 210 105 255 105 255 150 225 150 225 165 210 165 210 150 195 150 195 135 165 135 165 150 120 150 105 165 90 165 90 195 75 195 75 165 45 165 45 165 45 165 45 165 45 165 45 165
Rectangle -955883 true false 60 165 75 180
Rectangle -955883 true false 225 150 255 165
Rectangle -955883 true false 210 165 225 180

n
true
0
Rectangle -7500403 true true 105 105 120 240
Polygon -7500403 true true 105 105 180 240 195 240 120 105 120 105
Rectangle -7500403 true true 180 105 195 240

no
false
4
Rectangle -7500403 true false 89 105 210 195
Polygon -2674135 true false 180 180 165 180 120 120 135 120
Polygon -2674135 true false 165 120 180 120 135 180 120 180

orgeleftdown
true
0
Polygon -8630108 true false 75 225 75 60 90 60 90 45 105 45 105 30 120 30 120 60 180 60 180 30 195 30 195 45 210 45 210 60 225 60 225 225 210 225 210 240 90 240 90 225
Rectangle -16777216 true false 180 60 195 75
Rectangle -16777216 true false 105 60 120 75
Rectangle -16777216 true false 90 165 210 180
Rectangle -1 true false 180 180 195 195
Rectangle -1 true false 105 180 120 195
Polygon -1 true false 105 90 120 90 120 75 135 75 180 75 180 90 195 90 195 105 210 105 210 135 195 135 195 150 105 150 105 135 90 135 90 105 105 105
Rectangle -16777216 true false 120 105 180 135
Rectangle -2674135 true false 128 105 143 135
Rectangle -16777216 true false 90 240 210 263
Circle -8630108 true false 165 255 30
Circle -8630108 true false 75 255 30
Polygon -8630108 true false 225 120 240 150 255 195 270 195 285 210 285 240 270 240 270 225 255 225 270 255 240 255 240 210
Polygon -8630108 true false 75 120 60 150 45 195 30 195 15 210 15 240 30 240 30 225 45 225 30 255 60 255 60 210

orgerightdown
true
0
Polygon -8630108 true false 75 225 75 60 90 60 90 45 105 45 105 30 120 30 120 60 180 60 180 30 195 30 195 45 210 45 210 60 225 60 225 225 210 225 210 240 90 240 90 225
Rectangle -16777216 true false 180 60 195 75
Rectangle -16777216 true false 105 60 120 75
Rectangle -16777216 true false 90 165 210 180
Rectangle -1 true false 180 180 195 195
Rectangle -1 true false 105 180 120 195
Polygon -1 true false 105 90 120 90 120 75 135 75 180 75 180 90 195 90 195 105 210 105 210 135 195 135 195 150 105 150 105 135 90 135 90 105 105 105
Rectangle -16777216 true false 120 105 180 135
Rectangle -2674135 true false 158 105 173 135
Rectangle -16777216 true false 90 240 210 263
Circle -8630108 true false 195 255 30
Circle -8630108 true false 105 255 30
Polygon -8630108 true false 225 120 240 150 255 195 270 195 285 210 285 240 270 240 270 225 255 225 270 255 240 255 240 210
Polygon -8630108 true false 75 120 60 150 45 195 30 195 15 210 15 240 30 240 30 225 45 225 30 255 60 255 60 210

orgeup
true
0
Polygon -8630108 true false 75 60 90 60 90 45 105 45 105 30 120 30 120 60 180 60 180 30 195 30 195 45 210 45 210 60 225 60 225 135 240 135 240 120 255 120 255 90 285 90 285 105 300 105 300 135 285 135 285 150 270 150 240 150 225 165 225 225 210 225 210 240 90 240 90 225 75 225 75 165 60 150 15 150 15 135 0 135 0 105 15 105 15 90 45 90 45 120 60 120 60 135 75 135
Rectangle -16777216 true false 180 60 195 75
Rectangle -16777216 true false 105 60 120 75
Rectangle -16777216 true false 90 165 210 180
Rectangle -1 true false 180 180 195 195
Rectangle -1 true false 105 180 120 195
Polygon -1 true false 105 90 120 90 120 75 135 75 180 75 180 90 195 90 195 105 210 105 210 135 195 135 195 150 105 150 105 135 90 135 90 105 105 105
Rectangle -16777216 true false 120 105 180 135
Rectangle -2674135 true false 143 105 158 135
Rectangle -16777216 true false 90 240 210 263
Circle -8630108 true false 180 255 30
Circle -8630108 true false 90 255 30
Polygon -1 true false 120 180
Rectangle -7500403 true true 180 195 120 180
Rectangle -2674135 true false 120 180 180 195
Rectangle -16777216 true false 105 195 195 210

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

portal
true
0
Rectangle -5825686 true false 120 15 180 30
Rectangle -5825686 true false 90 30 120 60
Rectangle -5825686 true false 75 45 90 60
Rectangle -5825686 true false 60 60 75 75
Rectangle -5825686 true false 45 75 60 120
Rectangle -5825686 true false 45 180 60 225
Rectangle -5825686 true false 30 105 45 195
Rectangle -5825686 true false 60 225 75 240
Rectangle -5825686 true false 75 240 120 255
Rectangle -5825686 true false 90 255 120 270
Rectangle -5825686 true false 120 270 180 285
Rectangle -5825686 true false 180 30 210 60
Rectangle -5825686 true false 210 45 225 60
Rectangle -5825686 true false 225 60 240 75
Rectangle -5825686 true false 240 75 255 120
Rectangle -5825686 true false 255 105 270 195
Rectangle -5825686 true false 240 180 255 225
Rectangle -5825686 true false 225 225 240 240
Rectangle -5825686 true false 180 240 225 255
Rectangle -5825686 true false 180 255 210 270
Polygon -8630108 true false 120 255 180 255 180 270 120 270
Polygon -8630108 true false 180 240 180 225 225 225 225 210 240 210 240 165 240 120 225 120 225 75 180 75 180 60 225 60 225 75 240 75 240 120 255 120 255 180 240 180 240 225 225 225 225 240
Polygon -13791810 true false 120 60 120 30 180 30 180 75 225 75 225 120 240 120 240 210 225 210 225 225 180 225 180 255 120 255 120 240 75 240 75 225 60 225 60 180 45 180 45 120 60 120 60 75 75 75 75 60
Polygon -13345367 true false 120 150 165 135 120 105 105 135 120 180 165 165 180 135 150 105 120 75 75 135 75 195 120 225 195 195 210 150 195 90 120 60 60 135 75 225 150 225 210 210 210 90 150 60 120 60

r
true
0
Rectangle -7500403 true true 90 75 165 90
Rectangle -7500403 true true 165 90 180 120
Rectangle -7500403 true true 120 120 165 135
Rectangle -7500403 true true 105 90 120 210
Rectangle -7500403 true true 90 210 135 225
Rectangle -7500403 true true 105 135 120 150
Rectangle -7500403 true true 150 150 165 165
Rectangle -7500403 true true 165 165 180 195
Rectangle -7500403 true true 135 135 150 150
Rectangle -7500403 true true 180 195 195 210
Rectangle -7500403 true true 90 75 105 90
Rectangle -7500403 true true 195 210 210 225
Rectangle -7500403 true true 195 210 225 225

rec
true
0
Rectangle -7500403 true true 60 90 240 180

s
true
0
Rectangle -7500403 true true 105 75 165 90
Rectangle -7500403 true true 165 90 195 120
Rectangle -7500403 true true 105 120 135 135
Rectangle -7500403 true true 90 90 105 120
Rectangle -7500403 true true 135 135 165 150
Rectangle -7500403 true true 165 150 195 210
Rectangle -7500403 true true 90 180 105 210
Rectangle -7500403 true true 105 210 165 225

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

skull
false
0
Rectangle -16777216 true false 135 120 165 225
Polygon -1 true false 75 165 90 210 210 210 225 165 255 135 255 60 180 15 120 15 45 60 45 135
Circle -16777216 true false 173 75 60
Circle -16777216 true false 73 75 60
Polygon -1 true false 90 165 75 240 105 240 135 120
Rectangle -1 true false 135 135 165 240
Polygon -1 true false 209 170 224 245 194 245 164 125
Polygon -16777216 true false 151 120 175 164 151 150
Polygon -16777216 true false 152 121 130 162 152 151
Polygon -16777216 true false 194 239 167 239 164 212 186 211 191 238 191 238
Polygon -16777216 true false 100 238 115 208 134 208 136 238
Polygon -1 true false 65 282 256 199 268 224 82 298
Rectangle -1 true false 76 240 226 254
Polygon -1 true false 240 281 49 198 38 229 223 297

snakel
true
0
Polygon -16777216 true false 120 150 120 150
Polygon -11221820 true false 150 120 105 120 105 90 120 90 120 75 165 75 165 90 180 90 180 150 135 195 150 210 180 210 180 195 195 195 195 180 225 165 210 225 195 225 195 240 120 240 105 225 90 210 90 180
Rectangle -1 true false 135 90 150 105
Rectangle -16777216 true false 130 94 141 106

snakela
true
0
Polygon -2674135 true false 105 105 30 120 105 135
Polygon -11221820 true false 150 120 105 135 90 90 120 90 120 75 165 75 165 90 180 90 180 150 135 195 150 210 180 210 180 195 195 195 195 180 225 165 210 225 195 225 195 240 120 240 105 225 90 210 90 180
Polygon -16777216 true false 120 150 120 150
Rectangle -1 true false 135 90 150 105
Rectangle -16777216 true false 130 94 141 106

snaker
true
0
Polygon -16777216 true false 120 150 120 150
Polygon -11221820 true false 150 120 195 120 195 90 180 90 180 75 135 75 135 90 120 90 120 150 165 195 150 210 120 210 120 195 105 195 105 180 75 165 90 225 105 225 105 240 180 240 195 225 210 210 210 180
Rectangle -1 true false 150 90 165 105
Rectangle -16777216 true false 159 94 170 106

snakera
true
0
Polygon -2674135 true false 195 105 270 120 195 135
Polygon -11221820 true false 150 120 195 135 210 90 180 90 180 75 135 75 135 90 120 90 120 150 165 195 150 210 120 210 120 195 105 195 105 180 75 165 90 225 105 225 105 240 180 240 195 225 210 210 210 180
Polygon -16777216 true false 120 150 120 150
Rectangle -1 true false 150 90 165 105
Rectangle -16777216 true false 159 94 170 106

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

t
true
0
Rectangle -7500403 true true 100 75 115 105
Rectangle -7500403 true true 115 77 190 92
Rectangle -7500403 true true 190 76 205 106
Rectangle -7500403 true true 144 91 160 212
Rectangle -7500403 true true 131 210 176 225

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tile stones
false
0
Polygon -7500403 true true 0 240 45 195 75 180 90 165 90 135 45 120 0 135
Polygon -7500403 true true 300 240 285 210 270 180 270 150 300 135 300 225
Polygon -7500403 true true 225 300 240 270 270 255 285 255 300 285 300 300
Polygon -7500403 true true 0 285 30 300 0 300
Polygon -7500403 true true 225 0 210 15 210 30 255 60 285 45 300 30 300 0
Polygon -7500403 true true 0 30 30 0 0 0
Polygon -7500403 true true 15 30 75 0 180 0 195 30 225 60 210 90 135 60 45 60
Polygon -7500403 true true 0 105 30 105 75 120 105 105 90 75 45 75 0 60
Polygon -7500403 true true 300 60 240 75 255 105 285 120 300 105
Polygon -7500403 true true 120 75 120 105 105 135 105 165 165 150 240 150 255 135 240 105 210 105 180 90 150 75
Polygon -7500403 true true 75 300 135 285 195 300
Polygon -7500403 true true 30 285 75 285 120 270 150 270 150 210 90 195 60 210 15 255
Polygon -7500403 true true 180 285 240 255 255 225 255 195 240 165 195 165 150 165 135 195 165 210 165 255

tile water
false
0
Rectangle -7500403 true true -1 0 299 300
Polygon -1 true false 105 259 180 290 212 299 168 271 103 255 32 221 1 216 35 234
Polygon -1 true false 300 161 248 127 195 107 245 141 300 167
Polygon -1 true false 0 157 45 181 79 194 45 166 0 151
Polygon -1 true false 179 42 105 12 60 0 120 30 180 45 254 77 299 93 254 63
Polygon -1 true false 99 91 50 71 0 57 51 81 165 135
Polygon -1 true false 194 224 258 254 295 261 211 221 144 199

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

u
true
0
Rectangle -7500403 true true 165 105 210 120
Rectangle -7500403 true true 90 105 135 120
Rectangle -7500403 true true 180 120 195 225
Rectangle -7500403 true true 105 120 120 225
Rectangle -7500403 true true 120 225 180 240

v
true
0
Rectangle -7500403 true true 135 180 165 195
Rectangle -7500403 true true 120 150 135 180
Rectangle -7500403 true true 105 120 120 150
Rectangle -7500403 true true 75 75 120 90
Rectangle -7500403 true true 195 90 210 120
Rectangle -7500403 true true 180 120 195 150
Rectangle -7500403 true true 165 150 180 180
Rectangle -7500403 true true 90 90 105 120
Rectangle -7500403 true true 180 75 225 90

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

y
true
0
Rectangle -7500403 true true 143 151 160 214
Rectangle -7500403 true true 129 211 174 226
Rectangle -7500403 true true 157 136 172 151
Rectangle -7500403 true true 173 109 190 137
Rectangle -7500403 true true 189 86 206 111
Rectangle -7500403 true true 128 136 143 151
Rectangle -7500403 true true 108 108 125 136
Rectangle -7500403 true true 93 85 110 108

yes
false
4
Rectangle -7500403 true false 92 105 210 195
Circle -14835848 true false 123 118 60
Circle -7500403 true false 139 134 30
@#$#@#$#@
NetLogo 6.0.4
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
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
