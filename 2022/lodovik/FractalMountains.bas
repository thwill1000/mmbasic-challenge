'Fractal Landscapes by Stephane Edwardson (Lodovik)
'Original program in Compute! 08/1987 by Matthew Timmerman
mode 1,16

const prg$="Fractal Landscapes"
dim szx=192,szy=576,yof=80,xof=-192
dim xs=.66,tx%(4),ty%(4),lv(szx,szy),cm(16,32)
dim pw,pd,nm$,mx,top,crn,med,rif,bch
dim cp=0,pa$(10),se(10,20),np'Pname,Prfl,#prfl,curprfl

data "Jungle",.25,3,75,85,65,70,10,13,6,8,2,3,3,4,1,0,64,128
data "Arctic",.50,.70,75,85,65,70,10,15,13,5,13,13,5,5,5, 200,200,255
data "Oasis",.5,1,75,85,65,70,10,15,10,15,1,1,1,1,3,0,64,128
data "Alps",2,3,75,85,65,70,10,15,4,8,13,13,2,3,1, 0,64,128
data "Mars",2,3,75,85,65,70,10,15,4,8,1,1,1,1,1,127,79,40
data "Moon",.25,.5,75,85,65,70,10,15,4,8,2,2,2,2,2, 255,255,255
data "-"'ele,top,crn,mid,rif,c1-5,wtrRGB

np=0
do while n$<>"-"
read n$
if n$<>"-" then
 inc np:pa$(np)=n$
 for z=1 to 15:read se(np,z):next
 read r,g,b
 se(np,16)=rgb(r,g,b):se(np,17)=rgb(rw(r,5),g,b)
 se(np,18)=rgb(r,rw(g,5),b):se(np,19)=rgb(r,g,rw(b,5))
end if
loop

mkpal 1,255,158,79'Brn
mkpal 2,255,255,255'Wht
mkpal 3,0,255,0'Grn
mkpal 4,128,128,128'Gry
mkpal 5,200,200,255'Blu

sub mkpal(p,r,g,b)
for a=0 to 31
cm(p,a)=rgb(a/31*r,a/31*g,a/31*b)
cm(p+8,a)=rgb(a/62*r+127,a/62*g+127,a/62*b+127)
next
end sub

pw=0:pd=0
rn$="landscape"
rn2$="next "+rn$
cls
do while k$<>chr$(27)
page write pd:status prg$,"Generating","elevation map","Please wait",-1
cp=cp+1:if cp>np then cp=1
mx=rndrng(se(cp,1),se(cp,2))
MakeMount
RndScn
page write pd:status "","Rendering",rn$,,-1
if pw=1 then page write pw:cls
text 0,599,pa$(cp),"LB",2,,rgb(white),rgb(black)
DrawMount
if pw=1 then swipe
pw=1:rn$=rn2$
loop


sub swipe
local s=1
page write 0
for x=0 to 800-s step s
blit x,0,x,0,s,600,1
pause 2
next
end sub

sub status(t$,l1$,l2$,l3$,pc)
local tb=rgb(15,15,30),tf=rgb(90,120,255)
page write pd
if t$<>"" then
rbox 620,2,179,100,3,rgb(blue),tb
text 710,6,ucase$(prg$),"CT",1,,rgb(white),tb
end if
if l1$<>"" then text 710,40,pad$(l1$),"CB",1,,tf,tb
if l2$<>"" then text 710,60,pad$(l2$),"CB",1,,tf,tb
if l3$<>"" then text 710,80,pad$(l3$),"CB",1,,tf,tb
if pc<0 then
box 625,86,169,10,,tf,tb
elseif pc>0 then
box 625,86,pc*169,10,,tf,tf
else
box 625,86,169,10,,tb,tb
end if
page write pw
end sub

function pad$(t$)
local l
l=int((18-len(t$))/2)
pad$=space$(l)+t$+space$(l)
end function

function rw(c,v)
local r,s
r=c+v
if r>255 then r=c-v
rw=r
end function

function rndrng(l,h)
rndrng=rnd*(h-l)+l
end function

function intrnd(l,h)
intrnd=int(rnd*(h-l+1))+l
end function

