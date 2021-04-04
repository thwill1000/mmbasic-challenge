' Copyright (c) JirSoft 2021

'Tower of Hanoi, expanded (readable) version
'Made by JirSoft for Colour Maximite 1 & 2 BASIC Programming Challenge 2021
'
'This expanded version is exact the same as compact one, just better formated and some parts
'are moved to (logically) proper place (when they were outside of context because of space).
'Whole game was made for fixed MODE1 (800x600x8bpp), on the begin started as resolution
'independent, but later because of space constraints some display constants were wired-in.
'
'Music was added simply because I had few lines for it, my friend made simple asian score (so it's
'original!) and I have converted it to special format. I have found then, that I can use 2 voices
'(and I had space for it), but it was too late. So it's playing basic melody to left channel and
'1/3 of it's frequency to right channel. Anyway, it can be switched ON/OFF with M-key...

OPTION DEFAULT INTEGER
X1=135:X2=395:X3=655 'x positions of pillar 1, 2 and 3
cr=&hFFF0000:cy=&hFFFFF00:cw=&hFFFFFFF  'color constants for RED, YELLOW and WHITE
cb=RGB(NOTBLACK):cc=&hF0000FF           '(actually it's somewhere longer then RGB version)

tp=-1 ' previous second counter, used for time displa
frq=196 'lowest frequency for music routine

'music in game, du$ is duration (1 is basic timing, 2 is twice so long, any number 1-9 can be used)
'mu$ is melody, a=G3, b=A3 etc., hz$ are frequencies of the notess
du$="112211112211112211221122111122111122112211221111112112211111121122111111211221111112"
mu$="ihfhiklkhifhefdbedabihfhiklkhifhefdbedabklmimlkiopmklmkpomlkhiklmimlkiopmklmkpomlkhi"
hz$="196,220,247,262,294,330,349,392,440,494,523,587,659,698,784,880,988"
j=1 'pointer to current note
f1=1:f2=3 'frequency divider for left and right channel
p5=500 'length of note with duration 1 (=500ms), added delay to autoplay with LCTRL
rr=250:SETTICK rr,z,1 'start of playing interrupt routine, with rr=0 is music switched off

xc=400:yc=300 'coordinates of screen center
y=480 'position of base for pillars
y4=210:y1=271 'some pos constant reused more times
y2=599  'MM.VRES
y3=799  'MM.HRES (why y3 when is X-position?)
n=13 'game starts with autoplay of level 13 (highest)

'text scroller. Because later I have added black box before it, it doesn't need to be the same
'length, but I forget to save this space
pt=0 'relative Y position of current text
ps=0 'pointer to current string (0-6)
DIM jt$(6)=(" Made by JirSoft for  ","CMM PRG Challenge 2021","Max. 48x100 characters","","","","")
jt$(3)="Very simple game, but ":jt$(4)=" I learned new things ":jt$(5)="  and it was FUN...   "
jt$(6)="Music by JBmusics.com "

DIM d$(2) 'used as STACK for discs on pillars, first char ist the highest one (LEFT1 and MID2 is faster)
v=-1 'if v<0, no disc is prepared to be put somewhere (all are on pillars), otherwise disc # for play next
w=100 'autoplay wait-time (100ms)
'set MODE and prepare outline text for main banner
MODE 1:TEXT 400,2,"TOWER of HANOI","CT",5,2,cy:BLIT 2,2,2,0,796,64,,4
BLIT 2,2,2,4,798,64,,4:BLIT 2,2,0,2,798,64,,4:BLIT 2,2,4,2,798,64,,4:PAGE WRITE 1
CLS
TEXT 400,2,"TOWER of HANOI","CT",5,2,cr:PAGE WRITE 0:BLIT 0,0,0,0,800,600,1,4

c$="0000" 'start counter
tn=0 'when tn=0, time is not running
SETTICK 100,tm,2 'start of time interrupt routine

'draw help texts
COLOUR RGB(CYAN):?@(4,y+34)"You have to move ALL discs from pillar 1 to pillar 3 with help of ";
?"pillar 2. There is just one rule:":COLOUR cr:?@(228)"You CAN'T put BIGGER disc onto SMALLER one."
COLOUR cw:?@(0,540)"KEYS: 123 ... get/put disc from/to pillar";:?@(360)"Q ... QUIT game":?@(48);
?"B   ... BEST solution (LCTRL=slow)";:BOX 0,y,800,30,1,cw,cc:?@(360)"N ... NEW game"
?@(48)"+-  ... change number of discs";:?@(360)"M ... music ON/OFF";

u 'new game
x 'start autoplay
n=1:u 'after key restart game with level 1

'for this part I'm most proud of...
'it's main program routine, which checks keyboard and do proper call
ke$="123qnb+-m" 'all possible keys
f$="emmmquxhlr" 'routines for keys, e=EMPTY routine (when nothing was pressed)

DO
 fk=INSTR(ke$,LCASE$(INKEY$)) 'get lower case key position, when no key, fk=0
                              'fk is also reused for pillar number in move routine
 fn$=MID$(f$,fk+1,1) 'get routine name, +1 makes 'e' routine for nothing pressed
 CALL fn$ 'routine call
 'actually CALL MID$(f$,fk+1,1) will be shorter, but it doesn't work (why ???)
