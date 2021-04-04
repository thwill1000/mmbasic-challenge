' Copyright (c) vegipete 2021

' Escape to the Green Hills
' Episode Three of the Green Hills Saga
'
' by vegipete
'
' (One was Space Invaders, Two was Missile Command)
'
' Written as one page programs - compressible to a single
' CMM2 editor page of 48 lines of 100 characters.
'
mode 1,8
M6 = MM.VRES : M3 = M6/2 : M8 = MM.HRES : M4 = M8/2 : C = 100 ' used to save some space

' create a mess or custom colours, fading from darker to lighter
' makes items and walls darker the farther away they are.
for i = 1 to 64
  h = i*4-1
  map(207+i/4) = rgb(h,0,h)     ' blue   x32  ceiling/sky
  map( 63+i  ) = h<<8           ' green  x64  hills (first 16 overwritten by grey)
  map( 63+i/4) = rgb(h,h,h)     ' grey   x16  walls
  map(175+i/2) = rgb(h,i*2-1,0) ' brown  x32  floor/sunset
  map( 31+i/2) = h              ' purple x16  phasor
next
map set   ' lock 'em in
cls map(65)   ' dark grey

T1$ = "Escape to " : T2$ = "The Green Hills"
text M4,M4/2,T1$+T2$,CM,5,1,map(99),-1
text M4,M3,"by VegiPete",CM,3,1,map(99),-1

p 2   ' build background image
cls
for i = 0 to M3
  line 0,i,M8,i,1,map(63-i/10)   ' blue above
  line 0,M6-i,M8,M6-i,1,map(207-i/10) ' brown below
next
page copy 2,3   ' save ground and sky for end game
triangle M3,M3,-1,M6/3+4,-1,4*M3/3-4,,map(70) ' fake offset walls
triangle M3,M3,M6,M6/3+4,M6,4*M3/3-4,,map(70) ' cludge that works remarkably well
playerangle = 0 ' 0=up, 1=right, 2=down, 3=left

p 3    ' create end game image
for i = 0 to 47
  circle 950,700,C+i*7,9,1.5,map(127-i)   ' right hill
next
for i = 0 to 47
  circle C,750,158+i*7,9,1.5,map(127-i)   ' left hill
next

p 1   ' likely un-needed
g$ = "This is level 7. Don't miss the destruct button on level 3!"

' The maze is stored in the 'upper left corner' of the array.
' Each row is 30 elements, so moving up one cell means decreasing the element index by 30, etc.
' Blank space: 0, Wall : 9,   See DrawThing for more item numbers.
dim maze(900),moveoffset(3) = (-30,1,30,-1)
' Various shapes are stored in arrays for drawing as polygons.
' The SCALE command is great for making nearer object appear larger.
dim px(7),py(7),bx(7) = (3,3,1.5,1.5,3,12,12,3),by(7) = (-3,3,1.5,-1.5,-3,-3,3,3) ' walls
dim g1(4),g2(4)
dim gx(4) = (0,-1,-3,-2,5),gy(4) = (0,5,5,-2,-1)          ' gun
dim dx(4) = (8,-8,-4,4,8), dy(4) = (10,10,-15,-15,10)     ' destruct pedestal
dim ix(4) = (3,-9,-1,8,3), iy(4) = (4,5,-5,-6,4)          ' info sheet
dim ax(4) = (2,1,-1,-2,2), ay(4) = (-11,-8,-8,-11,-11)    ' destruct activated (green)
dim hx(4) = (2,1,-1,-2,2), hy(4) = (-11,-14,-14,-11,-11)  ' destruct harmless (red)

