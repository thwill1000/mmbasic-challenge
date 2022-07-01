cls RGB(0,0,0):colour rgb(200,200,0):font 1
?@(100,120)"Sensitivity Alert: Disable in-game flashing title? y/n"
fl=2
do while fl=2
flash=asc(ucase$(inkey$))
select case flash
case 89:fl=0
case 78:fl=1
end select
loop
cls RGB(0,0,0):colour rgb(0,32,0)
?@(50,42)"GROOVY TRIVIA":?@(250,212)"SCIENCE":?@(338,212)"MUSIC":?@(426,212)"MOVIES":?@(514,212)"GENERAL":dim cx=0:dim qt=0:dim p1=0:dim scr_sp=0:dim string cd(50,10)
screenSetup
mc(0)
ldq
dsq
title
do
k=asc(ucase$(inkey$))
select case k
case 131:d=1:mc(d)
case 130:d=2:mc(d)
case 129:d=3:mc(d)
case 128:d=4:mc(d)
case 49:d=5:ca(d)
case 50:d=6:ca(d)
case 51:d=7:ca(d)
case 52:d=8:ca(d)
end select
inkey$=""
if fl=1 then
hl=50:vl=10:for i=0 to 105:for ii=0 to 9
pix=PIXEL (50+i,42+ii)
if pix<>0 then
CIRCLE hl+(i*6.8)),vl+40+(ii*12),10,1,1,rgb(194,23,3):RBOX hl+(i*6.8)),vl+40+(ii*12),1,1,8,rgb(216,rnd*200,rnd*11),rgb(216,rnd*200,rnd*11)
end if
next ii:next i
end if
loop
sub mc(d)
hl=50:vl=185:RBOX hl+(176*cx),vl,170,32,8,rgb(0,0,0):RBOX hl+(176*cx),vl,170,32,10,rgb(0,0,0)
circle 140+(cx*142)+(qt*20),179,5,1,,rgb(black):FONT 4:COLOUR rgb(100,100,0):?@(311,405) string$(18,35)
colour rgb(black):?@(180+(cx*176),187+(qt*10)) chr$(254)
if d=1 then
cx=cx+1
if cx>3 then
cx=0
end if
else if d=2 then
cx=cx-1
if cx<0 then
cx=3
end if
else if d=3 then
qt=qt+1
if qt>1 then
qt=0
end if
else if d=4 then
qt=qt-1
if qt<0 then
qt=1
end if
end if
RBOX hl+(176*cx),vl,170,32,8,rgb(255,255,0):RBOX hl+(176*cx),vl,170,32,10,rgb(255,255,0)
dsq
end sub
sub screenSetup
RBOX 43,225,715,75,,rgb(255,0,0),rgb(0,0,0)
for bd=0 to 18 step 3
rbox 1+(bd*2),1+(bd*2),799-(bd*4),599-(bd*4),10,rgb(255,255-(bd*10),0):rbox 43+(bd*2),396+(bd*2),715-(bd*4),162-(bd*4),10,rgb(255,5,0+(bd*10))
next bd
for i=0 to 1:for ii=0 to 1:rbox 43+(i*360),305+(ii*45),355,40,10,rgb(red),rgb(0,0,0):for iii=0 to 1
box 190+(scr_sp*176),190+(iii*10),20,10,1,rgb(102,102,0):next iii:scr_sp=scr_sp+1:next ii:next i
RBOX 300,396,200,31,,rgb(255,100,0),rgb(0,0,0)
score
categories
end sub
sub score
colour rgb(0,32,0)
RBOX 375,435,340,80,5,rgb(0,0,0),rgb(0,0,0):FONT 1:?@(85,435) "SCORE "+str$(p1,5,0,"0")
hl=90:vl=442
for scri=0 to 88:for scrii=0 to 9:pix=PIXEL (85+scri,435+scrii)
if pix<>0 then
BOX hl+(scri*7),vl+(scrii*7),7,2,1,rgb(255,50+(scrii*10),0),rgb(255,50+(scrii*10),0)
end if
next scrii:next scri
end sub
sub categories
hl=55:vl=190:for i=0 to 400:for ii=0 to 9
pix=PIXEL (250+i,212+ii)
if pix<>0 then
BOX hl+(i*2),vl+(ii*2),2,1,1,rgb(255,50+(ii*10),0),rgb(255,50+(ii*10),0)
end if
next ii:next i
end sub
sub dsq
colour rgb(yellow):FONT 4:lfeed=0:RBOX 43,225,715,75,,rgb(255,0,0),rgb(0,0,0)
?@(50,317) SPACE$(34):?@(410,317) SPACE$(34):?@(50,362) SPACE$(34):?@(410,362) SPACE$(34)
for i=1 to 240 step 61
lfeed=lfeed+1:q_segment$=MID$(cd(((cx*2)+qt),1),i,61):?@(50,220+(lfeed*20)) q_segment$
next i
?@(180+(cx*176),187+(qt*10)) chr$(254):?@(50,317) "1: "+cd((cx*2)+qt,2):?@(410,317) "2: "+cd((cx*2)+qt,3)
?@(50,362) "3: "+cd((cx*2)+qt,4):?@(410,362) "4: "+cd((cx*2)+qt,5)
end sub
sub ca(d)
font 4
if cd((cx*2)+qt,7) <>"" then
COLOUR rgb(orange):?@(310,405)"Already answered!"
exit sub
end if
if cd((cx*2)+qt,6) = str$(d-4) then
cd((cx*2)+qt,7) = "1":p1=p1+100:COLOUR rgb(green):?@(360,405)"Correct!":box 191+(cx*176),191+(qt*10),18,8,1,rgb(green),rgb(green)
else
cd((cx*2)+qt,7) = "0":colour rgb(red):?@(350,405)"Incorrect!":box 191+(cx*176),191+(qt*10),18,8,1,rgb(red),rgb(red)
end if
score
qa=qa+1
if qa=8 then
COLOUR rgb(green):?@(311,405) string$(18,35):colour rgb(yellow):?@(360,405)"Final Score:"
end if
end sub
sub title
hl=50:vl=10:for i=0 to 105:for ii=0 to 9
pix=PIXEL (50+i,42+ii)
if pix<>0 then
CIRCLE hl+(i*6.8)),vl+40+(ii*12),10,1,1,rgb(194,23,3):RBOX hl+(i*6.8)),vl+40+(ii*12),1,1,8,rgb(216,rnd*200,rnd*11),rgb(216,rnd*200,rnd*11)
end if
next ii:next i
end sub
sub ldq
for ii=0 to 7:for iii=0 to 7:READ cd(ii,iii):next iii:next ii
data "1","The Apple II 8-bit home computer was released?","1971","1972","1975","1977","1",""
data "1","The Apollo 13 mission was aborted in April 1970, why?","Propulsiom system out of fuel","Crew member illness","Capsule went off course","Oxygen tank rupture","4",""
data "2","'freedom's just another word for nothin' left to...' Janis Joplin lyric","give","lose","win","chose","2",""
data "2","Who was 'Reelin' in the Years' back in '72?","Status Quo","Steely Dan","Captain and Tennille","Dr Hook","2",""
data "3","In what year was JAWS released?","1973","1975","1977","1979","2",""
data "3","Quote:'I find your lack of faith disturbing.'","The Godfather","The Sting","Star Wars","The Exorcist","3",""
data "4","Most produced car in the world in 1972?","VW Beele","Ford Pinto","Austin Mini","Honda Civic","1",""
data "4","The Sears Tower became the world's tallest building in 1974, where?","Chicago, IL","Trenton, NJ","Madison, WI","Carson City, NV","1",""
end sub
