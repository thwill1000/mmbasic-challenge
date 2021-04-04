' Copyright (c) realbobele 2021

mode 3,8:dim lu as integer:dim an(199) as integer:dim r as integer:dim s as integer
dim hs as integer
page write 1:cls:color rgb(red),rgb(blue):print "A":sprite read 1,0,0,5,7:color rgb(white),rgb(blue)
page write 0
menue
sub init
an (0) = 150:lu = 50:n=1:s=0
for c=1 to 199:r=rnd*2:if r=1 then an(c)=an(c-1)-2 else an(c)=an(c-1)+2:end if
if an(c) < 30 then an(c) = 30:if an(c) > 280 then an(c) = 290
next c
p=an(183)+22:mainloop
end sub
sub mainloop
do:page write 1:malen:scrollen:player:page copy 1 to 0,I:loop:end sub
sub Malen
for c=0 to 199:line 0,c,an(c),c:w=an(c)+lu:line an(c),c,w-1,c,,RGB(blue):line w,c,320,c:next c
end sub
sub Scrollen
for c=198 to 0 step -1:an(c+1)=an(c)
next c
r=rnd*2
if r=1 then an(0)=an(1)-2 else an(0)=an(1)+2
if an(0) < 30 then an(0) = 30
if an(0) > 270 then an(0) = 270
n=n+1
if n=300 then
if lu>27 then
lu=lu-1
end if
n=1
end if
end sub
sub player
s=s+1:if keydown(1)=130 then p=p-1
if keydown(1)=131 then p=p+1
sprite write 1,p,180,0
if p<an(183) then crash
if p>an(183)+lu-5 then crash
end sub
sub crash
  page write 0:cls:print@(140,100) "Crashed!":play tone 500,550,500:pause 3000:menue
end sub
sub menue
cls:print@(140,90) "ICEBERG":print@(100,110) "Your last Score:",s:if s>hs then hs=s
print@(115,120) "Highscore:",hs:print@(90,140) "Press SPACE to start..."
do:if keydown(1)=32 then init
loop:end sub