sub RndScn
nm$=pa$(cp)
top=maxlv*rndrng(se(cp,3),se(cp,4))/100
crn=maxlv*rndrng(se(cp,5),se(cp,6))/100
med=maxlv*rndrng(se(cp,7),se(cp,8))/100
rif=maxlv*rndrng(se(cp,9),se(cp,10))/100
for z=1 to 8:cm(z,32)=se(cp,16):next
end sub


sub MakeMount
maxlv=0
for iter=6 to 1 step -1
sk=2^iter:hl=sk/2
for y=0 to szy step sk
 for x=hl to szx step sk
  ran=(rnd-.5)*mx*sk
  old=(lv(x-hl,y)+lv(x+hl,y))/2
  lv(x,y)=old+ran
 next
next
for x=0 to szx step sk
 for y=hl to szy step sk
  ran=(rnd-.5)*mx*sk
  old=(lv(x,y-hl)+lv(x,y+hl))/2
  lv(x,y)=old+ran
 next
next
for x=hl to szx step sk
 for y=hl to szy step sk
  ran=(rnd-.5)*mx*sk
  old1=(lv(x+hl,y-hl)+lv(x-hl,y+hl))/2
  old2=(lv(x-hl,y-hl)+lv(x+hl,y+hl))/2
  old=(old2+old1)/2
  lv(x,y)=old+ran
  if lv(x,y) > maxlv then maxlv=lv(x,y)
 next
next
status "",,,,((7-iter)/6)
next
end sub

sub DrawMount
xm=4:ym=1:xp=70
for x=0 to szx
if lv(x,0) < 0 then lv(x,0)=0
next
for y=0 to szy-1
if lv(0,y) < 0 then lv(0,y)=0
for x=0 to szx-1
 k$=inkey$
 if lv(x+1,y+1) < 0 then lv(x+1,y+1)=0
 lvl=(lv(x,y)+lv(x+1,y)+lv(x,y+1)+lv(x+1,y+1))/4
 a=x:b=y:rx1=xm*a+xs*b:ry1=ym*b+yp-lv(a,b):sh1=gs()
 a=x+1:rx2=xm*a+xs*b:ry2=ym*b+yp-lv(a,b):sh2=gs()
 a=x:b=y+1:rx3=xm*a+xs*b:ry3=ym*b+yp-lv(a,b):sh3=gs()
 a=x+1:rx4=xm*a+xs*b:ry4=ym*b+yp-lv(a,b):sh4=gs()
 a=x+.5:b=y+.5:rx=xm*a+xs*b:ry=ym*b+yp
 a=x:b=y:ry=ry-lvl
 area(rx,ry,rx1,ry1,rx2,ry2,sh1)
 area(rx,ry,rx2,ry2,rx4,ry4,sh2)
 area(rx,ry,rx1,ry1,rx3,ry3,sh3)
 area(rx,ry,rx3,ry3,rx4,ry4,sh4)
 if k$=" " or k$=chr$(27) then exit for
next
status "",,,,((y+1)/szy)
if k$=" " or k$=chr$(27) then exit for
next
end sub

sub area(x1,y1,x2,y2,x3,y3,c)
tx%(0)=x1+xof:ty%(0)=y1+yof
tx%(1)=x2+xof:ty%(1)=y2+yof
tx%(2)=x3+xof:ty%(2)=y3+yof
polygon 3,tx%(),ty%(),c,c
end sub

function gs()
c=x+1-(b-y):d=y+(a-x):xc=x+.5:yc=y+.5
xr1=xc-a:xr2=xc-c:yr1=yc-b:yr2=yc-d
ri1=lvl-lv(a,b):ri2=lvl-lv(c,d)
yri=abs(ri1*xr2-ri2*xr1)
yru=abs(yr1*xr2-xr1*yr2)
if yru = yri then yru=1:yri=1
xri=abs(ri1*yr2-ri2*yr1)
xru=abs(xr1*yr2-yr1*xr2)
if xru = xri then xru=1:xri=1
xri=xri/2:yri=yri/2
xsh=1-abs(xri/(xru+xri))
ysh=1-abs(yri/(yru+yri))
sha=30*xsh*ysh+1
cl=se(cp,intrnd(16,19))
if lvl>0 then cl=cm(se(cp,15),sha)
if lvl>rif then cl=cm(se(cp,14),sha)
if lvl>med then cl=cm(se(cp,13),sha)
if lvl>crn then cl=cm(se(cp,12),sha)
if lvl>top then cl=cm(se(cp,11),sha)
gs=cl
end function
