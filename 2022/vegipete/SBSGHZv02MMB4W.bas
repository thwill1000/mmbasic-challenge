' Stellar Battle in the Seven Green Hills Zone by Vegipete 2022
' Slightly modified to work with MMB4W
'   (modifications: draw circles in the radar image to improve visibility)
'   (               adjust colour codes - different RGB order?)
option angle degrees
option default integer
mode 1,8:cls
const TANKSPEED=15
const SHOTSPEED=150
const ARENASIZE=6E4
const BLASTRADIUS=5E4

' object array holds all the items in the arena:
'  0) player-unused
'  1) player shot 1
'  2) player shot 2
'  3) enemy shot 1
'  4) enemy shot 2
'  5) fuel bay
'  6) stargate
'  7) enemy 1
'  8) enemy 2
'  9-20) obstacles
'  -------
'  0) exists
'  1) x position
'  2) y position
'  3) angle
'  4) velocity    (shot: dx)
'  5) (shot velocity: dy)
'  6) type: 1=shot, 2=pyramid, 3=cube, 4=fuel, 5=stargate, 6=tank1, 7=tank2
const ASSETCOUNT=20
dim distaway(ASSETCOUNT),object(ASSETCOUNT,6),distindx(ASSETCOUNT)

dim ctable(8)=(&h2A2AA5,&hFF00,&hAF00,&h6000,2^14,0,&hFFC000,&hC000FF,&h404040)
dim hills(18)=(0,3,7,2,9,3,6,2,8,12,9,1,6,2,9,3,6,1,0) ' fold this into 3D data

dim fv(64),fcnt(20),ecol(20),fcol(20)
dim s(200)    ' longstring for holding 3D object data for decoding
dim t(9)      ' tank AI counters
dim float h,fuel,shield,v(2,32),ct,st,q(4)

' 3D object data - carefully compressed
' Two big compression techniques:
' 1) numbers compressed into ascii codes, where "A"=0 (no commas, single byte per value)
' 2) entire repeated data array can be skipped
'    For example, the pyramid obstacles have chopped off tops, so data-wise, they are
'    identical to the cubes. Only the the actual vertex coordinates are unique between
'    the two object. All the other arrays can be rpresented by a single 'repeat' byte.
LA "EEDDDDHAAAHAAA>CAAHADCAAEJJLABCCBDBADACDIFEEEEEEEEEEDDDDD8A8JA8JAJ8AJ@S@BS@B"
LA "SB@SBNTAEFBBFGCCGHDDHEAHGFEIF!!!=A=EA=EAE=AE=I=EI=EIE=IEZANKEEEEEEDDDDEEEEEE"
LA "BBBBAAAAACBBBB<A<FA<FAF<AF?B?CB?CBC?BC>G>DG>DGD>GDAIAUdAEFBBFGCCGHDDHEAHGFEI"
LA "JKLIMJJMKKMLLMINK!EEEEEEGGGGGGGGBBDDDD@A@BA@BAB@AB?M?CM?CMC?MCAM7GMAAMK;MAAQ"
LA "AKALIDDDDEEEDEEEEEEEEBBBBCCCEDA9DAI>AI>A9AF:BD@BEJ@EJ@D@AE=AFJU[AEBBECCEDADE"
LA "FGHIFJKGIHKJGKHPNEEEEEDDDDEEEDEEEEEEEEEEEEEEDDDDCCCCBBBEDA9DAJ>AJ>A9ED8EDK=D"
LA "K=D8AH;BFCBGK@GK@FCAG?AHKPoABCDAEFBBFGCCGHDADHEEIFFIGGIHHIEJKLMJNOKMLONKOL  "
k=1
do
  nv=NB() ' read number of vertices for next object
  if nv<-32 then exit do
  nf=NB() ' read number of faces
  RC(fcnt())  ' read number of vertices for each face
  RC(ecol())  ' read colour of edge of each face
  RC(fcol())  ' read colour of each face
  for j=0to nv-1:v(0,j)=NB():v(1,j)=NB():v(2,j)=NB():next ' read vertex coordinates
  sc=NB():math scale v(),sc,v() ' read and scale vertex cloud
  tot=NB()  ' total number of vertices of faces, skip if 0 (no change)
  if tot then for j=0to tot:fv(j)=NB():next  ' vertices for each face
  draw3d create k,nv,nf,1,v(),fcnt(),fv(),ctable(),ecol(),fcol()
  inc k
loop

for i=1to 8:read object(i,6):next:data 1,1,1,1,4,5,6,7 ' object types

