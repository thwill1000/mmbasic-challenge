'Resistors - for CMM2 - 2021 competition entry - by Mixtel90 - Any accuracy is accidental. :)
cls:dim c(12),rv(6):bp=1::?@(40,85)"<-B":?@(320,85)"N->":dim ti(10) =(1,2,0,0,.5,.25,.1,.05,0,5,10)
c(0)=rgb(black):c(1)=rgb(brown):c(2)=rgb(red):c(3)=rgb(255,100,0):c(4)=rgb(yellow):c(5)=rgb(green)
c(6)=rgb(blue):c(7)=rgb(magenta):c(8)=rgb(grey):c(9)=rgb(white):c(10)=rgb(gold):c(11)=rgb(lightgray)
do'+++++++++ Main Prog Loop Start +++++++++++++
box 60,105,260,80:line 60,145,40,145:line 320,145,340,145 'Draw resistor
box 74,105,25,80,,,c(rv(1)):box 117,105,25,80,,,c(rv(2)):box 161,105,25,80,,,c(rv(3))
box 202,105,25,80,,,c(rv(4)):box 286,105,25,80,,,c(rv(6)) 'Draw the coloured bands on it
for x=1 to 6:a=20+x*44:text a,200," 0 ",,2,1,,c(0):text a,220," 1 ",,2,1,,c(1)
text a,240," 2 ",,2,1,,c(2):text a,260," 3 ",,2,1,c(0),c(3):text a,280," 4 ",,2,1,c(0),c(4)
text a,300," 5 ",,2,1,c(0),c(5):text a,320," 6 ",,2,1,,c(6):text a,340," 7 ",,2,1,c(0),c(7)
text a,360," 8 ",,2,1,,c(8):text a,380," 9 ",,2,1,c(0),c(9)
if x>2 then text a,400,"Gld",,2,1,c(0),c(10):if x>2 then text a,420,"Slv",,2,1,c(0),c(11)
next:box 233,197,43,250,,c(0),c(0) 'The loop draws the colour columns, the box deletes column 5
arrow bp  'Draw the band indicating arrow   | ^ messy & flashes screen, but keeps space down ^
do:a=instr("0123456789gsbn",inkey$):loop until a>0 or f1=0 'Get control key. Pass through initially.
f1=1:t=0:select case a-1:case 12:bp=bp-(bp>1):bp=bp-(bp=5):case 13:bp=bp+(bp<6):bp=bp+(bp=5)
case 0 to 9:rv(bp)=a-1:if bp=6 and a>1 then t=ti(a-2) 'band 6 looks up tolerance array ti() 0-9
case 10,11:if bp>2 then rv(bp)=a-1:if bp=6 and a>1then t=ti(a-2) 'tolerance array gold & silver
end select
if rv(4)=0 then  'Sort out the hundreds, tens & multiplier band for 3-band values
 if rv(3)=10 then a=-1 else a=rv(3)
 if rv(3)=11 then a=-2
 v=(rv(1)*10+rv(2))*10^a
else             'Sort out the hundreds, tens, units & multiplier band for 4-band values
 if rv(4)=10 then a=-1 else a=rv(4)
 if rv(4)=11 then a=-2
 v=(rv(1)*100+rv(2)*10+rv(3))*10^a
end if
L1=v-(v/100):h1=v+(v/100):L5=v-(v*5/100):h5=v+(v*5/100):L10=v-(v*10/100):h10=v+(v*10/100)'tolerances
?@(400,100)"Marked Value "r$(v)"         "
?@(400,140)"1% band from "r$(L1)" lower to "r$(h1)" upper        "
?@(400,170)"5% bands from "r$(L5)" lower to "r$(L1)" upper      "
?@(470,190)"and "r$(h1)" lower to "r$(h5)" upper        "
?@(400,220)"10% bands from "r$(L10)" lower to "r$(L5)" upper      "
?@(470,240)"and "r$(h5)" lower to "r$(h10)" upper
if t>0 then ?@(400,270)"Marked tolerance is +/-"t"%       " else box 400,270,300,12,,c(0),c(0)
loop'++++++++ Main Prog Loop End ++++++++++++++
function r$(value) 'Display value as ohms, k or M
if value>=1000000 then r$=str$(value/1000000)+"M":exit function
if value>=1000 then r$=str$(value/1000)+"k":exit function
r$=str$(value)+chr$(234)
end function
sub arrow(x) 'Draw the band indicating arrow at position x, deleting the old position first 
static x1:local s1,s2:s1=46+x1*43:s2=46+x*43
line s1,80,s1,100,,c(0):line s1,100,40+x1*43,90,,c(0):line s1,100,52+x1*43,90,,c(0):x1=x
line s2,80,s2,100:line s2,100,40+x*43,90:line s2,100,52+x*43,90
end sub
