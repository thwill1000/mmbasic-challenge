' SBSGHZ by Vegipete 2022
option angle degrees
option default integer
mode 1,8:cls
B=6E4:BR=5E4:A=360:E=300:F=400:G=200
dim di(20),o(20,6),c(8)=(&hA52A2A,65280,44800,24576,2^14,0,49407,&hFF00C0,&h404040)
dim dw(20),l(18),fv(64),fn(20),ec(20),fc(20),s(G),t(9)
dim float h,fu,ct,st,sd,q(4),v(2,32)
LA "ADHCJDGCIMJBGCJDGBAEEDDDDHAAAHAAA>CAAHADCAAEJJLABCCBDBADACDIFEEEEEEEEEEDDDDD8A8JA8"
LA "JAJ8AJ@S@BS@BSB@SBNTAEFBBFGCCGHDDHEAHGFEIF!!!=A=EA=EAE=AE=I=EI=EIE=IEZANKEEEEEEDDDDEEEEEEBBBBA"
LA "AAAACBBBB<A<FA<FAF<AF?B?CB?CBC?BC>G>DG>DGD>GDAIAUdAEFBBFGCCGHDDHEAHGFEIJKLIMJJMKKMLLMINK!EEEEE"
LA "EGGGGGGGGBBDDDD@A@BA@BAB@AB?M?CM?CMC?MCAM7GMAAMK;MAAQAKALIDDDDEEEDEEEEEEEEBBBBCCCEDA9DAI>AI>A9"
LA "AF:BD@BEJ@EJ@D@AE=AFJU[AEBBECCEDADEFGHIFJKGIHKJGKHPNEEEEEDDDDEEEDEEEEEEEEEEEEEEDDDDCCCCBBBEDA9"
LA "DAJ>AJ>A9ED8EDK=DK=D8AH;BFCBGK@GK@FCAG?AHKPoABCDAEFBBFGCCGHDADHEEIFFIGGIHHIEJKLMJNOKMLONKOL "
u=0:nf=19:RC l()
j=1:do:NB nv:if nv<-32 then exit do
NB nf:RC fn():RC ec():RC fc():for i=0to nv-1:for k=0 to 2:NB w:v(k,i)=w:next k,i
NB k:math scale v(),k,v():NB n:if n then for i=0to n:NB fv(i):next
draw3d create j,nv,nf,1,v(),fn(),fv(),c(),ec(),fc():inc j:loop
for i=1to 8:read o(i,6):next:data 1,1,1,1,4,5,6,7
P 3
cls
circle F,E,21,,4,c(2),c(2):circle F,E,15,,4,0,0:blit read 9,370,E,60,30:circle F,E,30,,,c(3),c(3)
blit write 9,370,E,4:image rotate E,G,G,G,E,G,15:blit read 1,315,268,170,64
h=0:fu=99:sd=99:lv=1:d=0:w=0:np=1
draw3d camera 1,500,0,75
M
settick 25,MM,1
do
if keydown(0)then SK 1:SK 2
if d*keydown(7)then
if np then
np=0
for i=1to 2
if 0=o(i,0)then v2=25:NS i,,,-h:i=3
next
endif
else
np=1
endif
for i=1to 4
if o(i,0)then
inc o(i,0),-sgn(o(i,0))
MB i,7,o(i,4),o(i,5),k
if k>6 then
o(i,0)=-o(i,0)
if k<9 then
v1=75
o(k,1)=B/2
o(k,2)=B/k
o(k,3)=rnd*A
inc se,d
if se>lv*9 and 0=o(6,0)then v4=99:o(6,0)=1
endif
endif
endif
next
inc o(6,3)
h=h+(d=0)/10+A*((h<0)-(h>A))
TY 7:TY 8
if sd<0 then
P
for i=0to 999:line 0,600*rnd,800,600*rnd,,c(0):pause 2:next:text F,E,"GAME OVER",CT,3,,c(0)
pause 4000:d=0:sd=99:NL
endif
DS
if qx+qy then sprite scroll qx,qy:qx=0:qy=0
do:loop until timer>20:timer=0:page copy w+1,0,D:w=w=0
loop
end
sub SK k
k=keydown(k)
if k+d=32 then h=0:lv=1:d=1:se=0:NL
h=h-(k=130)*d+(k=131)*d
k=50*((k=128)-(k=129))
if fu<0 or d*k=0 then exit sub
fu=fu-(fu>0)/G
dx=sin(h)*k
dy=cos(h)*k
MB 0,5,dx,dy,i
if i<6 then
for i=1to 20:C2 o(i,1),-dx:C2 o(i,2),-dy:next
elseif i=6 then
P
for i=1to 999:n=rnd*A:line F,E,F+sin(n)*500,E+cos(n)*500,,c(6):pause 1:next
h=h+G
inc lv
NL
else
v3=2:sd=sd-1
endif
end sub
sub NS n,x,y,h:o(n,0)=90*d:o(n,1)=x:o(n,2)=y:o(n,3)=h:o(n,4)=-sin(h)*151:o(n,5)=cos(h)*151:end sub
sub C2 c,n:c=(c+n+1.5*B)mod B-B/2:end sub
sub MB n,f,dx,dy,r
r=1
x=o(n,1):C2 x,dx
y=o(n,2):C2 y,dy
if n>6 and x^2+y^2<BR then exit sub
for j=f to 20
j=j+(j=n)+(n+4=j)
if (o(j,1)-x)^2+(o(j,2)-y)^2<BR then r=j:exit sub
next
r=0
if n then o(n,1)=x:o(n,2)=y
end sub
sub NL:M:DS:P
for i=1to F:blit F-i,E-i,F-i,E-i,i*2,i*2,w+1:box F-i,E-i,i*2,i*2,8,65535:pause 1/i:next
end sub
sub TY n
if t(n)then inc t(n),-sgn(t(n)):o(n,3)=(o(n,3)+sgn(t(n))*2)mod A:exit sub
j=atan2(o(n,1),-o(n,2)):inc j,A*(j<0):i=(o(n,3)-j)mod A
if i=0 and 0=o(n-4,0)then NS n-4,o(n,1),o(n,2),o(n,3)
j=-sgn(i):if 180<abs(i)then j=-j
o(n,3)=(o(n,3)+j)mod A:MB n,5,-sin(o(n,3))*o(n,4),cos(o(n,3))*o(n,4),j:if j then t(n)=60*sgn(rnd-.5)
end sub
sub M
for i=1to 4:o(i,0)=0:PM i+4:next:o(7,4)=30+2*lv:o(8,4)=15+2*lv
for i=9to 20:PM i:o(i,6)=2+(rnd<.5):next
end sub
sub PM n
o(n,0)=(n<>6)
do:x=rnd*B-B/2:y=rnd*B-B/2:loop while x^2+y^2<BR
o(n,1)=x:o(n,2)=y:o(n,3)=rnd*A
end sub
sub DS
for i=1to 20:dw(i)=o(i,1)^2+o(i,2)^2:next
for i=3to 4
if dw(i)<BR and 0<o(i,0)then o(i,0)=-o(i,0):sd=sd-9*d:qx=rnd*9-5:qy=rnd*9-5:v3=3
next
fu=fu-d*(fu>0)/G
if BR>dw(5)then fu=99:sd=min(99,sd+sr/500):sr=0
sort dw(),di(),1:ct=cos(h):st=sin(h):P w+1:cls:line 0,E,800,E,1,c(3)
if h>240 and h<340 then blit write 1,3100-h*9.6,60
circle 800-h*9.6,G,20,0,,,c(3):circle 791-h*9.6,203,20,0,,,0:circle 1440-h*9.6,120,30,0,,,8453888
n=-h*10 mod 200
for i=0to 5:j=((h-.49)\20+i+15)mod 18:line n,E-l(j)*10,n+G,E-l(j+1)*10,,c(3):n=n+G:next
P 3
box 0,0,102,102,1,c(8),0
for i=1to 20
n=di(i)
if 0<o(n,0)then
P 3:x=o(n,1)*ct-o(n,2)*st:y=o(n,1)*st+o(n,2)*ct
pixel 51+x*140/B,51-y*140/B,c(6*(o(n,6)=5)+(o(n,6)=4)):pixel 51,51,&hFFFF00
if y>150 and y>abs(x)then
P w+1:math q_euler o(n,3)+h,0,0,q():draw3d rotate q(),o(n,6):draw3d write o(n,6),x,0,y
endif
endif
next
P w+1
blit 0,0,369,497,102,102,3:box 369,497,102,102,1,c(8)
text F,6,"LEVEL:"+str$(lv,2)+"  SCORE:"+str$(se,3),CT,,,c(1)
text F,495,"S F  HEADING: "+str$(h,3,0),CB,,,c(1)
DG 331,sd:DG 346,fu:if d=0 then text F,G,"SPACE to Play",CB,3,,c(1),-1
end sub
sub P n:page write n:end sub
sub DG x,g:box x,497,10,102,1,c(8),0:g=max(g,0):box x+1,598-g,8,g,4,c(g>25):end sub
sub RC c():NB k:if k<>-32 then c(0)=k:for i=1to nf-1:NB c(i):next
end sub:sub NB w:w=lgetbyte(s(),u)-65:inc u:end sub
sub LA z$:longstring append s(),z$:end sub
sub MM
play sound 1,b,n,99,v1/3:DE v1
play sound 2,b,p,99-v2,v2:DE v2
play sound 3,b,n,G,20*(v3<>0):DE v3
play sound 4,b,t,499-99*sin(v4),v4/4:DE v4
inc sr
end sub
sub DE n:n=n-(n>0):end sub