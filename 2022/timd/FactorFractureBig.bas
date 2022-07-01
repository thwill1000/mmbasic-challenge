cls:mode 8,8                 ' Clear screen and set to 640x480, 8-bit colour

dim a(22,22)  ' a():  Arena grid
dim x(23)     ' x():  X-coordinate for sprites (pixels)
dim y(23)     ' y():  Y-coordinate for sprites (pixels)
dim z(23)     ' z():  Type of sprite
dim dx(23)    ' Change of X-coordinate for sprites
dim dy(23)    ' Change of Y-coordinate for sprites
dim v(23)     ' Sprite visible
dim bx(34)    ' X-Position of boxes within arena grid
dim by(34)    ' Y-Position of boxes within arena grid
dim j(34)     ' Sequence of objects within boxes
dim cl(30)    ' Colour palette for sprites

t=200         ' Player transparency duration
u=520         ' X-Position of factor/level/score/time/lives

s=14542:for cn=1 to 30:cl(cn)=rgb(R(5)*32,R(5)*32,R(3)*64):next   ' Store colour palette for sprites (dark colours)

' Create sprite sheet ----------

' Sprite 1:      Player
' Sprite 2:      Bullet
' Sprites 3-18:  Standard enemies
' Sprite 19:     'Zero' enemy
' Sprite 20-23:  Used for 'fracture' animation

PW(2)                                         ' Screen page 2
?chr$(246):sprite read 2,1,2,6,7,2            ' Read sprite for bullet (divide symbol)

for l=0 to 20 step 20                         ' 2 rows: First row solid, second row transparent

  ' Draw calculator
  box 19,l,19,19,,map(255),map(105)*(l=0)         
  box 22,3+l,13,5,1,map(255),map(116)*(l=0)
  for rx=21 to 35 step 2
    for ry=10 to 16 step 2
      pixel rx,ry+l,map(255)
    next
  next

  ' Rotate 90` 3 times
  for p=38 to 76 step 19
    for rx=0 to 18
      for ry=0 to 18
        pixel p+rx,ry+l,pixel(p-19+ry,18-rx+l)     
      next
    next
  next

next

for p=0 to 30                   ' Enemies 0-30
  ' Draw each enemy number
  h=p*20
  line h,51,h+18,69
  line h,69,h+18,51
  circle h+9,60,9,,,,cl(p):text h+10,61,str$(p),"CM",7,,,-1
next

'----------

PW(1)                             ' Screen page 1
text 490,0,"FACTOR FRACTURE",,4   ' Display title
blit 490,5,489,5,150,3            ' Shift a row of pixels to 'fracture' the title

o$="7 5"+chr$(172)+"321 ??????? "+string$(2,175)  ' ASCII characters for each type of object

' Objects stored within a() array:
'
' -7: Factor 7  (opened)
' -6: Empty box (opened)
' -5: Factor 5  (opened)
' -4: Key       (opened)
' -3: Factor 3  (opened)
' -2: Factor 2  (opened)
' -1: Factor 1  (opened)
'  0: Empty space
'  1: Factor 1  (unopened)
'  2: Factor 2  (unopened)
'  3: Factor 3  (unopened)
'  4: Key       (unopened)
'  5: Factor 5  (unopened)
'  6: Empty box (unopened)
'  7: Factor 7  (unopened)
'  8: Wall
'  9: Spawn point (yellow)
' 10: Spawn point (red)
' 11: Fully opened exit 

' Level definitions (pseudo-rando seed for walls & exit; factors & keys; enemy waves [@=0,A=1,etc]) ----------

data 68,"2223333","BCBF",202,"2233377","DLGU",101,"2233557","EIPN",111,"333555","^[OY",15,"12233","XRMA"

' Start of game ----------

li=3  ' Number of lives
f=2   ' Starting factor