ReadNextMaze    ' read the first maze
pause 999     ' show intro screen for a while
DrawView
dead = 0
done = 0
destructactive = 0
do
  leveldone = 0
  do
    k = asc(INKEY$) ' grab any key press
    redraw = 0
    select case k
      case 128,129 ' UP arrow = forwards ' DOWN arrow = backwards
        newposn = playerposn+moveoffset(playerangle)*((k = 128)-(k = 129))
        if maze(newposn)<>9 then
          playerposn = newposn
          redraw = 1
        endif
      case 32 ' space bar
        if gotphasor then
          line M6,M6,M4,M3,1,rgb(yellow)
          for i = 1 to 150
            play tone M6-i,510-i
            pause 1
          next
          play stop
          shotposn = playerposn    ' shot starts from player cell
          do while maze(shotposn)<>9
            if maze(shotposn)<>4 then
              shotposn = shotposn+moveoffset(playerangle)
            else
              blobhitcnt = blobhitcnt-1
              if blobhitcnt = 1 then
                maze(shotposn) = 0
                e = 0
              endif
              shotposn = 0
            endif
          loop
          redraw = 1
        endif
      case 115 ' s save graphic image as bmp
        save image "screenshot",0,0,M4,M4
      case 130,131 ' LEFT arrow = turn left 90 ' RIGHT arrow = turn right 90
        playerangle = playerangle+1+2*(k = 130)
        playerangle = playerangle mod 4
        redraw = 1
    end select
    if timer>999 and e = 4 then   ' time to move enemy blob?
      hd = int(rnd*4)   ' pick a random direction
      if maze(hz+moveoffset(hd)) = 0 then  ' and move there if it's open
        maze(hz) = 0
        hz = hz+moveoffset(hd)
        redraw = 1
        maze(hz) = 4
      endif
      timer = 0
    endif

    if redraw then   ' only update display if something has changed
      DrawView
      redraw = 0
    endif

    if destructactive = 2 then  ' 2 stage to see switch 'animation'
      maze(playerposn) = 6
      destructactive = 1
      pause 500     ' view switch off for a bit
      DrawView      ' then redraw view with switch on
    endif
  loop until leveldone+dead  ' same as OR statement

  if not dead then
    ReadNextMaze    ' read next level
    DrawView 1      ' render it on page 1, but don't show it
    circle M3,0,48,1,3.5,0,0    ' draw hole in ceiling
    p 0
    for i = 1 to 15
      blit C,5,C,0,M6,594   ' scroll just finished level up a bit
    next
    for i = 0 to M6 step 5  ' scroll last level off the top as new level appears from bottom
      if done then
        blit C,5,C,0,M6,M6-i-5
        blit 0,M6-i-5,0,M6-i-5,M8,i+5,3  ' green hills appear
      else
        blit C,5,C,0,M6,594
        blit 0,0,C,M6-i,M6,i,1    ' next level scrolls up
      endif
    next
  endif
loop until done+dead    ' loop finished if all levels done OR player is dead

' test how game ended and draw suitable
if destructactive then
  text M4,M4/2,T2$+" - safe at last?",CM,5,1,map(99),-1  ' Question Mark!?!?!? Another sequel?
else  ' no pyramid destruction - oh woe be unto us!
  pause 2500
  text M4,M4/2,"No destruct.",CB,5,1,map(224),-1
  text M4,M4/2,T2$+" are Doomed!",CT,5,1,map(224),-1
  pause 3000
  for j = 1 to 5000     ' spiffy death animation - WOW, SO COOL!
    x = rnd*800
    y = rnd*600
    for i = 1 to 15
      circle x+i,y-i,i,1,3,map(79-i)
  next i,j
endif
?@(0,M6-50)"The End"
end

' Show a text string middle of screen
sub ShowText t$,f,b
  text M3,M3,t$,CM,,,MAP(f),MAP(b)
end sub

' Draw the current view on page 1
' Copy to page 0 if parameter is zero
' Uses a painter's algorithm to cover farther drawn walls with nearer ones
sub DrawView ns
  p 1
  page copy 2,1
  for faraway = 7 to 0 step -1
    vp = playerposn+moveoffset(playerangle)*faraway
    if vp>0 and vp<900 then
      SideWall(7-faraway,-1)
      SideWall(7-faraway,1)
      ah = maze(vp)
      if ah = 9 then    ' wall directly in front - ought to be handled by DrawThing
        off = by(1)*2^(7-faraway)
        box M3-off,M3-off,2*off+1,2*off+1,1,,map(71-faraway) 'Look at all
      elseif ah<>0 then
        DrawThing faraway,ah
      endif
    endif
  next
  if ns then
    exit sub
  endif
  if blobhitcnt = 1 then
    blobhitcnt = 0
    ShowText "Got 'im!",0,121
  endif
  p 0
  blit 0,0,C,0,M6,M6,1'space
end sub