LOOP

SUB wk 'waiting for any key
 DO WHILE INKEY$=""
 LOOP
END SUB

SUB h 'increase level up to 13
 INC n,n<13 'smart way without IF...
 u 'new game
END SUB

SUB l 'decrease level up to 1
 INC n,-(n>1) 'smart way without IF...
 u 'new game
END SUB

SUB tm 'time interrupt routine (100ms)
 jd 'call scroller
 j1=(frq-196)/31 'height of audio display
 INC ti,tn 'increase tick (just when tn<>0)
 t2=(ti\10) MOD 60 'seconds of time
 BLIT 98,y+2,100,y+2,200,27 'move audio display
 rn=rn AND (KEYDOWN(0)=0 OR ti<10) 'if key is pressed and autoplay running (rn=1), stop it
 LINE 100,y+27-j1,100,y+27,1,cw 'audio level of current note
 PIXEL 100,y+27,cc 'remove this lower pixel (mainly needed when audio muted)
 t1=ti\600 'minutes of time
 BLIT 0,0,y3,0,1,66 'move main banner
 BLIT 1,0,0,0,y3,66 '

 'when seconds were changed, display time
 IF tp<>t2 THEN TEXT 791,y+4,STR$(t1,2,0,"0")+":"+STR$(t2,2,0,"0"),"RT",1,2,cy,cc:tp=t2
END SUB

SUB q 'quit
 qq 'show effect
 BOX 218,265,364,70,0,cc,cc:tx " Have a nice life ","  with your CMM2  "
 wk 'wait for key
 END
END SUB

SUB r 'music ON/OFF
 rr=250-rr
 frq=196 'for audio display (no level)
 SETTICK rr,z,1
END SUB

SUB rt 'remove 'PRESS KEY TO START'
 BOX 0,80,800,50,0,cb,cb
END SUB

SUB m 'make move, also very interesting
 'pg$='g' (GET) on begin, in succesfull GET is changed to 'p'
 'when nothing to get, change to EMPTY 'e' routine (reused)
 pg$=CHR$(ASC(pg$)-2*(pg$="g" AND d$(fk-1)=""))
 tn=1 'start running time
 CALL pg$,fk-1 'call 'g' (GET from pillar), 'p' (PUT to pillar) or 'e' (EMPTY)
 t 'test for finish
END SUB

SUB ds(px,py,ww,cc) 'draw disc on position px,py, wide ww
 IF cc THEN BOX px,py,ww,20,1,cb,cb:EXIT SUB 'when cc=1 then erase it
 BOX px,py,ww,20,1,cr,cy 'draw yellow disc
 'make some random red points for better effect
 FOR ix=2 TO ww-3
   FOR iy=2 TO 17 STEP 3
     IF RND>.9 THEN PIXEL px+ix,py+iy,cr
   NEXT
 NEXT
END SUB

SUB x 'autoplay
 u 'new game
 tn=1 'start time run
 TEXT 400,80," PRESS KEY TO START ","CT",4,2,cb,cy
 rn=1 'autplay is running
 a n,0,2,1 'call autoplay routine

 IF rn=0 THEN 'if autoplay was stopped (in tm routine)
   rt  'remove text
   u   'start new game
   EXIT SUB
 ENDIF 'this is added because of multiline expansion

 tn=0 'autplay was completed
 wk 'wait for key
 h ' mistake ?
 u ' new game
END SUB

SUB a(nn,s,dd,hh) 'recursive Hanoi solver,
                 'move nn discs from 's' to 'dd' over 'hh'

 IF rn*nn=1 THEN   'if running and nn=1, make last move and finish
   g(s)  'get disc from source pillar
   pp    'delay
   p(dd) 'put disc to destination piller
   pp    'delay
   EXIT SUB
 ENDIF 'this is added because of multiline expansion

 IF rn THEN   'if still not stopped, make recursion
   a nn-1,s,hh,dd 'recursion
   g(s)  'get disc from source pillar
   pp    'delay
   p(dd) 'put disc to destination piller
   pp    'delay
   a nn-1,hh,dd,s 'recursion
 ENDIF 'this is added because of multiline expansion
END SUB

SUB g(i)  'get disc from pillar i  (0-2 for pillar 1-3)
 v=ASC(LEFT$(d$(i),1))-48 'what disc is on this pillar?
 o=LEN(d$(i)) 'how many disc on this pillar?
 xx=140-v*10 'x position of the disc
 yy=y-o*20   'y position of the disc
 xs=135+i*260  'pillar position

 ds xx+260,130,v*20 'draw disc to temporary place
 ds xx+i*260,yy,v*20,1 'erase disc from pillar
 BOX xs,yy,10,20,1,cw,cc 'draw the pillar border (all 4)
 BOX xs+1,yy,8,20,1,cc,cc 'and remove top and bottom one

 d$(i)=MID$(d$(i),2) 'remove disc from stack
 pg$="p" 'now can be used PUT
END SUB