for lv=1 to 5       ' Loop through each level

  read s,i$,wv$     ' Read data for level (s = seed for pseudo-random number generator)
  i$="99994444"+i$  ' Add 4 spawn points and 4 keys to the object list
  wv$=wv$+"@"       ' Add 'zero' to the list of enemy waves

  for w=3 to 19                     ' Loop through all enemy sprites
    ch=asc(mid$(wv$,(w+1)\4,1))-64  ' Obtain the 'number' for the enemy from the list of waves
    z(w)=ch                         ' Store the 'number'
    sprite read w,ch*20,51,19,19,2  ' Read the appropriate sprite from the sprite sheet on page 2
  next

  ' Set up and display arena ----------

  ex=R(21)+1      ' Obtain exit point using pseudo-random sequence
  e=0             ' Exit begins as fully closed
  math set 0,a()  ' Reset entire arena array to 0
  math set 0,v()  ' Reset entire visibility array to 0

  for w=0 to 22

    ' Set arena's side walls

    a(w,0)=8
    a(0,w)=8
    a(w,22)=8
    a(22,w)=8

    ' Set arena's inner walls using pseudo-random sequence

    wx=R(21)+1
    wy=R(21)+1

    a(wx,wy)=8
    a(22-wx,wy)=8
    a(wx,22-wy)=8
    a(22-wx,22-wy)=8

  next

  ' Place boxes into the arena (avoiding wall objects already placed), and store their X & Y positions within a separate array

  for w=0 to 34           

    do
      wx=R(21)+1
      wy=R(21)+1
    loop until a(wx,wy)=0

    a(wx,wy)=6

    bx(w)=wx
    by(w)=wy

  next

  ' Place objects into the boxes within the arena, and store spawn points within a separate array

  for l=1 to len(i$)

    do
      w=int(rnd*35)
    loop until a(bx(w),by(w))=6

    a(bx(w),by(w))=val(mid$(i$,l,1))

    j(l-1)=w

  next

  ' Display each square within the arena
  
  for wx=0 to 22
    for wy=0 to 22
      SQ(wx,wy)
    next
  next

  ' Initialise level ----------

  x(1)=PL(11)   ' Player's starting X-coordinate (pixels)
  y(1)=PL(11)   ' Player's starting Y-coordinate (pixels)
  v(1)=1        ' Player is visible
  dx(1)=0       ' Player's change of X-coordinate
  dy(1)=-1      ' Player's change of Y-coordinate
  lx=0          ' Player's last change of X-coordinate
  ly=-1         ' Player's last change of Y-coordinate
  ev=0          ' Zero enemies visible
  ne=3          ' First enemy will be sprite 3
  tm=9E3        ' Time
  tr=t          ' Player transparency time
  ST            ' Show statistics
  PC            ' Update screen from page 1
  PS(3)         ' Pause 3 seconds

  settick 15,SETMV  ' Set interrupt to call routine that will set mv=1 (move sprites)

  ' Main game loop ----------

  do

    if mv=1 then  ' Interrupt triggered

      if tr=t then SND("leval "+str$(lv)):PS(2) ' Start of player transparency: announce level & pause 2 seconds

      tm=tm-(tm>0)  ' Decrement level time (stop at zero)
      tr=tr-(tr>0)  ' Decrement player transparency time (stop at zero)
      fl=fl-(fl>0)  ' Decrement spawn point flashing time (stop at zero)

      ' Read the player sprite from page 2 that corresponds to the last direction of travel, and whether transparent or solid
      sprite read 1,(ly=-1)*19+(lx=1)*38+(ly=1)*57+(lx=-1)*76,(tr>0)*20,19,19,2

      if (keydown(7) and 8)=0 then  ' Left-shift not being pressed
        if v(2)=-1 then v(2)=0      ' Reset visibility flag
      else                          ' Left-shift pressed
        ' Bullet not active & player visible: set starting position, direction of travel & visibility of bullet & make noise
        if v(2)=0 and v(1)=1 then x(2)=x(1)+6:y(2)=y(1)+6:dx(2)=lx:dy(2)=ly:v(2)=1:SND("kk")
      endif

      if (x(1)+y(1)) mod 20=0 then  ' Player is aligned with the arena grid

        gx=x(1)\20  ' Get player's arena grid X-coordinate
        gy=y(1)\20  ' Get player's arena grid Y-coordinate

        ' Get key press (with roll-over)
        
        k1=keydown(1)
        k2=keydown(2)
        k=k1*(k2=0)+k2*(k2<>0)

        ' Set direction of player's travel according to up/down/left/right key press

        dx(1)=(k=131 or k=163)-(k=130)
        dy(1)=(k=129 or k=161)-(k=128)

        if dx(1)<>0 or dy(1)<>0 then lx=dx(1):ly=dy(1)          ' If player is moving the set last direction of travel

        ' Player has collided with enemy and is not transparent: fracture the player sprite, lose a life & make noise
        if CLD(1,1)>2 and tr=0 then FRAC(1):li=li-1:SND("ouch")

        q=a(gx,gy)    ' Store contents of arena grid at player's position

        if q<0 then                       ' Opened box

          if q=-4 then                    ' Key object
            inc e                         ' Increment exit opening
            box PL(22),PL(ex),e*5,19,,0,0 ' Open exit some more (blank out part of the wall)
            SND("unlok")
            if e=4 then a(22,ex)=11:SND("open") ' Exit is fully open: mark the arena square
          elseif q<>-6 then                     ' Not an empty box
            f=-q                          ' Set the current factor
            sc=sc+5                       ' Increase score
            SND(str$(f))                  ' Announce the factor
          endif

          a(gx,gy)=0  ' Set the arena square as empty
          SQ(gx,gy)   ' Redraw the arena square

        endif

      endif


      hx=(x(2)+(dx(2)=1)*6)\20  ' Bullet's arena grid X-coordinate
      hy=(y(2)+(dy(2)=1)*7)\20  ' Bullet's arena grid Y-coordinate

      hs=CLD(2,0)               ' Check whether bullet has collided with an enemy

      if (a(hx,hy)>0 or hs>2) and sprite(X,2)<1E4 then HD(2,2):v(2)=-1

      if a(hx,hy)>0 and a(hx,hy)<8 then a(hx,hy)=-a(hx,hy):SQ(hx,hy):sc=sc+1:SND("nn")

      if hs>2 and z(hs) mod f=0 then
        nz=z(hs)\f
        if f=1 or nz=1 then
          FRAC(hs):ev=ev-1:sc=sc+10:SND("shs")
        else
          sprite read hs,nz*20,51,19,19,2:z(hs)=nz:SND("zz")
        endif
      endif

      if tm=1 then ne=19:SND("getout"):PS(2)

      if tm<10000-ne*300 and ne<19 and ev<8 and fl=0 then fl=100:ee=int(rnd*4)

      if fl>0 then b=j(ee):a(bx(b),by(b))=9+((fl\10) mod 2):SQ(bx(b),by(b))

      if fl=1 or (tm=0 and v(19)=0 and ne=19) then v(ne)=1:inc ev:x(ne)=PL(bx(b)):y(ne)=PL(by(b)):ne=ne+(ne<19)

      ' Loop through all sprites
      for c=1 to 23

        if v(c)>0 then
          sprite show safe c,x(c),y(c),1,,(c=1):gx=x(c)\20:gy=y(c)\20
          if c<>2 and c<=19 and (x(c)+y(c)) mod 20=0 then
            if c<>1 then
              dr=R(6)
              cx=sgn(x(1)-x(c))
              cy=sgn(y(1)-y(c))
              dx(c)=cx*(dr=0 or c=19)+(c<>19)*((dr=1)-(dr=2))
              dy(c)=cy*(dr=3 or c=19)+(c<>19)*((dr=4)-(dr=5))
            endif
            aa=a(gx+dx(c),gy+dy(c))
            if c<>19 and aa>0 and (c<>1 or aa<11) then dx(c)=0:dy(c)=0
          endif

          sp=1+(c=2)*2-(c=19)/1.5+(c>19)
          inc x(c),dx(c)*sp
          inc y(c),dy(c)*sp

          if c>19 and (x(c)<0 or x(c)>450 or y(c)<0 or y(c)>450) then v(c)=0:HD(c,c)

        endif

      next c

      mv=0
      ST
      PC
      if v(1)+v(20)+v(21)+v(22)+v(23)=0 then tr=t:v(1)=1:x(1)=PL(11):y(1)=PL(11)

    endif

  loop until (li=0 and tr=t) or x(1)=PL(22)

  if li=0 then
    SND("gaym owver")
    PS(5)
    lv=9
  else 
    bn=tm\10*(ev=0)
    SND("bownus,"+str$(bn))
    sc=sc+bn
    ST
    PC
  endif

  PS(5)
  HD(1,31)

