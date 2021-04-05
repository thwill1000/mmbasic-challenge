' Copyright (c) TimD 2021

cls
dim x(11),y(11),z(11),sx(999),sy(999),t$(3):t$(1)="HOME!":t$(2)="LOST IN SPACE!":t$(3)="CRASHED!"
dim o(14):data 698,659,698,587,523,440,466,392,196,293,3,1,2,2,8:for tn=0 to 14:read o(tn):next'Tune
mode 1,8:LVLS=30:dim c(LVLS),pw$(LVLS):data 940,7442,925,8351,791,180,344,755,110,279,581,996,760
data 5574,939,628,820,482,3377,130,733,6508,815,686,920,933,3665,98,651,758    'Seeds for each level
?@(195,310);"CONTROLS:  ";chr$(149);" ";chr$(148);" to rotate; <Return> to ignite engine"'Title page
BigTxt 200,"GRAVITY ASSIST!",260047040:font 4:?@(240,400);:input "Enter level code or <Return>: ",u$
for j=1 to LVLS:read c(j):s=c(j):for i=1 to 4:cat pw$(j),chr$(R(26)+97):next i:l=l+(pw$(j)=u$)*j
next j:l=max(1,l):s=c(l):LoadSprites:do:page write 0:cls:BigTxt 200,"LEVEL "+str$(l),262168576
BigTxt 250,"Code: "+pw$(l),rgb(GREY):inc at:?@(350,350)"Attempt: ";str$(at)          'Start of level
?@(330,450)"Press <Return>":do:loop until asc(inkey$)=13:page write 1:cls:s=c(l):nn=0:np=R(9)+2
z(0)=R(36):for n=0 to np+1:x(n)=R(600)+100:y(n)=R(400)+100: 'Set positions of sprites & display them
sprite show 1+(n<2)*z(n)+(n=1)*39+(n>1)*(n+47),x(n),y(n),0:next n:Stars:f=0:settick 99,Animate
SelectAngle :f=20:vx=sin(rad(z(0)*10)):vy=-cos(rad(z(0)*10)) 'Select angle & set starting velocities
do:sprite show z(0)+1,x(0),y(0),0:PC:pause 2:Grvty            'Flight loop: show ship; apply gravity
e=(sprite(D,z(0)+1,z(1)+40)<15)+(x(0)<0 or x(0)>799 or y(0)<0 or y(0)>599)*2+(p<=np)*3'Set exit code
sprite hide z(0)+1:z(0)=int((450+deg(atan2(vy,vx)))/10) mod 36:loop until e>0 'Ship angle;end flight
settick 0,Animate:BigTxt 50,t$(e),rgb((e=3)*160,(e=1)*128,(e=2)*255):PC        'Display exit message
select case e:case 1:Tune:inc l:at=0:case 2:Tune:case 3:Quake:end select:play stop 'Act on exit code
for n=1 to np:sprite hide n+49:next n:loop until l>LVLS             'Hide planets; end of level loop
cls:BigTxt 280,"Thanks for playing",251674656:x(1)=400:y(1)=400:settick 99,Animate      'Ending page
for x(1)=300 to 400:y(1)=500-x(1):pause 100:next x(1):settick 0,Animate             'End of the game
function R(range):s=(1103515245*s+12345) mod 2^31:R=int(s/2^31*range):inc nn:end function'Pseudo-rnd
sub BigTxt(ty,w$,col):for h=2 to 1 step -1:text 400-h,ty-h,w$,"C",5,1,rgb(WHITE),-1:next h
    text 400,ty,w$,"C",5,1,col),-1:end sub                                'Display big shadowed text
sub PC:page copy 1 to 0:end sub                                'Screen update shortcut to save space
sub LoadSprites:page write 1:cls:?@(5,5)"A":pixel fill 8,8,rgb(CYAN):for a=0 to 350 step 10
    image rotate 0,0,20,20,a*2,0,a:sprite read a/10+1,a*2+3,3,15,15:next a  'Ship every 10` rotation
    s=75:for p=1 to 10:z(p+1)=R(18)*(p<>5)+4:w=z(p+1)            'Seed random planet sizes & colours
    circle p*50,50,w,1,,251658304*(p=5),rgb(R(129)+64,R(129)+64,R(129)+64)*(p<>5)
    arc p*50,50,w-1,,0,180-179*(p=5):sprite read p+49,p*50-w,50-w,w*2+1,w*2+1:next p   'Draw planets
    circle 30,90,15,1,,,rgb(GREY):circle 30,90,10,1,,,0:line 20,89,40,89,3,rgb(GREY)
    line 29,80,29,100,3,rgb(GREY):circle 30,90,2,1,,,rgb(GREY):for b=0 to 8 'Space station every 10`
    image rotate 14,74,33,33,b*40+14,74,b*10:sprite read b+40,b*40+14,74,33,33:next b:end sub
sub Stars:for h=0 to 999:do:sx(h)=R(800):sy(h)=R(600):loop until pixel(sx(h),sy(h))=0
    pixel sx(h),sy(h),rnd*268435455:next h:end sub                 'Plot stars (only in empty space)
sub SelectAngle:do:sprite show z(0)+1,x(0),y(0),0               'User rotates ship in 10` increments
    text x(0)+7,y(0)+19," "+str$(z(0)*10)+"` ","C",7,1,rgb(YELLOW),0:PC:do:loop until inkey$=""
    do:k=asc(inkey$):loop until k>0:sprite hide z(0)+1:z(0)=(z(0)+((k=130)*35+(k=131))) mod 36
    loop until k=13:box x(0)-6,y(0)+19,24,7,1,0,0:end sub     'User presses <Return> to select angle
sub Animate:sprite hide z(1)+40:z(1)=(z(1)+1) mod 9:sprite show z(1)+40,x(1),y(1),0:for h=1 to 50
    tw=rnd*200:pixel sx(tw),sy(tw),rnd*2^28-1):next h:PC:play sound 1,B,N,10,max(f,0):f=f-5:end sub
sub Grvty:for p=1 to np:m=z(p+1)+(p=5)*100:d=sprite(D,z(0)+1,p+49):d=d+(d=0):v=sprite(V,z(0)+1,p+49)
    px=sin(v)*m/d^2:py=-cos(v)*m/d^2:if d<z(p+1) then exit for:endif:px=sgn(px)*min(abs(px),4)
    py=sgn(py)*min(abs(py),4):vx=vx+px:vy=vy+py:next p:x(0)=x(0)+vx:y(0)=y(0)+vy:end sub
sub Tune:for tn=0 to 4:for ch=1 to 3:play sound ch,B,T,o(tn+(e=2)*5)+(ch-2)*2,25-tn*4:next ch
    pause o(tn+10)*200:next tn:end sub                              'Play tune relevant to exit code
sub Quake:for q=10 to 0 step -1:qx=(rnd*3-1)*q:qy=(rnd*3-1)*q:sprite scroll qx,qy:PC:pause 30
    sprite scroll -qx,-qy:PC:pause 30:play sound 1,B,N,90,max(q*2.5,0):next:pause 1000:end sub
