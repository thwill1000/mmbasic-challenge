'   In Defense of the Green Hills of Earth  v1.1              by vegipete, Feb 2021
' Use left and right arrow keys, and either Ctrl key.
'
' Written for the "Colour Maximite 1 & 2 BASIC Programming Challenge 2021"
' Check the forum at <https://www.thebackshed.com/forum/ViewForum.php?FID=16> for more info.

' Decompressed version - somewhat easier to comprehend
' Program flow-wise, this version should be identical to the compressed version.
' Only the formatting has been changed. Most, but not all, colons (:) have been
' replaced with [NewLines]. No statements have been moved, added, removed or altered.
' A single "ENDIF" statement at the end of the 'af' subroutine has been commented out
' as it appears to be unnecessary.
' Fully compressed and decommented, this program fits in 44 lines of code
' - one CMM2 editor page in default mode 1.
'
'=========
' An important concept in the code is that all elements exist more or less all the time.
' Elements are 'drawn' off screen when not needed, destroyed or whatever. For example, the
' boss alien that flies across the top of the screen is always there somewhere, just most
' of the time he is not visible. When the player destroys him on screen, he merely gets
' shifted out of view and continues on his merry way, eventually to turn around and reappear
' in the fullness of time. Likewise, enemies and enemy shots are drawn off screen when
' destroyed or spent. Player shots are always on screen, but drawn in black near the top
' when inactive.
'
'=========
' Much of the collision detection in this program is performed by reading the colour of the
' pixel that something could be about to collide with. Thus the colour determines if the
' object is hitable or not. For example, alien shots can only hit green or cyan targets.
' Thus, alien shots pass harmlessly through aliens, as they are white.
'
'=========
' This program uses interrupts. A challenge with interrupts is called 'race conditions', in
' which different sections of code use the same information in a way that could interfere with
' each other. An example below is in the player ShotErase (se) subroutine potentially
' fighting with the PlayerShot (ps) ISR. If the interrupt routine happens at just the right
' moment and changes the value of a variable, the ShotErase rountine can end up erasing in
' the wrong location. This can leave an un-erased player shot on screen. If an alien shot
' hits this left over player shot, the player can be killed, even if he is somewhere else.
' A bandaid cure would be to change the colour of the player shot, perhaps to yellow.
'
'=========
' This program uses extensive use of conditional math the significantly reduce the
' number of IF statements. For a simple example, consider the following:
'   IF delta = 1 THEN
'     delta = 0
'   ELSE
'     delta = 1
'   ENDIF
'
' This toggles the value of delta between 0 and 1 each time through.
' The same can be done with:
'   delta = delta = 0
'
' One line instead of 5, but more importantly, there is no branching of flow control,
' meaning that more statements can be tacked on with a colon. As a bonus, it's also faster!
'
' Here's a trickier one from the KeyPress ISR:
'   p=p+1*((k=131)*(p<288)-(k=130)*(p>-16))
'
' Egads!
' Let's take it apart:
'   (k is the ascii of a possible pressed key, it could be zero too)
'   (p is the player position)
' The equivalent is:
'   IF (k = 131) AND (p < 288) THEN
'     p = p + 1
'   ELSEIF (k = 130) AND (p > -16) THEN
'     p = p - 1
'   ENDIF
'
' Piecewise, "(k=131)" has the value 1 if k equals 131 and the value 0 for all other k
' Likewise, "(p<288)" is one if p is less than 288, 0 if greater than or equal
' So, "(k=131)*(p<288)" equals 1 if both conditions are true or 0 otherwise.
' Similarly, "(k=130)*(p>-16)" equals 1 only if k=130 and p >-16
' By subtracting the second one, the result is +1 if the first one is true and -1 if
' the second is true. Furthermore, they cannot both be true, so the result cannot be 0.
' This also shows some unnecessary code - the 1*(result) serves no purpose! Oops!
' Instead, this statement should be: "p=p+(k=131)*(p<288)-(k=130)*(p>-16)"
' p is incremented only if the first part is true and decremented if the latter is true.
'
' Variables used: (I think I got them all)
'ax()   alien formation
'ay()   alien formation
'a
'b      blue colour
'bd     boss alien direction
'bx     boss x coord
'c      AlienFire ISR - colour of pixel to draw 1=black,0=blue
'c1     alien shot pixel parameter
'd      colour hit by player shot, temp
'e      number of aliens
'ex,ey  alien explosion location for later erase
'f
'f1     player fire delay
'f2     boss explosion display duration
'fx     boss explosion x coord
'g      green colour
'h      horizontal index of hit alien, sub: horz shield posn
'hs     high score
'i      main loop variable, temp
'j      main loop variable
'k      ISR keypress
'l      level
'lf     player lives left
'm()    alien formation offset
'n      max number of alien shots
'nf     alien inter-shot delay
'nl     next extra life in 10000's
'nn     number of inactive alien shots (20 = no shots on screen)
'nx()   alien shots
'ny()   alien shots
'o      alien animation cycle
'p      player x coordinate
'q
'r      red colour
'rg     yellow colour
'rn     random function  =int(rnd*<param>)
's      player shot y coordinate
'sc     score
'ss     save player shot y-coord in case ISR messes us up
't      player shot x coordinate
'u      alien formation left limit
'v      alien formation right limit
'w      draw shield subroutine
'ww     white colour
'x      x coord of alien formation
'y      y coord of alien formation
'yd     alien formation downward step size
'z      alien formation side shift direction
'
'kp     ISR 1: 20ms Keypress left and right, timing, draw player, off when dead
'ps     ISR 2:  5ms Player shot, advance up screen
'am     ISR 3: variable ms Alien Move
'af     ISR 4: 40ms Alien Fire, Boss move