next

if lv=6 then SND("u,win"):PS(10)

' Functions ----------

function CLD(n,iz):CLD=len(bin$(sprite(T,n) and 2^(18+iz)-1)):end function

function PL(n):PL=n*20:end function

function R(n):s=(1103515245*s+12345) mod 2^31:R=int(s/2^31*n):end function

' Subroutines ----------

sub PC:page copy 1 to 0:end sub

sub PS(n):pause 1E3*n:end sub

sub PW(n):page write n:end sub

sub SETMV:mv=1:end sub

sub SND(t$):play stop:play TTS t$:end sub

sub ST:text u,50,str$(f),,6,2:?@(u,200)"Level:";lv:?@(u,250)"Score:";sc;@(u,300)"Time: ";tm\100;" ";@(u,450)"Lives:";li:end sub

sub SQ(wx,wy)
  sprite hide all
  n=a(wx,wy)
  rbox PL(wx),PL(wy),19,19,1+2*(n=8),map(255)*(n>0 and n<9),map(203*(n>0 and n<8)+136*(n=8))
  text PL(wx)+6,PL(wy)+4,mid$(o$,n+8,1),,,,map(252*(n=9)+224*(n<0 or n=10)),-1
  sprite restore
end sub

sub HD(n,m)
  for fs=n to m
    if sprite(X,fs)<1E4 then sprite hide safe fs
  next
end sub

sub FRAC(sn)
  HD(sn,sn)
  v(sn)=0
  HD(20,23)
  PW(2)
  box 0,90,20,20,,0,0:sprite write sn,0,90
  for fs=20 to 23
    fx=fs mod 2
    fy=fs\22
    dx(fs)=1-(fx=0)*2
    dy(fs)=1-(fy=0)*2
    v(fs)=1
    x(fs)=x(sn)+fx*10
    y(fs)=y(sn)+fy*10
    sprite read fs,fx*10,90+fy*10,10,10
  next
  PW(1)
end sub