' paint ringed planet sprite
PW 3
cls
circle 400,300,21,,4,ctable(2),ctable(2)    ' rings OD
circle 400,300,15,,4,0,0                    ' rings ID
blit read 9,370,300,60,30                   ' store rings in front of planet
circle 400,300,30,,,ctable(3),ctable(3)     ' draw planet
blit write 9,370,300,4                      ' restore rings in front of planet
image rotate 300,200,200,200,300,200,15     ' rotated looks cooler
blit read 1,315,268,170,64                  ' save ringed planet image for later use

' Start a new game
h=0       ' player heading
fuel=99
shield=99
level=1
demo=0    ' demo mode on to start
wpage=0   ' page flipping
newpress=1

' bigger zoom=narrower field of view : zoom in, 500 is near 90 degrees
zoom=500
draw3d camera 1,zoom,0,75

MakeObstacles

settick 25,MM,1   ' start timer interrupt for sound and shield repair

do
  ' test for key presses
  if keydown(0)then
    ServiceKey 1
    ServiceKey 2
  endif
  ' MODIFIER pressed-create a new shot of there is none and hasn't been one for a while
  if keydown(7)then
    if newpress then
      newpress=0  ' edge select the keypress so only one shot is created
      for i=1to demo*2
        if object(i,0)=0 then v2=25:NewShot(i,0,0,-h):i=3   ' force loop to end
      next
    endif
  else
    newpress=1
  endif
  
  ' move various objects
  ' 1) move shots, test for hits
  for i=1to 4
    if object(i,0)then  ' shot exists
      inc object(i,0),-sgn(object(i,0))  ' shot expires after a while
      target = MoveBlocked(i,7,object(i,4),object(i,5))  ' shot hits something
      if target>6 then  ' hit an enemy tank or an obstacle
        object(i,0)=-object(i,0)          ' shot gone
        if target<9 then                  ' hit an enemy tank
          v1=75                           ' play explosion sound
          object(target,1)=ARENASIZE/2    ' new tank x-coord
          object(target,2)=ARENASIZE/target   ' new tank y-coord
          object(target,3)=rnd*360        ' new tank angle
          inc score,demo                  ' no score increase in demo mode
          if score>level*9 and object(6,0)=0 then v4=99:object(6,0)=1   ' stargate appears
        endif
      endif
    endif
  next
  ' 2) stargate slowly turns
  inc object(6,3),1
  ' 3) enemies turn towards player and move
  TurnEnemy(7)
  TurnEnemy(8)
  ' 4) slowly turn view if in demo mode
  if demo=0 then h=h+1/10
  ' 5) keep heading in range (0,360]
  if h>360 then h=h-360   ' can't use MOD because we loose the decimal part
  if h<0 then h=h+360
  
  ' Test for game over
  if shield<0 then
    PW 0
    for i = 0 to 999
      line 0,600*rnd,800,600*rnd,,ctable(0)
      pause 2
    next
    text MM.HRES/2,MM.VRES/2,"GAME OVER",CT,3,,ctable(0)
    pause 4000
    demo=0  ' back to demo mode
    shield=99
    NewLevel
  endif

  ' draw scene
  DrawScene
  if qx+qy then sprite scroll qx,qy:qx=0:qy=0   ' shake screen if hit

  ' wait for framerate, then display
  do : loop until timer>20
  timer=0
  page copy wpage+1,0,D
  wpage=wpage=0 ' toggle drawing page
loop

end

'==================
sub ServiceKey(k)
  k=keydown(k)
  if k+demo=32 then h=0:level=1:demo=1:score=0:NewLevel ' space bar to end demo mode
  h = (h+360-(k=130)*demo+(k=131)*demo)mod 360 ' turn left or right if not demo mode
  MoveForward 50*((k=128)-(k=129))  ' fold subroutine in here
end sub

'==================
' Since the camera can't move, everything else must move instead
' Move forward requested distance in direction we are facing,
' unless blocked by items 7 thru 20.
' Handle encounters with fuel bay and star gate
sub MoveForward(dist)

  if fuel<0 or dist*demo=0 then exit sub   ' no gas left, no distance or demo mode
  fuel=fuel-(fuel>0)/200   ' burn more fuel while moving
  dx=sin(h)*dist
  dy=cos(h)*dist
  
  i = MoveBlocked(0,5,dx,dy)  ' player try to move forward
  if i<6 then  ' move forward and clamp into the arena
    for i=1to ASSETCOUNT:Clamp2Screen(object(i,1),-dx):Clamp2Screen(object(i,2),-dy):next
  elseif i=6 then  ' drive thru star gate?
    PW 0
    for i=1to 999:n=rnd*360:line 400,300,400+500*sin(n),300+500*cos(n),,&hFFFF:pause 1:next
    h=(h+180)mod 360
    inc level
    NewLevel
  else
    v3=-2:shield=shield-1 ' bump sound, damage from crashing into something
  endif
