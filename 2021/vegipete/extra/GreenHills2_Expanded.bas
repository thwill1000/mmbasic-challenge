' Copyright (c) vegipete 2021

' The Continuing Defence of the Green Hills
' by vegipete
'
' Part 2 of the Green Hills Saga
'
' Written to fit on a single page of the CMM2 editor
'
' This program requires a  mouse and uses all three buttons - left, right and wheel.
' Move the mouse for targeting, of course.
'
' If your mouse is connected directly to the CMM2, you will need (and will probably
' already be using) beta firmware 5.07.00bX. If your mouse is connected through a
' Hobbytronics or equivalent, firmware release 5.06.00 should work fine.
'
' The very first statement of the first line sets the mouse port. Adjust this to
' match your system. "mp=0" means use the built-in port available with 5.07.00bX

mp = 0
rd = RGB(RED)
gn = RGB(GREEN)
bl = RGB(BLUE)
yl = rd OR gn
sd = &hF000000

mode 2,12,bl:cls:pause 1000
sh=MM.HRES : sv=MM.VRES
p 1:?@(20,0)"Wave:":?@(60+sh/3,0)"Score:":?@(.7*sh,0)"High Score:":hs=0:shs
controller mouse open mp
gui cursor on 1,0,0,rd
settick 25,MM,1  ' MoveMouse
MAXBOOM = 30
dim m(48,6),u(1) ' player missiles
dim e(100,3)  ' explosions   radius/x/y/delta  player #1-48, ground #50-74, air #75-100
dim a(48,7)   ' enemy shots
dim t(8)      ' ground asset locations
dim v(8)      ' villages (0,4,8) are bases
dim b(2)      ' number of available missiles at each base
dim x(15,1)=(3,3,2,4,1,3,5,0,2,4,6,1,3,5,2,4, 6,0,1,1,2,2,2,3,3,3,3,4,4,4,5,5)
dim vc(5)=(1,2,3,5,6,7)
math scale x(),5,x()
'h$=chr$(165):h$=h$+h$+h$
h$=string$(3,165)
'wv = 0

for i = -4 to 4:t(i+4) = sh*(.5+i/10):next i
?@(0,0) chr$(142)
for i = 1 to 48:sprite read i,2,4,4,4:next
cls

' draw skyline on page 3
p 3 : cls
for i=0 to sh:line i,sv,i,sv-30-r(4)-10*(abs(cos(i*8.0/sh+2.26)))^6,1,gn:next i  ' ground
f 0:f 4:f 8   ' draw bases

