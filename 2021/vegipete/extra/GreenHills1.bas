'   In Defence of the Green Hills of Earth  v1.0              by vegipete, Feb 2021
' Use left and right arrow keys, and either Ctrl key.
mode 3,12:dim ax(54),ay(54),m(9)=(0,1,0,1,2,3,2,3,4,5),ny(20),nx(20):ey=210:l=0:nf=200:tt=10000
dim sf(7)=(0,1,1,0,0,-1,-1,0):r=268369920:g=251723520:b=251658495:rg=r or g:gb=g or b:ww=rg or b
bx=-400:bd=1.5:yd=3:settick 4,ps,2:settick 1000,am,3:math set 210,ny():settick 35,af,4
pause 500:Page write 1:box-1,9,322,191,,b:page write 0
do:yd=0:text 90,26,"Press a key to start...",,,,rg:do while inkey$<>"":loop:do
loop until inkey$<>"":settick 20,kp,1:lf=2:l=0:yd=3:sc=0:nl=1:p=150:do:cls:x=70:y=min(170,94+5*l)
u=2:v=142:for i=0 to 54:ax(i)=(i mod 11)*16:ay(i)=(i\11)*15:next:e=55:sp(0):sh:O=1:nf=499:l=l+1
z=2:w(40):w(110):w(180):w(250):sl:do:if y>math(min ay())+176 then go:exit do
if (keydown(7)and 34)<>0 and(s<10)and(f1=0)then s=184:t=p+24:play tone 500,500,20:f1=10
for i=1 to 20:d=2*(abs(t-nx(i))<3 and abs(s-ny(i))<3):nx(i)=nx(i)*(1-d):if d then se
if pixel(nx(i),ny(i))=gb then:settick 0,kp,1:yd=0:text p+13,189,"Boom":play stop
for j=1 to 25:play sound 1,b,n,100,26-j:pause 50:next j:play stop:text p-16,186,".....",,8
lf=lf-1:if lf<0 then go:exit do ' Confused yet?
yd=3:ws:sl:text p-16,186,"..H..",,8,,gb:settick 20,kp,1:endif:next:d=pixel(t,s-1)
if s and d=g then:line t-1,s+6,t-1,s-4,3,0:s=9:elseif s and d=ww and s<26 then:pt=50*int(1+rnd*3)
fx=bx:se:bx=bd*240:text fx+16,17,str$(pt)+" ",,,,r:sp(pt):f2=25:elseif s and d=ww and s>y-58 then
i=(y-s+15)\15:h=(t-x)\16:ax(i*11+h)=-400:ay(i*11+h)=80:text ex,ey,"'",,8:ex=x+h*16:ey=y-i*15
text ex,ey,"@",,8,,rg:sp(10+5*m(i*2)):se:e=e-1:if e=0 then exit do
d=abs(ax(0)):for i=1 to 54:d=min(d,abs(ax(i))):next:u=2-d:v=302-math(max ax())
endif:if nf=0 then:nf=int(20+10*rnd+10*e):d=int(rnd*11):do while ay(d)>60:d=(d+7)mod 55:loop
for i=1 to 20:if ny(i) > 210 then nx(i)=8+x+ax(d):ny(i)=y-ay(d)+12:exit for
next:endif:loop:if e then exit do ' Why must "ws" appear twice on the next line? Firmware bug?
ws:ws:loop:loop:sub sp(q):sc=sc+q:?@(0,1)sc:lf=lf+((sc\tt)=nl):nl=nl+((sc\tt)=nl):sl:end sub
sub w(h):text h,160,"KL",,8,,g:text h,172,"IJ",,8,,g:end sub:sub sh:?@(75,1)"High Score"hs:end sub
sub sl:for j=1 to 5:text 330-16*j,0,chr$(77+(lf<j)),"R",8:next:end sub
sub ws:do:loop until nn=20:end sub:sub se:ss=s:s=9:line t,ss-1,t,ss+6,,0:end sub
sub kp:k=keydown(1):p=p+1*((k=131)*(p<288)-(k=130)*(p>-16)):text p,186,".H.",,8,,gb:f1=f1-(f1>0)
end sub:sub ps:s=s-(s>9):line t,s,t,s+6,,(s>9)*gb:pixel t,s+7,0:nf=nf-(nf>0):end sub
sub am:text ex,ey,"'",,8:ey=210:if e then:x=x+z:settick 10+e*6,am,3:if x<u or x>v then z=-z:y=y+yd
O=O=0:for i2=0 to 54:text x+ax(i2),y-ay(i2),chr$(65+O+m(i2\11*2)),,8:next:endif:end sub
sub af:math add ny(),1,ny():nn=0:for j1=1 to 20:c=(pixel(nx(j1),ny(j1)-6)=g)+(nx(j1)<0)
for j2=0 to 7:j3 = abs(nx(j1))+sf((ny(j1)+8-j2)mod 8):px(0):if c then px(-1):px(1)
next j2:ny(j1)=ny(j1)+120*c: nn=nn+(ny(j1)>210): next j1:f2=f2-1 ' Great Scott! What a disaster!
bx=bx+bd:text bx,13,"/G\",,8:if abs(bx)>450 then br=1-2*cint(rnd):bd=-1.5*br:bx=br*(400+rnd*200)
if f2=1 then text fx,13,"\_/",,8:endif:end sub:sub px(c1):pixel j3+c1,ny(j1)-j2,b*(j2<>7)*(c=0)
end sub:DefineFont #8:0E400C10 00000000 00000000 90094812 0C302004 90092004 00004812 00000000
00000000 F81FC003 9C39FC3F 700EFC3F 300C9819 00000000 00000000 F81FC003 9C39FC3F 700EFC3F 0C309819
00000000 00000000 20021004 D80DF007 F417FC1F 60031414 00000000 00000000 24121004 DC1DF417 F007F80F
08081004 00000000 00000000 E001C000 D806F003 2001F807 2805D002 00000000 00000000 E001C000 D806F003
1002F807 10020804 00000000 00000000 F81FE007 B66DFC3F 9C39FFFF 00000810 00000000 80008000 C001C001
FF7FFE3F FF7FFF7F 0000FF7F FF0FFF0F FF0FFF0F FF0FFF0F FF0FFF0F E00FF00F C00FC00F F0FFF0FF F0FFF0FF
F0FFF0FF F0FFF0FF F007F00F F003F003 00000000 00000000 00000000 00000000 FF01FF00 FF07FF03 00000000
00000000 00000000 00000000 80FF00FF E0FFC0FF 00010000 F01F0001 F83FF83F 0000F83F 00000000 00000000
END DefineFont:sub go:pause 500:hs=max(hs,sc):sh:play tts "game over":ws:end sub