SUB t 'test for finishing of the level
 IF LEN(d$(2))<n THEN EXIT SUB 'not enough discs on pillar 3
 ts=1 'finish
 FOR i=1 TO n
   ts=ts AND ((ASC(MID$(d$(2),i,1))-48)=i) 'if not order, not finished yet
 NEXT i
 IF ts THEN wi 'if finish, call WIN
END SUB

SUB p(i) 'put disc to pillar i (0-2 for pillar 1-3)
 o=LEN(d$(i))+1 'how many discs WILL be on this pillar?
 IF o>1 THEN 'some disc(s) already on piller, check for size
   IF (ASC(LEFT$(d$(i),1))-48)<v THEN 'bigger on smaller not allowed
     EXIT SUB
   ENDIF 'this is added because of multiline expansion
 ENDIF 'this is added because of multiline expansion

 d$(i)=CHR$(v+48)+d$(i) 'add disc to stack
 ds 400-v*10,130,v*20,1 'erase temporary disc
 ds 140-v*10+i*260,y-o*20,v*20 'draw new one on pillar
 v=0 'nothing to GET
 pg$="g" 'so GET will be next

 INC mo 'increase move counter
 TEXT 10,y+4,STR$(mo,4,0,"0"),"LT",1,2,cy,cc 'show new move counter
END SUB

SUB u 'NEW game
 ti=0 'set time to 00:00
 tn=0 'time is not running
 tp=-1 'previous seconds

 BOX 0,y4,800,y-y4,0,cb,cb 'clear part of the screen

 ERASE d$ 'clear stack, shorter than d$(0)="":d$(1)="":d$(2)=""
 DIM d$(2)

 FOR i=1 TO n 'and fill pillar 1
   v=n-i+1 'fool PUT routine
   p(0) 'PUT disc
 NEXT

 rt  'remove text
 BOX x1,y4,10,y1-n*20,1,cw,cc
 BOX x2,y4,10,y1,1,cw,cc
 BOX x3,y4,10,y1,1,cw,cc

 mo=0 'move counter to 0000
 TEXT 9,y+4,c$,"LT",1,2,cy,cc 'and redraw it

 TEXT x1+5,180,"1","CT",3,,cw,cb 'pillar numbers
 TEXT x2+5,180,"2","CT",3,,cw,cb
 TEXT x3+5,180,"3","CT",3,,cw,cb

 TEXT 400,y+4," LEVEL "+STR$(n)+" ","CT",1,2,cy,cc 'level=n
END SUB

SUB z 'MUSIC play routine, called in interrupt
 dur=p5*VAL(MID$(du$,j,1)) 'calculate duration
 frq=VAL(FIELD$(hz$,ASC(MID$(mu$,j,1))-96,",")) 'and frquency of current note
 SETTICK dur,z,1 'prepare for next note
 PLAY TONE frq/f1,frq/f2,dur 'play note, both channels are different

 INC j 'next note
 INC j,-LEN(mu$)*(j>LEN(mu$))) 'repeat from j=1
 'I had some reason not to use MOD function here, but I don't know it anymore...
END SUB

SUB pp 'PAUSE
 wp=w+p5*(KEYDOWN(7)AND 2) '100ms + 500ms when LCTRL is pressed

 w1=TIMER 'wait in loop
 DO WHILE TIMER-w1<wp
 LOOP
 'I started with PAUSE wp, but this interrupted music play also
END SUB

SUB wi 'WIN (level finished)
 t9$="" 'prepare first row
 IF mo<2^n THEN 'finished in least number of moves
   t9$="  OPTIMALLY  " 'show it
   BOX 268,300,264,34,0,cr,cr 'and make border
 ENDIF 'this is added because of multiline expansion

 BOX 268,265,264,37,0,cr,cr:tx " You did it! ",t9$ 'show text
 tn=0 'stop time
 wk 'wait for key
 rt 'remove wait text
 h 'increase level
END SUB

SUB qq 'effect for QUIT
 FOR i=0 TO y3 STEP 5
   i1=65+i*.7
   LINE i,65,y3-i,y2,1,cy
   LINE 0,i1,y3,i1,1,cy
 NEXT
END SUB

SUB tx(t8$,t9$) 'text in 2 lines
 TEXT xc,yc,t8$,"CB",4,2,cb,cy
 TEXT xc,yc,t9$,"CT",4,2,cb,cy
END SUB

SUB jd 'SCROLL text
 BOX 547,y2-pt,252,25,0,cb,cb 'clear rest (without it, text will draw path of last line)
 TEXT y3,y2-pt,jt$(ps),"RT",2,,cy 'draw current string

 INC pt,(pt<50) 'increase position from 0 (bottom) to 50 (final pos)
 INC ps,(pt=50)*(ps<7) 'if final position, take next string
 INC pt,-50*(pt=50) 'if final position make position=0
 INC ps,-(ps>6)*7 'if string=7 then should be 0
END SUB

SUB e(i) 'EMPTY routine for no key pressed and also GET with no disc to GET
 pg$=CHR$(103+9*(v>0)) 'change from 'g' to 'p' when used in main loop
END SUB