p 0
dc
do  ' play game forever
  math set 1,v():wv = 0  ' create all villages at start
  text sh/2,sv*3/4,"Click to play...",CM
  ws
  w=0 ' wave
  s=0 ' score
  done = 0
  do  ' game loop
    es=min(10+w,25)   ' number of enemy shots this wave
    am=26
    w=w+1
    dc
    for i = 1 to 25:nin i,r(sh),0,r(9):next ' create all incoming shots
    for i = 1 to 5:a(11+r(10),0)=1:next   ' create some mirvs in the last 15 incoming shots
    do  ' wave loop
      if timer > 100 then 'ml
        if ml then NextMsl 0
        if mw then NextMsl 1
        if mr then NextMsl 2
      endif

      ' move player missiles
      for i = 1 to 48
        if m(i,0) then
          if m(i,3) or m(i,4) then  ' it's moving
            inc m(i,1),m(i,3)
            inc m(i,2),m(i,4)
            if (abs(m(i,2) - m(i,6)) < 2) and (abs(m(i,1) - m(i,5)) < 2) then
              m(i,0) = 0 ' missile ceases to be
              e(i,0) = 2 : e(i,1) = m(i,1) : e(i,2) = m(i,2) : e(i,3) = .1 : inc en
              m(i,1) = sh-1 : m(i,2) = sv-1
            endif
          endif
        endif
        sprite show i,m(i,1),m(i,2),1
      next i

      ' do explosions
      for i = 1 to 100
        if e(i,0) then
          if e(i,0) > MAXBOOM then e(i,3) = -.1 ' max size so start shrinking
          if e(i,3) < 0 then circle e(i,1),e(i,2),e(i,0),1,1,0,0 ' shrinking so erase old
          if e(i,0) < 2 then    ' shrunk back to min
            e(i,0) = 0
            en=en-(en>0)  'en=max(0,en-1)   ' inc en,-(en<0)
          else
            inc e(i,0),e(i,3)
            circle e(i,1),e(i,2),e(i,0),4,1,yl,rd/e(i,0)OR sd ' draw new
          endif
        endif
      next i

      ' create incoming
      if (an < 10) and (rnd < .0025) and (es>0) then
        inc an  ' number of active shots
        a(es,2)=1   ' activate next shot
        es = es - 1
      endif

      ' draw incoming
      for i = 1 to 48
        if a(i,2) then
          line a(i,1),a(i,2),a(i,5),a(i,6),1,0  ' erase old line
          inc a(i,1),a(i,3)
          inc a(i,2),a(i,4)
          if a(i,2) < sv - 40 then  ' still in the sky
            if pixel(a(i,1),a(i,2)) = yl then  ' destroyed
              ix i+49:a(i,2) = 0
              ss 10
            else
              line a(i,1),a(i,2),a(i,5),a(i,6)  ' still exists so draw new line
              ' MIRV - only in top 1/3 of screen
              if a(i,0)=1 and rnd < .002 and a(i,2) < sv/3 then
                a(i,0)=0  ' mirv event done
                z1 = r(8) : if z1 >= a(i,7) then inc z1  ' don't select same target
                z2 = r(7) : if z2 >= a(i,7) then inc z2  ' don't select same target
                if z1 = z2 then inc z2  ' don't select same target
                nin am,a(i,1),a(i,2),z2
                nin am+1,a(i,1),a(i,2),z1
                am=am+2:an=an+2
              endif
            endif
          else
            'Ground Hit
            ix i+49:a(i,2) = 0
            v1 = 25 : play sound 1,b,n,100,v1
            v(a(i,7))=0  ' city (or base) hit
            if a(i,7) mod 4 = 0 then  ' hit a base so erase unused ammo
              z = a(i,7)\4  ' calc which base
              b(z) = 0      ' ammo gone
              for j = 1 to 16
                if m(j+16*z,4) = 0 then  ' only if not moving
                  m(j+16*z,0) = 0 : m(j+16*z,1) = sh-1 : m(j+16*z,2) = sv-1 ' move them off screen
                endif
              next j
            endif
          endif
        endif
      next i
    loop until es + an + en = 0

    bn = 0  ' bonus
    bp = 200
    d = sh/4
    text sh/2,sv/2-20,"Wave "+str$(w)+" done!",CT
    ?@(60+sh/3,sv/2)"Bonus:"

    for i = 1 to 48   ' loop through and count unused missiles
      if m(i,0) then
        d = d + 8
        bn = bn + 50
        ?@(d,20+sv/2)chr$(142);
        ?@(sh/2,sv/2)bn
        ss 50
        sprite show i,sh-1,sv-1,1
        up
        pause 25
      endif
    next i

    d = sh/4
    wv = 6  ' wrecked villages
    for i = 0 to 5
      if v(vc(i)) then  ' does village still exist?
        wv = wv - 1
        d = d + 40
        bn = bn + 300
        ?@(d,40+sv/2)h$;
        ?@(sh/2,sv/2)bn" "
        ss 300
        up
        pause 75
      endif
    next i

    if bn = 0 then    ' everything is rubble - game over
      text sh/2,sv/2+20,"All is destroyed. Game Over.",CT
      done = 1
    elseif wv then
      text sh/2,sv/2+80,"Bonus! One village rebuilt.",CT
    endif

    pause 4000
  loop until done ' (inkey$ <> "") 'or (e(48,0) > MAXBOOM)
  shs
loop

sub up:play sound 2,b,t,bp,12:bp=bp+50:pause 25:play stop:end sub
sub ss k:p 1:s=s+k:?@(sh/2,0)s:p 0:end sub  ' increment and display score on page 1
sub shs:p 1:hs=max(hs,s):?@(.7*sh+85,0)hs:p 0:end sub  ' display high score on page 1

sub ix k  ' new explosion from incoming
  e(k,0) = 2 : e(k,1) = a(i,1) : e(k,2) = a(i,2) : e(k,3) = .1 : inc en
  an=an-(an>0)  'an=max(0,an-1)
