cls:mode 8,8:dim a(22,22),x(23),y(23),z(23),dx(23),dy(23),v(23),bx(34),by(34),j(34),cl(30):t=200:u=520
s=14542:for cn=1 to 30:cl(cn)=rgb(R(5)*32,R(5)*32,R(3)*64):next:PW(2):?chr$(246):sprite read 2,1,2,6,7,2

'Sprites
for l=0 to 20 step 20:box 19,l,19,19,,map(255),map(105)*(l=0):box 22,3+l,13,5,1,map(255),map(116)*(l=0)
for rx=21 to 35 step 2:for ry=10 to 16 step 2:pixel rx,ry+l,map(255):next:next
for p=38 to 76 step 19:for rx=0 to 18:for ry=0 to 18:pixel p+rx,ry+l,pixel(p-19+ry,18-rx+l):next:next:next:next
for p=0 to 30:h=p*20:line h,51,h+18,69:line h,69,h+18,51:circle h+9,60,9,,,,cl(p):text h+10,61,str$(p),"CM",7,,,-1:next

PW(1):text 490,0,"FACTOR FRACTURE",,4:blit 490,5,489,5,150,3:o$="7 5"+chr$(172)+"321 ??????? "+string$(2,175)

'Levels
data 68,"2223333","BCBF",202,"2233377","DLGU",101,"2233557","EIPN",111,"333555","^[OY",15,"12233","XRMA"

li=3:f=2

for lv=1 to 5

read s,i$,wv$:i$="99994444"+i$:wv$=wv$+"@"

for w=3 to 19:ch=asc(mid$(wv$,(w+1)\4,1))-64:z(w)=ch:sprite read w,ch*20,51,19,19,2:next

'Arena
ex=R(21)+1:e=0:math set 0,a():math set 0,v():for w=0 to 22
a(w,0)=8:a(0,w)=8:a(w,22)=8:a(22,w)=8:wx=R(21)+1:wy=R(21)+1:a(wx,wy)=8:a(22-wx,wy)=8:a(wx,22-wy)=8:a(22-wx,22-wy)=8:next
for w=0 to 34:do:wx=R(21)+1:wy=R(21)+1:loop until a(wx,wy)=0:a(wx,wy)=6:bx(w)=wx:by(w)=wy:next
for l=1 to len(i$):do:w=int(rnd*35):loop until a(bx(w),by(w))=6:a(bx(w),by(w))=val(mid$(i$,l,1)):j(l-1)=w:next

for wx=0 to 22:for wy=0 to 22:SQ(wx,wy):next:next

'Init
x(1)=PL(11):y(1)=PL(11):v(1)=1:dx(1)=0:dy(1)=-1:lx=0:ly=-1:ev=0:ne=3:tm=9E3:tr=t:ST:PC:PS(3):settick 15,SETMV

do

if mv=1 then

if tr=t then SND("leval "+str$(lv)):PS(2)
tm=tm-(tm>0):tr=tr-(tr>0):fl=fl-(fl>0)

sprite read 1,(ly=-1)*19+(lx=1)*38+(ly=1)*57+(lx=-1)*76,(tr>0)*20,19,19,2

'Bullet
if (keydown(7) and 8)=0 then
if v(2)=-1 then v(2)=0
else
if v(2)=0 and v(1)=1 then x(2)=x(1)+6:y(2)=y(1)+6:dx(2)=lx:dy(2)=ly:v(2)=1:SND("kk")
endif

'Player
if (x(1)+y(1)) mod 20=0 then
gx=x(1)\20:gy=y(1)\20:k1=keydown(1):k2=keydown(2):k=k1*(k2=0)+k2*(k2<>0)
dx(1)=(k=131 or k=163)-(k=130):dy(1)=(k=129 or k=161)-(k=128)
if dx(1)<>0 or dy(1)<>0 then lx=dx(1):ly=dy(1)
if CLD(1,1)>2 and tr=0 then FRAC(1):li=li-1:SND("ouch")

q=a(gx,gy)
if q<0 then
if q=-4 then
inc e: box PL(22),PL(ex),e*5,19,,0,0:SND("unlok")
if e=4 then a(22,ex)=11:SND("open")
elseif q<>-6 then
f=-q:sc=sc+5:SND(str$(f))
endif
a(gx,gy)=0:SQ(gx,gy)
endif
endif