' Draw a left or right wall at given distance
' sd determines which side
sub SideWall faraway,sd
  sp = max(0,min(vp+moveoffset((playerangle+2-sd)AND 3),900))
  if maze(sp) = 9 then
    math scale bx(),sd*2^faraway,px()
    math add px(),M3,px()
    math scale by(),sd*2^faraway,py()
    math add py(),M3,py()
    polygon 8,px(),py(),,map(64+faraway)
  endif
end sub

' Page Write mini-command - save much space
sub p k
  page write k
end sub

' Draw circle mini-command - used to draw portion of green enemy blob
sub DC h
  circle M3,M3+h,ey,0,1.5,0,MAP(115-2*faraway)
end sub

' Draw something a distance in front of player
' 2 : info paper
' 3 : phasor
' 4 : gelatinous blob
' 5 : destruct inactive (red)
' 6 : destruct active (green)
' 8 : exit hole in floor
' 9 : wall - not drawn here but probably should be...
sub DrawThing faraway,item
  select case item
    case 8
      off = min(M3,4.5*2^(6-faraway))
      circle M3,M3+off,off/6,1,3.5,0,0
      leveldone = (faraway = 0)   ' set if standing on exit
    case 4
      ey = 2^(7-faraway)  ' enemy height/size based on distance away
      DC ey
      DC -ey
      circle M3,M3,ey,0,2,0,MAP(121-2*faraway)
      if faraway = 0 then   ' same cell as gelatinous blob
        ShowText "Gotcha!",0,121
        dead = 1
      endif
    case 2
      if faraway = 0 then   ' test if at object
        ShowText g$,0,255
        maze(playerposn) = 0
      else                  ' otherwise, show it farther away
        DrawShape ix(),iy(),faraway,78-faraway
      endif
    case 3
      if faraway = 0 then
        ShowText "A Phasor! Awesome!",0,221
        maze(playerposn) = 0
        gotphasor = 1
      else
        DrawShape gx(),gy(),faraway,221-faraway
      endif
    case 5,6
      DrawShape dx(),dy(),faraway,60-faraway
      if faraway = 0 and item = 5 then
        ShowText "Destruct Activated!",255,60
        destructactive = 2
      endif
      if item = 5 then
        DrawShape hx(),hy(),faraway,224
      else
        DrawShape ax(),ay(),faraway,126
      endif
  end select
end sub

' Draw shape contained in passed array at given distance in given colour
sub DrawShape xa(),ya(),faraway,colr
  math scale xa(),2^(4-faraway),g1()
  math add g1(),M3,g1()
  math scale ya(),2^(4-faraway),g2()
  math add g2(),M3+2^(8-faraway),g2()
  polygon 5,g1(),g2(),,map(colr)
end sub

sub ReadNextMaze
  mp = 0
  read a
  if a = 0 then
    done = 1
    exit sub
  endif
  playerposn = a
  read a,hz,e,w
  read m$
  math set 1,maze()
  for i = 1 to len(m$)-w+1 step w
    r = 0
    for j = 1 to w
      r = r*64+asc(mid$(m$,j+i-1))-40
    next
    for j = 1 to 6*w
      maze(mp) = r and 1
      mp = mp+1
      r = r>>1
    next
    mp = (mp+30)\30*30
  next
  math scale maze(),9,maze()
  maze(a) = 8
  maze(hz) = e
  blobhitcnt = 5
end sub

' level data
' format: <player start position>,<exit posn>,<item posn>,<item type>,"map"
' see DrawThing header for item types
data 62,91,0,9,1,"G9C9G"
data 93,95,35,2,2,")g)))e)9)E)))g"
data 153,155,93,3,2,"/g,)-],=-E-=-],)/g"
data 37,35,151,4,2,"Gg9)?e=9=E=)<?9Y?E8)Gg"  'this unused
data 186,338,279,4,3,")gg))))?e)89)E=)-])\-)-])_-))e)E-)19)gg"
data 217,338,340,5,3,"/gg-)),?E-89-E=--=-_],,=-g--)e-E--19-E?,(9/gg"
data 217,45,75,4,3,"Ggg<,)=_E9<9EE=9)=?_=8,=GG]8)-?=E9E9E=?9(9?ge8()Ggg"
data 163,511,278,4,4
data ")ggg)))))E=E)8<-)?_]),89)_??)-99)EEE)))))EeE),-9)]e?),(9)?_])8<-)E=E)))))ggg"
data 0