end sub

' k = incoming shot number - array index
' ax,ay = start coordinates
' q = target number
sub nin k,ax,ay,q
      a(k,7) = q   ' target # on the ground
      a(k,6) = ay
      a(k,5) = ax
      u(0) = t(q)-ax 'a(k,5)
      u(1) = sv-40-ay 'a(k,6)
      MATH V_NORMALISE u(),u()
      q = atn(w/20)   ' incoming speed factor based on wave
      a(k,4) = u(1)*q '.1
      a(k,3) = u(0)*q '.1
      a(k,2) = a(k,6)
      a(k,1) = a(k,5)
      a(k,0) = 0    ' no mirv

end sub

sub NextMsl l
  if b(l) then   ' base still has ammo
    v2=25:play sound 2,b,p,100,v2
    k = b(l)+l*16 ' calculate missile number
    inc b(l),-1  'b(l)=b(l)-1  ' same size
    m(k,1) = t(l*4)
    m(k,2) = sv-50
    m(k,5) = mouse(x,mp)
    m(k,6) = min(sv-80,mouse(y,mp))
    u(0) = m(k,5)-m(k,1) : u(1) = m(k,6)-sv+50
    MATH V_NORMALISE u(),u()
    m(k,3) = u(0)*2.5
    m(k,4) = u(1)*2.5
    timer = 0
  endif
end sub

' draw the ground, bases and cities
sub dc
  scl 0   ' scroll existing land away

  math set 0,m()
  for k=1 to 48
    m(k,0)=1:m(k,1)=-16+x(k mod 16,0)+t(4*((k-1)\16)) ' ammo start posn
    m(k,2)=sv-11-x(k mod 16,1)
  next
  math set 16,b() ' b(0)=16:b(1)=16:b(2)=16  ' reload the silos
  math set 0,e()  ' no explosions to start
  if wv then  ' there is at least one wrecked village, so rebuild a single one
    do : k = r(6) : loop until v(vc(k)) = 0   ' find a missing village
    v(vc(k)) = 1  ' rebuild it
  endif

  cls
  p 1:?@(85,0)w
  page copy 3,2
  p 2  ':c 1:c 2:c 3:c 5:c 6:c 7   ' draw villages
  for k = 0 to 5
    if v(vc(k)) then c vc(k) ' draw village if it exists
  next k
  p 0
  scl 2 ' scroll new land up
end sub

sub scl k2  ' k2 = 2 scroll up, k2 = 0 scroll down
  for k = 1 to 51
    blit 0,sv-51,0,sv-50*(k2=0)-k*(k2=2),sh,50,k2    'down, k2 = 0
    pause 20
  next k
end sub

sub p k:page write k:end sub
function r(k):r=int(rnd*k):end function
sub f k:text t(k),sv-52,chr$(150),CT,,,,-1:end sub    ' draw bases
sub c k:text t(k),sv-40,h$,CT:end sub                 ' draw villages

sub MM  'MoveMouse
  gui cursor mouse(x,mp), min(sv-80,mouse(y,mp))
  'L1=mouse(L,mp):m2 ml,L0,L1 'ml=L0 XOR L1 AND L1:L0=L1
  m2 ml,L0,mouse(L,mp) 'ml=L0 XOR L1 AND L1:L0=L1
  m2 mw,W0,mouse(W,mp) 'mw=W0 XOR W1 AND W1:W0=W1
  m2 mr,R0,mouse(R,mp) 'mr=R0 XOR R1 AND R1:R0=R1
  v1 = max(0,v1 - (v1>0)/4) : play sound 1,b,n,100,v1  ' decrease volume of explosion sound
  v2 = v2 - (v2>0) : play sound 2,b,p,100-v2,v2  ' decrease volume of launch sound
end sub
sub m2 a,b,d:a=b XOR d AND d:b=d:end sub ' find rising edges

sub ws  ' show a title screen
  g$="In Renewed Defense of the Green Hills    by vegipete"
  o=0
  do
    for k=1 to 52
      text 50+k*10,sv/4+10*sin((k+o)/4),mid$(g$,k,1),,4,,yl
    next
    o=o+.02
  loop until ml or mw or mr
end sub