end sub

'==================
' create a new shot
sub NewShot(n,x,y,h)
  object(n,0)=90*demo  ' shot duration
  object(n,1)=x
  object(n,2)=y
  object(n,3)=h
  object(n,4)=-sin(h)*SHOTSPEED  ' dx
  object(n,5)= cos(h)*SHOTSPEED  ' dy
end sub

'==================
sub Clamp2Screen(c,d):c=(c+d+1.5*ARENASIZE)mod ARENASIZE-ARENASIZE/2:end sub

'==================
' Can object n move dx,dy?  n is 0,1,2,3,4,7,8
' Test against selectable other objects  (, except fuel bay)
function MoveBlocked(n,f,dx,dy)
  'local x,y,j
  MoveBlocked=1
  x=object(n,1):Clamp2Screen(x,dx)
  y=object(n,2):Clamp2Screen(y,dy)
  
  ' enemy tank can't drive through player
  if n>6 and x^2+y^2<BLASTRADIUS then exit function
  
  for j=f to 20
    j=j+(j=n)+(n+4=j)  ' tank can't block or shoot itself
    if (object(j,1)-x)^2+(object(j,2)-y)^2<BLASTRADIUS then MoveBlocked=j:exit function
  next
  MoveBlocked=0
  if n then object(n,1)=x:object(n,2)=y ' update position if not blocked
end function

'==================
' Create and display a new level
sub NewLevel
  MakeObstacles
  DrawScene
  ' open iris new world over star travel spray
  PW 0
  for i =1 to 400
    blit 400-i,300-i,400-i,300-i,i*2,i*2,wpage+1
    box 400-i,300-i,i*2,i*2,8,&hFFFF
    pause 1/i
  next
end sub

'==================
sub TurnEnemy(n)
  local h,te
  
  ' busy with obstacle avoidance turn?
  if t(n)then inc t(n),-sgn(t(n)):object(n,3)=(object(n,3)+sgn(t(n))*2)mod 360:exit sub
  ' adjust angle towards origin
  te=atan2(object(n,1),-object(n,2)):inc te,360*(te<0)  ' direction toward origin/player
  h=(object(n,3)-te)mod 360
  
  ' shoot if aimed at origin/player and no shot in flight
  if h=0 and object(n-4,0)=0 then NewShot(n-4,object(n,1),object(n,2),object(n,3))
  'te=1:if h>0 then te=-1
  te=-sgn(h)
  if abs(h)>180 then te=-te 'NG te
  object(n,3)=(object(n,3)+te)mod 360  ' new enemy heading
  
  ' enemy try to move forward
  if MoveBlocked(n,5,-sin(object(n,3))*object(n,4),cos(object(n,3))*object(n,4))then
    ' can't move that way, so start a random turn left or right
    t(n)=60*sgn(rnd-.5)
  endif
end sub

'==================
' Create a bunch of objects
sub MakeObstacles
  'local i

  for i=1to 4:object(i,0)=0:PositionItem(i+4):next  ' clear shots, create FB,SG, enemy tanks
  
  object(7,4)=TANKSPEED*2 + 2*level  ' speedy!
  object(8,4)=TANKSPEED + 2*level
  
  for i=9to ASSETCOUNT
    PositionItem(i)
    object(i,6)=2 + (rnd<.5)  ' assume it's a pyramid to start, randomly change to cube
  next
end sub

'==================
sub PositionItem(n)
  local  x,y

  object(n,0)=(n<>6)    ' items visible except star gate not visible at start
  do
    x=rnd*ARENASIZE-ARENASIZE/2
    y=rnd*ARENASIZE-ARENASIZE/2
  loop while x^2 + y^2<4E6
  object(n,1)=x  ' x position
  object(n,2)=y  ' y position
  object(n,3)=rnd*360  ' angle

end sub

'==================
' test player has been hit by enemy shot n
sub PlayerHit(n)
  if object(n,0)>0 then
    object(n,0)=-object(n,0)
    inc shield,-5*demo
    qx=rnd*10-5 ' wiggle the screen image
    qy=rnd*10-5

    v3=-3
  endif
end sub