'Hit
hx=(x(2)+(dx(2)=1)*6)\20:hy=(y(2)+(dy(2)=1)*7)\20:hs=CLD(2,0)
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
if tm<10000-ne*350 and ne<19 and ev<7 and fl=0 then fl=150:ee=int(rnd*4)
if fl>0 then b=j(ee):a(bx(b),by(b))=9+((fl\10) mod 2):SQ(bx(b),by(b))
if fl=1 or (tm=0 and v(19)=0 and ne=19) then v(ne)=1:inc ev:x(ne)=PL(bx(b)):y(ne)=PL(by(b)):ne=ne+(ne<19)

'Move sprites
for c=1 to 23

if v(c)>0 then
sprite show safe c,x(c),y(c),1,,(c=1):gx=x(c)\20:gy=y(c)\20
if c<>2 and c<=19 and (x(c)+y(c)) mod 20=0 then
if c<>1 then
dr=R(6):cx=sgn(x(1)-x(c)):cy=sgn(y(1)-y(c))
dx(c)=cx*(dr=0 or c=19)+(c<>19)*((dr=1)-(dr=2)):dy(c)=cy*(dr=3 or c=19)+(c<>19)*((dr=4)-(dr=5))
endif

aa=a(gx+dx(c),gy+dy(c)):if c<>19 and aa>0 and (c<>1 or aa<11) then dx(c)=0:dy(c)=0

endif

sp=1+(c=2)*2-(c=19)/1.5+(c>19):inc x(c),dx(c)*sp:inc y(c),dy(c)*sp
if c>19 and (x(c)<0 or x(c)>450 or y(c)<0 or y(c)>450) then v(c)=0:HD(c,c)

endif

next c

mv=0:ST:PC:if v(1)+v(20)+v(21)+v(22)+v(23)=0 then tr=t:v(1)=1:x(1)=PL(11):y(1)=PL(11)

endif

loop until (li=0 and tr=t) or x(1)=PL(22)

if li=0 then
SND("gaym owver"):PS(5):lv=9
else 
bn=tm\10*(ev=0):SND("bownus,"+str$(bn)):sc=sc+bn:ST:PC
endif:PS(5):HD(1,31)

next:if lv=6 then SND("u,win"):PS(10)

function CLD(n,iz):CLD=len(bin$(sprite(T,n) and 2^(18+iz)-1)):end function
function PL(n):PL=n*20:end function
function R(n):s=(1103515245*s+12345) mod 2^31:R=int(s/2^31*n):end function
sub PC:page copy 1 to 0:end sub
sub PS(n):pause 1E3*n:end sub
sub PW(n):page write n:end sub
sub SETMV:mv=1:end sub
sub SND(t$):play stop:play TTS t$:end sub
sub ST:text u,50,str$(f),,6,2:?@(u,200)"Level:";lv:?@(u,250)"Score:";sc;@(u,300)"Time: ";tm\100;" ";@(u,450)"Lives:";li:end sub
sub SQ(wx,wy):sprite hide all:n=a(wx,wy)
 rbox PL(wx),PL(wy),19,19,1+2*(n=8),map(255)*(n>0 and n<9),map(203*(n>0 and n<8)+136*(n=8))
 text PL(wx)+6,PL(wy)+4,mid$(o$,n+8,1),,,,map(252*(n=9)+224*(n<0 or n=10)),-1:sprite restore:end sub
sub HD(n,m):for fs=n to m
 if sprite(X,fs)<1E4 then sprite hide safe fs
 next:end sub
sub FRAC(sn):HD(sn,sn):v(sn)=0:HD(20,23):PW(2):box 0,90,20,20,,0,0:sprite write sn,0,90
 for fs=20 to 23:fx=fs mod 2:fy=fs\22:dx(fs)=1-(fx=0)*2:dy(fs)=1-(fy=0)*2:v(fs)=1:x(fs)=x(sn)+fx*10:y(fs)=y(sn)+fy*10
 sprite read fs,fx*10,90+fy*10,10,10:next:PW(1):end sub