mode 3,12

n=20  ' max number of alien shots

' Array m holds point value of aliens in each row of formation. The use of 10 elements
' appears to be a relic from previous versions and should likely be reduced to 5.
dim ax(54),ay(54),m(9)=(0,1,0,1,2,3,2,3,4,5),ny(n),nx(n)
ey=210    ' alien explosion off screen so it isn't visible
l=0       ' level 0 - maybe unnecessary
nf=200    ' no alien shot for a while
tt=10000  ' extra life every 10000 points
dim sf(7)=(0,1,1,0,0,-1,-1,0)   ' alien shot wiggle amounts left/right

r=268369920   ' colour red (&hFFF0000) - same as RGB(RED), but more obfuscated!
g=251723520   ' green (&hF00FF00)
b=251658495   ' blue  (&hF0000FF)   note high bits are set to prevent transparency
rg=r or g     ' yellow - can't add them! must OR the bits
gb=g or b     ' cyan
ww=rg or b    ' white

bx=-400       ' boss starting location - far to the left off screen
bd=1.5        ' boss movement speed
yd=3          ' alien formation distance to advance down screen - maybe unnecessary
settick 4,ps,2    ' start player shot ISR
settick 1000,am,3 ' start alien formation movement ISR
math set 210,ny() ' start all alien shots off screen -> ie they don't exist
settick 35,af,4   ' start alien fire ISR

pause 500

Page write 1
box-1,9,322,191,,b  ' draw top and bottom borders on page 1 so they are always visible
page write 0

