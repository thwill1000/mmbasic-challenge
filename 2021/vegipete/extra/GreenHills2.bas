mp=0:sd=&hF000000:rd=RGB(RED):gn=&hF00FF00:bl=RGB(BLUE):yl=rd OR gn:mode 2,12,bl:cls:pause 999:hs=0
sh=MM.HRES:sv=MM.VRES:p 1:?@(20,0)"Wave:":controller mouse open mp:sub c k:text t(k),sv-40,h$,CT
end sub:?@(60+sh/3,0)"Score:":?@(.7*sh,0)"High Score:":dh:gui cursor on 1,0,0,rd:settick 25,MM,1
dim x(15,1)=(3,3,2,4,1,3,5,0,2,4,6,1,3,5,2,4,6,0,1,1,2,2,2,3,3,3,3,4,4,4,5,5),vc(5)=(1,2,3,5,6,7)
math scale x(),5,x():dim m(48,6),u(1),e(100,3),a(48,7),t(8),v(8),b(2):h$=string$(3,165)
for i=-4 to 4:t(i+4)=sh*(.5+i/10):next:?@(0,0)chr$(142):for i=1 to 48:sprite read i,2,4,4,4:next:cls
p 3:cls:for i=0 to sh:line i,sv,i,sv-30-r(4)-10*(abs(cos(i*8.0/sh+2.26)))^6,1,gn:next:f 0:f 4:f 8
p 0:dc:do:math set 1,v():wv=0:text sh/2,sv*3/4,"Click to play...",CM:ws:w=0:s=0:done=0:do:am=26
es=min(10+w,25):w=w+1:dc:for i=1 to 25:nin i,r(sh),0,r(9):next:for i=1 to 5:a(11+r(10),0)=1:next:do
if timer>100 then:if ml then:NM 0:endif:if mw then:NM 1:endif:if mr then:NM 2:endif:endif
for i=1 to 48:if m(i,0)then:if m(i,3)or m(i,4)then:inc m(i,1),m(i,3):inc m(i,2),m(i,4)
if (abs(m(i,2)-m(i,6))<2)and(abs(m(i,1)-m(i,5))<2)then:m(i,0)=0:e(i,0)=2:e(i,1)= m(i,1):inc en
e(i,2)=m(i,2):e(i,3)=.1:m(i,1)=sh-1:m(i,2)=sv-1:endif:endif:endif:sprite show i,m(i,1),m(i,2),1
next:for i=1 to 100:if e(i,0)then:if e(i,0)>30 then:e(i,3)=-.1:endif:sub p k:page write k:end sub
if e(i,3)<0 then:circle e(i,1),e(i,2),e(i,0),1,1,0,0:endif:if e(i,0)<2 then:e(i,0)=0:en=en-(en>0)
else:inc e(i,0),e(i,3):circle e(i,1),e(i,2),e(i,0),4,1,yl,rd/e(i,0)OR sd:endif:endif:next
if( an<10)and(rnd<.0025)and(es>0)then:inc an:a(es,2)=1:es=es-1:endif:for i=1 to 48:if a(i,2)then
line a(i,1),a(i,2),a(i,5),a(i,6),1,0:inc a(i,1),a(i,3):inc a(i,2),a(i,4):if a(i,2)<sv-40 then
if pixel(a(i,1),a(i,2))=yl then:ix i+49:a(i,2)=0:ss 10:else:line a(i,1),a(i,2),a(i,5),a(i,6)
if a(i,0)=1 and rnd<.002 and a(i,2)<sv/3 then:a(i,0)=0:z1=r(8):if z1>=a(i,7)then:inc z1:endif
z2=r(7):if z2>=a(i,7)then:inc z2:endif:if z1=z2 then:inc z2:endif:nin am,a(i,1),a(i,2),z2
nin am+1,a(i,1),a(i,2),z1:am=am+2:an=an+2:endif:endif:else:ix i+49:a(i,2)=0:v1=25:v(a(i,7))=0
play sound 1,b,n,100,v1:if a(i,7)mod 4=0 then:z=a(i,7)\4:b(z)=0:for j=1 to 16:if m(j+16*z,4)=0 then
m(j+16*z,0)=0:m(j+16*z,1)=sh-1:m(j+16*z,2)=sv-1:endif:next j:endif:endif:endif:next i
loop until es+an+en=0:bn=0:bp=200:d=sh/4:text sh/2,sv/2-20,"Wave "+str$(w)+" done!",CT
?@(60+sh/3,sv/2)"Bonus:":for i=1 to 48:if m(i,0)then:d=d+8:bn=bn+50:?@(d,20+sv/2)chr$(142):ss 50
?@(sh/2,sv/2)bn:sprite show i,sh-1,sv-1,1:up:pause 5:endif:next:d=sh/4:wv=6:for i=0 to 5
if v(vc(i))then:wv=wv-1:d=d+40:bn=bn+300:?@(d,40+sv/2)h$:?@(sh/2,sv/2)bn" ":ss 300:up:pause 55
endif:next:if bn=0 then:text sh/2,sv/2+20,"All is destroyed. Game Over.",CT,4,,rd:dh:done=1
elseif wv then:text sh/2,sv/2+80,"Bonus! One village rebuilt.",CT:endif:pause 4000:loop until done
loop:sub ix k:e(k,0)=2:e(k,1)=a(i,1):e(k,2)=a(i,2):e(k,3)=.1:inc en:an=an-(an>0):end sub:sub ss k
p 1:s=s+k:?@(sh/2,0)s:p 0:end sub:sub dh:p 1:hs=max(hs,s):?@(.7*sh+85,0)hs:p 0:end sub:sub scl k2
for k=1 to 51:blit 0,sv-51,0,sv-50*(k2=0)-k*(k2=2),sh,50,k2:pause 20:next:end sub:sub nin k,ax,ay,q
a(k,7)=q:a(k,6)=ay:a(k,5)=ax:u(0)=t(q)-ax:u(1)=sv-40-ay:MATH V_NORMALISE u(),u():q=atn(w/20)
a(k,4)=u(1)*q:a(k,3)=u(0)*q:a(k,2)=a(k,6):a(k,1)=a(k,5):a(k,0)=0:end sub:sub NM l:if b(l) then
v2=25:play sound 2,b,p,100,v2:k=b(l)+l*16:inc b(l),-1:m(k,1)=t(l*4):m(k,2)=sv-50:m(k,5)=mouse(x,mp)
m(k,6)=min(sv-80,mouse(y,mp)):u(0)=m(k,5)-m(k,1):u(1)=m(k,6)-sv+50:MATH V_NORMALISE u(),u()
m(k,3)=u(0)*2.5:m(k,4)=u(1)*2.5:timer=0:endif:end sub:sub dc:scl 0:math set 0,m():for k=1 to 48
m(k,0)=1:m(k,1)=-16+x(k mod 16,0)+t(4*((k-1)\16)):m(k,2)=sv-11-x(k mod 16,1):next:math set 16,b()
math set 0,e():if wv then:do:k=r(6):loop until v(vc(k))=0:v(vc(k))=1:endif:cls:p 1:?@(85,0)w
page copy 3,2:p 2:for k=0 to 5:if v(vc(k))then:c vc(k):endif:next:p 0:scl 2:end sub:function r(k)
r=int(rnd*k):end function:sub f k:text t(k),sv-52,chr$(150),CT,,,,-1:end sub:sub m2 a,b,d:a=b XOR d
a=a AND d:b=d:end sub:sub MM:gui cursor mouse(x,mp),min(sv-80,mouse(y,mp)):m2 ml,L0,mouse(L,mp)
m2 mw,W0,mouse(W,mp):m2 mr,R0,mouse(R,mp):v1=max(0,v1-(v1>0)/4):play sound 1,b,n,100,v1:v2=v2-(v2>0)
play sound 2,b,p,100-v2,v2:end sub:sub ws:g$="In Renewed Defense of the Green Hills    by vegipete"
o=0:do:for k=1 to 52:text 50+k*10,sv/4+10*sin((k+o)/4),mid$(g$,k,1),,4,,yl:next:o=o+.02
loop until ml or mw or mr:end sub:sub up:play sound 2,b,t,bp,12:bp=bp+50:pause 45:play stop:end sub
