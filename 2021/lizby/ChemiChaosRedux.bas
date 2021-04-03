mode 7,8:w=rgb(white):bk=rgb(notblack):dim cr(5):cr(0)=rgb(green):
cr(1)=rgb(red):cr(2)=rgb(cyan):cr(3)=rgb(yellow):cr(4)=rgb(blue)
cls w:x=13:y=13:for i=0 to 4:circle x,y,12,,,cr(i),cr(i):y=y+26:next i
line 13,134,13,154,2,bk:line 13,134,4,143,,bk:line 14,134,22,142,,bk
line 13,160,13,180,2,bk:line 13,180,4,171,,bk:line 14,180,22,170,,bk
line 30,2,72,2,2,bk:line 34,4,34,112,2,bk:line 67,4,67,112,2,bk:
circle 51,112,17,,,bk:circle 51,112,16,,,bk:box 36,90,31,22,,w,w
for i=1 to 9: on error skip: blit close i: next i
r=w:x=0:y=0:w=26:For i=1 To 8:Blit read i,x,y,w,w:y=y+w:Next i
Blit read 9,w+3,0,45,130:
x=37:y=16:for i=1 to 4:blit write i,x,y:y=y+w:next i:v=5:b=4:CLS r:
d$="ChemiChaos/5 Vials vegipete/lizby":text 160,0,d$,c,1,,rgb(red),r:
d$="1=L,2=R;' '=pick/put,r=reload,x=next":text 160,10,d$,c,1,,rgb(red),r:
For j=0 To 4:Blit write 9,j*50,100,0:next j:dim t(5,4):restore g:
Do:d$="":For i=0 To 3:read l:h$=Str$(l):d$=d$+h$:if l=0 then:cls r:font 5:
s$="S A F E !":text 60,100,s$,,,,rgb(green),r:do:loop:endif:next i:
e: k=1:x=10:For i=0 To 3:h$=mid$(d$,i*4+1,4):for j=1 to b:
c$=mid$(h$,j,1):l=val(c$):t(k,j)=l:t(5,j)=0:blit write l,i*50+10,82+j*w
next j:k=k+1:Next i:blit write 6,9,70:p=1:u=0:do:do:c$=inkey$:
loop until c$<>"":if c$="1" then:if x>50 then: blit x,44,x-50,44,26,52:
box x,44,26,52,0,r,r:x=x-50:p=p-1:endif:elseif c$="2" then:
if x<200 then: blit x,44,x+50,44,26,52:box x,44,26,52,0,r,r:x=x+50:p=p+1:endif
elseif c$="r" then:box 0,44,320,52,,r,r:box 210,108,w,w*4,0,r,r:goto e:
elseif c$="x" then:box 0,44,320,w*2,0,r,r:box 210,108,w,w*4,0,r,r: exit :
elseif c$=" " then:if u then:for i=1 to b:n=t(p,i):if n>0 then:exit for:endif:
next i:if n=z or i=5 then:i=i-1: if i>0 then:t(p,i)=z:blit write z,x,82+i*w
blit write 8,x,44: blit write 6,x,70:u=0:endif:endif:else:for i=1 to b:
z=t(p,i):if z<>0 then:t(p,i)=0:x=(p-1)*50+10:blit write z,x,44:
blit write 7,x,70:blit write 8,x,82+i*w:u=1:exit for:endif:next i:endif:
endif:loop:loop:
g: Data 2321,1412,4412,4333,4232,5235,2443,3554,3124,2121,2444,3331,1224,4232
Data 4311,4133,2141,4333,3242,4121,1314,3424,3231,2142,3233,4141,1241,2243
Data 3324,4421,1123,2431,4552,2444,3255,3332,2422,1434,3313,1241,0
