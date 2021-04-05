' Copyright (c) JirSoft 2021

CLS
OPTION DEFAULT INTEGER:X1=135:X2=395:X3=655:cr=&hFFF0000:cy=&hFFFFF00:cw=&hFFFFFFF:tp=-1:frq=196
du$="112211112211112211221122111122111122112211221111112112211111121122111111211221111112":y3=799
mu$="ihfhiklkhifhefdbedabihfhiklkhifhefdbedabklmimlkiopmklmkpomlkhiklmimlkiopmklmkpomlkhi":ps=0
hz$="196,220,247,262,294,330,349,392,440,494,523,587,659,698,784,880,988":rr=250:xc=400:yc=300:n=13
DIM jt$(6)=(" Made by JirSoft for  ","CMM PRG Challenge 2021","Max. 48x100 characters","","","","")
jt$(3)="Very simple game, but ":jt$(4)=" I learned new things ":jt$(5)="  and it was FUN...   "
cb=RGB(NOTBLACK):cc=&hF0000FF:DIM d$(2):ke$="123qnb+-m":f$="emmmquxhlr":v=-1:j=1:SETTICK rr,z,1
y=480:w=100:MODE 1:TEXT 400,2,"TOWER of HANOI","CT",5,2,cy:BLIT 2,2,2,0,796,64,,4:y1=271:y2=599
BLIT 2,2,2,4,798,64,,4:BLIT 2,2,0,2,798,64,,4:BLIT 2,2,4,2,798,64,,4:PAGE WRITE 1:c$="0000":CLS
TEXT 400,2,"TOWER of HANOI","CT",5,2,cr:PAGE WRITE 0:BLIT 0,0,0,0,800,600,1,4:tn=0:SETTICK 100,tm,2
COLOUR RGB(CYAN):?@(4,y+34)"You have to move ALL discs from pillar 1 to pillar 3 with help of ";
?"pillar 2. There is just one rule:":COLOUR cr:?@(228)"You CAN'T put BIGGER disc onto SMALLER one."
COLOUR cw:?@(0,540)"KEYS: 123 ... get/put disc from/to pillar";:?@(360)"Q ... QUIT game":?@(48);
?"B   ... BEST solution (LCTRL=slow)";:BOX 0,y,800,30,1,cw,cc:f1=1:f2=3:?@(360)"N ... NEW game"
?@(48)"+-  ... change number of discs";:?@(360)"M ... music ON/OFF";:y4=210:p5=500:u:x:n=1:u:pt=0
DO:fk=INSTR(ke$,LCASE$(INKEY$)):fn$=MID$(f$,fk+1,1):CALL fn$:LOOP:SUB e:END SUB:SUB wk
DO WHILE INKEY$="":LOOP:END SUB:SUB h:INC n,n<13:u:END SUB:SUB tm:INC ti,tn:t2=(ti\10) MOD 60:
BLIT 98,y+2,100,y+2,200,27:j1=(frq-196)/31:jd:IF ti>10 THEN rn=rn AND (KEYDOWN(0)=0)
LINE 100,y+27-j1,100,y+27,1,cw:PIXEL 100,y+27,cc:t1=ti\600:BLIT 0,0,y3,0,1,66:BLIT 1,0,0,0,y3,66
IF tp<>t2 THEN TEXT 791,y+4,STR$(t1,2,0,"0")+":"+STR$(t2,2,0,"0"),"RT",1,2,cy,cc:tp=t2
END SUB:SUB q:qq:BOX 218,265,364,70,0,cc,cc:tx " Have a nice life ","  with your CMM2  ":wk:END
END SUB:SUB r:rr=250-rr:frq=196:SETTICK rr,z,1:END SUB:SUB l:INC n,-(n>1):u:END SUB
SUB rt:BOX 0,80,800,50,0,cb,cb:END SUB:SUB m:IF v THEN p(fk-1) ELSE IF d$(fk-1)<>"" THEN g(fk-1)
tn=1:t:END SUB:SUB ds(px,py,ww,cc):IF cc THEN BOX px,py,ww,20,1,cb,cb:EXIT SUB
BOX px,py,ww,20,1,cr,cy:FOR ix=2 TO ww-3:FOR iy=2 TO 17 STEP 3:IF RND>.9 THEN PIXEL px+ix,py+iy,cr
NEXT:NEXT:END SUB:SUB x:u:tn=1:TEXT 400,80," PRESS KEY TO START ","CT",4,2,cb,cy:rn=1:a n,0,2,1:
IF rn=0 THEN rt:u:EXIT SUB
tn=0:wk:h:u:END SUB:SUB a(nn,s,dd,hh):IF rn*nn=1 THEN g(s):pp:p(dd):pp:EXIT SUB
jt$(6)="Music by JBmusics.com ":IF rn THEN a nn-1,s,hh,dd:g(s):pp:p(dd):pp:a nn-1,hh,dd,s
END SUB:SUB g(i):v=ASC(LEFT$(d$(i),1))-48:o=LEN(d$(i)):xx=140-v*10:yy=y-o*20:xs=135+i*260
ds xx+260,130,v*20:ds xx+i*260,yy,v*20,1:BOX xs,yy,10,20,1,cw,cc:BOX xs+1,yy,8,20,1,cc,cc
d$(i)=MID$(d$(i),2):END SUB:SUB t:IF LEN(d$(2))<n THEN EXIT SUB
ts=1:FOR i=1 TO n:ts=ts AND ((ASC(MID$(d$(2),i,1))-48)=i):NEXT i:IF ts THEN wi
END SUB:SUB p(i):o=LEN(d$(i))+1:IF o>1 THEN IF (ASC(LEFT$(d$(i),1))-48)<v THEN EXIT SUB
d$(i)=CHR$(v+48)+d$(i):INC mo:ds 400-v*10,130,v*20,1:ds 140-v*10+i*260,y-o*20,v*20:v=0
TEXT 10,y+4,STR$(mo,4,0,"0"),"LT",1,2,cy,cc:END SUB:SUB u:BOX 0,y4,800,y-y4,0,cb,cb:ERASE d$:rt
BOX x1,y4,10,y1-n*20,1,cw,cc:BOX x2,y4,10,y1,1,cw,cc:BOX x3,y4,10,y1,1,cw,cc:DIM d$(2):FOR i=1 TO n
v=n-i+1:p(0):NEXT:ti=0:mo=0:TEXT 9,y+4,c$,"LT",1,2,cy,cc:TEXT x1+5,180,"1","CT",3,,cw,cb
TEXT x2+5,180,"2","CT",3,,cw,cb:TEXT x3+5,180,"3","CT",3,,cw,cb:tn=0:tp=-1
TEXT 400,y+4," LEVEL "+STR$(n)+" ","CT",1,2,cy,cc:END SUB:SUB z:dur=p5*VAL(MID$(du$,j,1))
frq=VAL(FIELD$(hz$,ASC(MID$(mu$,j,1))-96,",")):SETTICK dur,z,1:PLAY TONE frq/f1,frq/f2,dur:INC j
INC j,-LEN(mu$)*(j>LEN(mu$))):END SUB:SUB pp:wp=w+p5*(KEYDOWN(7)AND 2):w1=TIMER:DO WHILE TIMER-w1<wp
LOOP:END SUB:SUB wi:t9$="":IF mo<2^n THEN t9$="  OPTIMALLY  ":BOX 268,300,264,34,0,cr,cr
BOX 268,265,264,37,0,cr,cr:tx " You did it! ",t9$:tn=0:DO WHILE INKEY$="":LOOP:rt:h:END SUB:SUB qq
FOR i=0 TO y3 STEP 5:i1=65+i*.7:LINE i,65,y3-i,y2,1,cy::LINE 0,i1,y3,i1,1,cy:NEXT:END SUB
SUB tx(t8$,t9$):TEXT xc,yc,t8$,"CB",4,2,cb,cy:TEXT xc,yc,t9$,"CT",4,2,cb,cy:END SUB:SUB jd
BOX 547,y2-pt,252,25,0,cb,cb:TEXT y3,y2-pt,jt$(ps),"RT",2,,cy:INC pt,(pt<50):INC ps,(pt=50)*(ps<7)
INC pt,-50*(pt=50):INC ps,-(ps>6)*7:END SUB
