mode 1,16 : cls : LOAD JPG "EscapeGreenHills800x600.jpg" : do:loop until inkey$ <> ""

mode 1,8:M6=MM.VRES:M3=M6/2:M8=MM.HRES:M4=M8/2:C=100:for i=1 to 64:h=i*4-1:map(207+i/4)=rgb(h,0,h)
map(63+i)=h<<8:map(63+i/4)=rgb(h,h,h):map(175+i/2)=rgb(h,i*2-1,0):map(31+i/2)=h:next:map set:dn=0
cls map(65):T2$="The Green Hills":T1$="Escape to ":text M4,M4/2,T1$+T2$,CM,5,1,map(99),-1:SA:p 2:cls
for i=0 to M3:line 0,i,M8,i,1,map(63-i/10):line 0,M6-i,M8,M6-i,1,map(207-i/10):next:page copy 2,3
triangle M3,M3,-1,M6/3+4,-1,4*M3/3-4,,map(70):triangle M3,M3,M6,M6/3+4,M6,4*M3/3-4,,map(70):pA=0
p 3:for i=0 to 47:circle 950,700,C+i*7,9,1.5,map(127-i):next:dim g1(4),mz(900),dD(3)=(-30,1,30,-1)
for i=0 to 47:circle C,750,158+i*7,9,1.5,map(127-i):next:p 1:g$="This is l":data 62,91,0,9,1,"G9C9G"
dim bx(7)=(3,3,1.5,1.5,3,12,12,3),by(7)=(-3,3,1.5,-1.5,-3,-3,3,3),px(7),py(7),dx(4)=(8,-8,-4,4,8)
dim ix(4)=(3,-9,-1,8,3),iy(4)=(4,5,-5,-6,4),dy(4)=(10,10,-15,-15,10):g$=g$+"evel 7. Don't miss the"
dim g2(4),gx(4)=(0,-1,-3,-2,5),gy(4)=(0,5,5,-2,-1),ax(4)=(2,1,-1,-2,2),ay(4)=(-11,-8,-8,-11,-11):RN
dim hx(4)=(2,1,-1,-2,2),hy(4)=(-11,-14,-14,-11,-11):pause 999:DV:de=0:da=0:do:ld=0:do:k=asc(INKEY$)
ud=0:select case k:case 128,129:np=pP+dD(pA)*((k=128)-(k=129)):if mz(np)<>9 then pP=np:ud=1:endif
case 32:if gp then:line M6,M6,M4,M3,1,rgb(yellow):for i=1 to 150:play tone M6-i,510-i:pause 1:next:z
sp=pP:do while mz(sp)<>9:if mz(sp)<>4 then:sp=sp+dD(pA):else:af=af-1:if af=1 then:mz(sp)=0:e=0:endif
sp=0:endif:loop:ud=1:endif:case 115:save image "screenshot",0,0,M4,M4:case 130,131:pA=pA+1+2*(k=130)
pA=pA mod 4:ud=1:end select:if timer>999 and e=4 then:hd=int(rnd*4):if mz(hz+dD(hd))=0 then
mz(hz)=0:hz=hz+dD(hd):ud=1:mz(hz)=4:endif:timer=0:endif:if ud then:DV:ud=0:endif:if da=2 then
mz(pP)=6:da=1:pause 500:DV:endif:loop until ld+de:if not de then:RN:DV 1:circle M3,0,48,1,3.5,0,0:
p 0:for i=1 to 15:blit C,5,C,0,M6,594:next:for i=0 to M6 step 5:data 93,95,35,2,2,")g)))e)9)E)))g"
if dn then:blit C,5,C,0,M6,M6-i-5:blit 0,M6-i-5,0,M6-i-5,MM.HRES,i+5,3:else:blit C,5,C,0,M6,594
blit 0,0,C,M6-i,M6,i,1:endif:next:endif:loop until dn+de:data 153,155,93,3,2,"/g,)-],=-E-=-],)/g"
if da then:text M4,M4/2,T2$+" - safe at last?",CM,5,1,map(99),-1:else:pause 2500
text M4,M4/2,"No destruct.",CB,5,1,map(224),-1:text M4,M4/2,T2$+" are Doomed!",CT,5,1,map(224),-1
pause 3000:for j=1 to 5000:x=rnd*800:y=rnd*600:for i=1 to 15:circle x+i,y-i,i,1,3,map(79-i):next i,j
endif:?@(0,M6-50)"The End":end:sub ST t$,f,b:text M3,M3,t$,CM,,,MAP(f),MAP(b):end sub:sub DV ns:p 1
page copy 2,1:for d=7 to 0 step -1:vp=pP+dD(pA)*d:if vp>0 and vp<900 then:SW(7-d,-1,3):SW(7-d,1,1)
ah=mz(vp):if ah=9 then:off=by(1)*2^(7-d):box M3-off,M3-off,2*off+1,2*off+1,1,,map(71-d) 'Look at all
elseif ah<>0 then:DT d,ah:endif:endif:next:data 37,35,151,4,2,"Gg9)?e=9=E=)<?9Y?E8)Gg"  'this unused
if ns then:exit sub:endif:if af=1 then:af=0:ST "Got 'im!",0,121:endif:p 0:blit 0,0,C,0,M6,M6,1'space
end sub:data 186,338,279,4,3,")gg))))?e)89)E=)-])\-)-])_-))e)E-)19)gg":sub SA:au$="by VegiPete"'WOW!
text M4,M3,au$,CM,3,1,map(99),-1:end sub:sub SW d,sd,s1:sp=max(0,min(vp+dD((pA+s1)AND 3),900))
if mz(sp)=9 then:math scale bx(),sd*2^d,px():math add px(),M3,px():math scale by(),sd*2^d,py()
math add py(),M3,py():polygon 8,px(),py(),,map(64+d):endif:end sub:sub p k:page write k:end sub
sub DC h:circle M3,M3+h,ey,0,1.5,0,MAP(115-2*d):end sub:sub DT d,q:select case q:case 8
off=min(M3,4.5*2^(6-d)):circle M3,M3+off,off/6,1,3.5,0,0:ld=(d=0):case 4:ey=2^(7-d):DC ey:DC -ey
circle M3,M3,ey,0,2,0,MAP(121-2*d):if d=0 then:ST "Gotcha!",0,121:de=1:endif:case 2:if d=0 then
ST g$+" destruct button on level 3!",0,255:mz(pP)=0:else:DS ix(),iy(),d,78-d:endif:case 3
if d=0 then:ST "A Phasor! Awesome!",0,221:mz(pP)=0:gp=1:else:DS gx(),gy(),d,221-d:endif:case 5,6
DS dx(),dy(),d,60-d:if d=0 and q=5 then:ST "Destruct Activated!",255,60:da=2:endif:if q=5 then
DS hx(),hy(),d,224:else:DS ax(),ay(),d,126:endif:end select:end sub:sub DS xa(),ya(),d,cl
math scale xa(),2^(4-d),g1():math add g1(),M3,g1():math scale ya(),2^(4-d),g2()
math add g2(),M3+2^(8-d),g2():polygon 5,g1(),g2(),,map(cl):end sub:data 217,338,340,5,3
sub RN:mp=0:read a:if a=0 then:dn=1:exit sub:data "/gg-)),?E-89-E=--=-_],,=-g--)e-E--19-E?,(9/gg"
endif:pP=a:read a,hz,e,w:read m$:math set 1,mz():for i=1 to len(m$)-w+1 step w:r=0:for j=1 to w
r=r*64+asc(mid$(m$,j+i-1))-40:next:for j=1 to 6*w:mz(mp)=r and 1:mp=mp+1:r=r>>1:next
mp=(mp+30)\30*30:next:math scale mz(),9,mz():mz(a)=8:mz(hz)=e:af=5:end sub:sub z:play stop:end sub
data 217,45,75,4,3,"Ggg<,)=_E9<9EE=9)=?_=8,=GG]8)-?=E9E9E=?9(9?ge8()Ggg":data 163,511,278,4,4
data ")ggg)))))E=E)8<-)?_]),89)_??)-99)EEE)))))EeE),-9)]e?),(9)?_])8<-)E=E)))))ggg":data 0