do    ' play game for ever - there is no quitting!
  yd=0    ' no alien formation advance for now
  text 90,26,"Press a key to start...",,,,rg  ' colour yellow
  do while inkey$<>"" : loop    ' wait for keys to be released
  do : loop until inkey$<>""    ' wait for key to be pressed
  settick 20,kp,1   ' start keyboard ISR

  lf=2    ' two spare lives to start
  l=0     ' level 0
  yd=3    ' alien formation advance distance when changing direction at edge of screen
  sc=0    ' score
  nl=1    ' next life at score 1 * tt (=10000)
  p=150   ' player starting x-posn

  do
    cls   ' start with clear screen
    x=70  ' alien formation start x-coord
    y=min(170,94+5*l) ' start y-coord, based on level
    u=2   ' initial travel limit left
    v=142 ' initial travel limit right

    for i=0 to 54   ' set relative coordinate of each alien in formation
      ax(i)=(i mod 11)*16   ' 16 pixel horizontal spacing
      ay(i)=(i\11)*15       ' 15 pixel vertical spacing
    next

    e=55    ' all 55 enemies to start
    sp(0)   ' display starting score (add 0 and show score)
    sh      ' show high score
    O=1     ' alien animation frame 1
    nf=499  ' no alien fire for a while
    l=l+1   ' advance to first/next level
    z=2     ' alien formation starts shifting to the right
    w(40):w(110):w(180):w(250)  ' draw the green shields
    sl      ' show remaining lives

    do ' game loop
      if y>math(min ay())+176 then go:exit do   ' aliens formation has landed. We're all dead :(

      ' CTRL pressed - create a new shot of there is none and hasn't been one for a while
      if (keydown(7)and 34)<>0 and(s<10)and(f1=0)then s=184:t=p+24:play tone 500,500,20:f1=10

      ' test each alien shot for hitting something
      for i=1 to n
        d=2*(abs(t-nx(i))<3 and abs(s-ny(i))<3) ' set d if alien shot is near player shot
        nx(i)=nx(i)*(1-d)   ' cancel alien shot - make x-coord negative to flag ISR to erase
        if d then se        ' cancel player shot - erase it

        if pixel(nx(i),ny(i))=gb then   ' hit something cyan -> must be player ship
          settick 0,kp,1    ' stop keyboard ISR - player can't move
          yd=0    ' stop alien formation advance
          text p+13,189,"Boom"  ' replace player ship with 'explosion'
          play stop   ' stop possible sound
          for j=1 to 25:play sound 1,b,n,100,26-j:pause 50:next j ' crate explosion sound
          play stop   ' stop sound
          text p-16,186,".....",,8  ' erase explosion
          lf=lf-1   ' alas, another life gone, lost to the waste of alien planetary conquest
          if lf<0 then go:exit do ' all lives lost! Jump out of loop  ' Confused yet?
          yd=3      ' restart alien advance
          ws        ' wait for alien shots to finish falling
          sl        ' show remaining lives
          text p-16,186,"..H..",,8,,gb  ' draw new player ship, erasing any left over "BOOM"
          settick 20,kp,1   ' restart keyboard ISR - player can move again
        endif
      next

      d=pixel(t,s-1)  ' get colour of pixel just in front of player shot

      ' slight bug: in the following tests, I think 's' should be replaced with 's>9'
      if s and d=g then   ' does player shot exist and has it hit green shield?
        line t-1,s+6,t-1,s-4,3,0  ' erase a chunk of shield
        s=9   ' cancel shot

      elseif s and d=ww and s<26 then ' has player shot hit WHITE in the zone of the boss?
        pt=50*int(1+rnd*3)  ' random points of 50,100 or 150
        fx=bx   ' snatch location of boss
        se      ' erase shot
        bx=bd*240   ' move boss far in the direction he was going
        text fx+16,17,str$(pt)+" ",,,,r   ' replace boss glyph with red point value
        sp(pt)    ' add point value of boss and disaply it
        f2=25     ' display boss 'explosion' - point value for a while

      elseif s and d=ww and s>y-58 then ' hit WHITE in the alien formation zone?
        i=(y-s+15)\15   ' calculate y-index of alien hit  (0 - 4)
        h=(t-x)\16      ' calculate x-index of alien hit  (0 - 11)
        ax(i*11+h)=-400 ' hide alien by moving it off screen
        ay(i*11+h)=80   ' shift it far up for locating bottom of formation
        text ex,ey,"'",,8 ' erase possible previous alien explosion
        ex=x+h*16   ' store x- and
        ey=y-i*15   '    y-coordinates of alien axplosion, for later erasing
        text ex,ey,"@",,8,,rg   ' show alien splat glyph
        sp(10+5*m(i*2))   ' add score based on position in formation - relic? *2?
        se            ' erase player shot
        e=e-1         ' one less alien
        if e=0 then exit do   ' Yah, got them all! Exit for next wave

        ' some trickery to find the left most active alien, given that INACTIVE ones are at -400
        d=abs(ax(0))    ' assume 1st one is left most to start - need ABS to ignore inactive ones
        for i=1 to 54   ' loop through all the rest to compare
          d=min(d,abs(ax(i))) ' select farther left of the 2
        next    ' would be easy if MATH(MIN ABS(ax())) were legal
        u=2-d   ' calculate new left travel limit
        v=302-math(max ax())  ' right travel limit is far easier
      endif

      if nf=0 then    ' time to add another alien shot yet? (Gets decremented by ISR ps)
        nf=int(20+10*rnd+10*e)  ' set delay to next shot rondomly and depending on # remaining
        d=int(rnd*11)   ' pick random possible alien to shoot - may not be alive so...
        do while ay(d)>60 ' scan through live aliens to select who fires
          d=(d+7)mod 55   ' an increment of 7 will visit every possible alien
        loop          ' d holds number of alien that fires

        for i=1 to n  ' find an empty firing slot and fill in the details
          if ny(i) > 210 then nx(i)=8+x+ax(d):ny(i)=y-ay(d)+12:exit for ' found one, stop looking
        next  ' falls out the bottom with no new shot if all slots are full
      endif
    loop ' game loop
    if e then exit do   ' out of game loop with some aliens still alive = DEATH!

    ' Why must "ws" appear twice on the next line? Firmware bug? (Note only when compressed)
    ws:ws  ' wait for alien shots to finish falling
  loop
loop

' Score Player - increase and disply score by requested amount, test for extra life
sub sp(q)
  sc=sc+q     ' increment score
  ?@(0,1)sc   ' display it
  lf=lf+((sc\tt)=nl)  ' add another life if score exceeds threshold  (tt)
  nl=nl+((sc\tt)=nl)  ' advanve threshold if required
  sl
end sub

' Wall - display green shield at requested x-location
sub w(h)
  text h,160,"KL",,8,,g
  text h,172,"IJ",,8,,g
end sub

' Show Highscore
sub sh
  ?@(75,1)"High Score"hs
end sub

' Show Lives
sub sl
  for j=1 to 5  ' fit up to 5 spare ships
    text 330-16*j,0,chr$(77+(lf<j)),"R",8   ' display spare ship or blank
  next
end sub

' Wait Shot - wait for all alien shots to expire
sub ws
  do
  loop until nn=n
end sub

' Shot Erase - erase player shot
' slight bug: shot x-coord race condition with ISR
sub se
  ss=s  ' save shot y-coord
  s=9   ' end shot
  line t,ss-1,t,ss+6,,0   ' erase it
end sub

' ISR: Key Press - read arrow keys, move and draw player ship
sub kp
  k=keydown(1)  ' grab key press
  ' increment position if right arrow pressed and not at right limit
  ' decrement position if left arrow pressed and not at left limit (which is off screen)
  p=p+1*((k=131)*(p<288)-(k=130)*(p>-16))
  text p,186,".H.",,8,,gb   ' draw ship in cyan, blank left and right to erase previous
  f1=f1-(f1>0)  ' decrement player shot delay
end sub

' ISR: Player Shot
sub ps
  s=s-(s>9)   ' move shot up screen, stops at y-coord = 9
  line t,s,t,s+6,,(s>9)*gb  ' draw shot, use cyan if on screen, black if stopped at top
  pixel t,s+7,0   ' erase bottom pixel
  nf=nf-(nf>0)  ' decrement alien shot delay if not zero
end sub

' ISR: Alien Move
sub am
  text ex,ey,"'",,8   ' erase possible exploded alien
  ey=210            ' position alien explosion off screen
  if e then   ' any aliens to move? - maybe not strictly needed
    x=x+z     ' shift alien formation sideways
    settick 10+e*6,am,3   ' adjust alien move speed
    if x<u or x>v then z=-z : y=y+yd  ' hit limit left or right so move down and change direction
    O=O=0   ' alien animation cycle offset
    for i2=0 to 54  ' loop through and draw all aliens
      text x+ax(i2),y-ay(i2),chr$(65+O+m(i2\11*2)),,8   ' dead aliens are drawn off screen
    next
  endif
end sub

' ISR: Alien Fire - move and animate alien shots, move alien boss
' There is some crazy stuff in this subroutine - hang on!
sub af
  math add ny(),1,ny()
  nn=0
  for j1=1 to n   ' cycle through each possible alien shot
    ' The next one is tricky: if the alien shot hits green or is -ve x then draw it black.
    ' A shot is moved to negative x to indicate is gone, but must still be erased
    c=(pixel(nx(j1),ny(j1)-6)=g) + (nx(j1)<0)

    for j2=0 to 7   ' cycle through the 8 vertical pixels of an alien shot
      j3 = abs(nx(j1))+sf((ny(j1)+8-j2)mod 8) ' calculate pixel wiggle
      px(0)   ' draw single pixel
      if c then px(-1):px(1)  ' black shot so erase left and right a bit too for bigger hit
    next j2

    ny(j1)=ny(j1)+120*c   ' if shot is finished, move it off bottom of screen
    nn=nn+(ny(j1)>210)    ' count number of finished shots
  next j1

  f2=f2-1  ' boss explosion duraton ' Great Scott! What a disaster!
  bx=bx+bd  ' shift boss sideways
  text bx,13,"/G\",,8   ' display boss
  ' if boss hits limit of travel (far off screen) then randomly pick a new direction and
  '   reposition boss randomly far off for slightly irregular re-appearance
  if abs(bx)>450 then br=1-2*cint(rnd) : bd=-1.5*br : bx=br*(400+rnd*200)

  if f2=1 then text fx,13,"\_/",,8  ' erase boss 'explosion' -> point value
  ':endif: - only needed for compressed version
end sub

' Draw alien shot pixel
' Draw the pixel in blue unless:
'   1) shot has hit green shield   -or-
'   2) shot has been destroyed/consumed/ended by moving it to negative x - needed to erase shot
'   3) top pixel of shot - draw in black to erase top of shot as it moves down screen
sub px(c1)
  pixel j3+c1,ny(j1)-j2,b*(j2<>7)*(c=0)
end sub

DefineFont #8   ' glyphs
  0E400C10
  00000000 00000000 90094812 0C302004 90092004 00004812 00000000 00000000
  F81FC003 9C39FC3F 700EFC3F 300C9819 00000000 00000000 F81FC003 9C39FC3F
  700EFC3F 0C309819 00000000 00000000 20021004 D80DF007 F417FC1F 60031414
  00000000 00000000 24121004 DC1DF417 F007F80F 08081004 00000000 00000000
  E001C000 D806F003 2001F807 2805D002 00000000 00000000 E001C000 D806F003
  1002F807 10020804 00000000 00000000 F81FE007 B66DFC3F 9C39FFFF 00000810
  00000000 80008000 C001C001 FF7FFE3F FF7FFF7F 0000FF7F FF0FFF0F FF0FFF0F
  FF0FFF0F FF0FFF0F E00FF00F C00FC00F F0FFF0FF F0FFF0FF F0FFF0FF F0FFF0FF
  F007F00F F003F003 00000000 00000000 00000000 00000000 FF01FF00 FF07FF03
  00000000 00000000 00000000 00000000 80FF00FF E0FFC0FF 00010000 F01F0001
  F83FF83F 0000F83F 00000000 00000000
END DefineFont

' Game over message, record possible new high score
sub go
  pause 500
  hs=max(hs,sc)
  sh:play tts "game over"
  ws
end sub