'==================
' Draw background and all the visible 3D objects, from farthest to nearest
sub DrawScene
  local i,n,ix,j

  ' calculate distance to each item
  for i=1to ASSETCOUNT:distaway(i)=object(i,1)^2+object(i,2)^2:next
  
  ' test if player hit by enemy shot
  for i=3to 4:if distaway(i)<BLASTRADIUS then PlayerHit(i)
  next

  fuel=fuel-demo*(fuel>0)/200  ' use up fuel
  ' sitting in fuel bay?
  if distaway(5)<BLASTRADIUS then fuel=100:shield=min(100,shield+sr/500):sr=0

  sort distaway(),distindx(),1  ' sort largest/farthest to smallest/nearest

  ct=cos(h)
  st=sin(h)

  PW wpage+1
  cls
  line 0,MM.VRES/2,MM.HRES,MM.VRES/2,1,ctable(3)  ' horizon line

  if h>240 and h<340 then blit write 1,3100-h*9.6,MM.VRES/10  ' Saturn
  circle 800-h*9.6,MM.VRES/3,20,0,1,,ctable(3)  ' moon
  circle 800-h*9.6-9,MM.VRES/3+3,20,0,1,,0      ' change it to a crescent
  circle 1440-h*9.6,MM.VRES/5,30,0,1,,rgb(128,255,0) ' sun

  ' draw those dear green hills
  ix=(h-.49)\20       ' index at center (0.49 for rounding reasons)
  n=-h*10 mod 200

  for i=0to 5
    j=(ix+i+15)mod 18
    line n,300-hills(j)*10,n+200,300-hills(j+1)*10,,ctable(3)
    n=n+200
  next

  PW 3
  box 0,0,102,102,1,&h404040,0  ' clear radar image

  for i=1to ASSETCOUNT
    n=distindx(i)
    if object(n,0)>0 then  ' exists/visible
    
      ' first, add blip to radar image
      PW 3
      ' revolve items
      x=object(n,1)*ct-object(n,2)*st
      y=object(n,1)*st + object(n,2)*ct
      
      ' stargate in blue, fuel bay in green
      circle 51+x*140/ARENASIZE,51-y*140/ARENASIZE,1,,,ctable(0+6*(object(n,6)=5)+(object(n,6)=4))  
      circle 51,51,1,,,rgb(yellow)   ' player in center-redraw to ensure visible

      ' min 220 to avoid drawing bug?
      if y>150 and abs(x)<y then
        PW wpage+1
        math q_euler object(n,3)+h,0,0,q()
        draw3d rotate q(),object(n,6)
        draw3d write object(n,6),x,0,y
      endif
    endif
  next

  PW wpage+1
  blit 0,0,MM.HRES/2-31,MM.VRES-103,102,102,3 ' copy map into view
  box MM.HRES/2-31,MM.VRES-103,102,102,1,rgb(grey) 'redraw frame
  text MM.HRES/2,6,"LEVEL:"+str$(level,2)+"  SCORE:"+str$(score,3),CT,,,ctable(1) ',ctable(4)
  text MM.HRES/2,MM.VRES-105,"S F  HEADING: "+str$(h,3,0),CB,,,ctable(1) ',ctable(4)
  DrawGauge(MM.HRES/2-69,shield)
  DrawGauge(MM.HRES/2-54,fuel)
  if demo=0 then text MM.HRES/2,MM.VRES/4,"SPACE to Play",CB,3,,ctable(1)
end sub

' set write page
sub PW n:page write n:end sub

' Draw gauge to show shield or fuel
sub DrawGauge(x,g)
  box x,497,10,102,1,&h404040,0
  if g>0 then box x+1,598-g,8,g,4,ctable(g>25)
end sub

' Read an array of data, or leave previous untouched
sub RC(c())
  local j,tmp
  tmp=NB():if tmp<>-32 then c(0)=tmp:for j=1to nf-1:c(j)=NB():next
end sub

' Read next byte from data string
function NB()
  static n:NB=lgetbyte(s(),n)-65:inc n
end function

' Build lonstring of data
sub LA z$
  longstring append s(),z$
end sub

' Timer interrupt
sub MM  'fade out sound
  play sound 1,b,n,99,v1/3 : v1=v1-(v1>0)  ' decrease volume of explosion sound
  play sound 2,b,p,99-v2,v2 : v2=v2-(v2>0)  ' decrease volume of shot sound
  play sound 3,b,n,200,20*(v3<>0) : v3=v3+(v3<0)
  play sound 4,b,t,499-99*sin(v4),v4/4 : v4=v4-(v4>0)  ' star gate appear
  inc sr  ' shield repair
end sub
'=============

