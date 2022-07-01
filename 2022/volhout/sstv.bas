'SSTV decoder program for ROBOT-8 mode for PICOMITE MMBasic
Option default integer
MODE 1

'pio program measure overlapping rising and falling period and send to FIFO
'loops increment both X and Y, alternating X and Y are reset and pushed.
'0 E020   'set X=0
'1 A029   'X -> fffffff
'2 00C5   'jmp (pin=1) to loop2
'3 0084   'Y-- (first loop Y contains rubbish)
'4 0042   'count X-- loop1
'5 A0CA   'mov -Y to ISR
'6 8000   'push noblock
'7 E040   'set Y=0
'8 A04A   'Y -> fffffff
'9 004A   'count X-- loop2
'A 008B   'Y--
'B 00C9   'jmp (pin=1) in loop2
'C A0C9   'mov -X to ISR
'D 8000   'push noblock
'E 0000   'jmp 0 (rest is filled with 0 = jmp->0)
Dim a%(7)=(&h008400C5A029E020,&hE0408000A0CA0042,&h00C9008B004AA04A,&h8000A0C9,
0,0,0,0)
f=3e6     '3MHz @ 3cycles per loop = 1us per tick

'configure pio1
e=Pio(execctrl 0,0,&h1f)  'use gp0 for PIN
s=Peek(word &h503000d0)   'use old value
p=0                       'no GPxx pins for PIO1

'program pio1 and start
PIO program 1,a%()
PIO init machine 1,0,f,p,e,s
PIO start 1,0

'pio fifo register
ff=&h50300020

'sstv specific frequecies converted to time in us
l=1e6/1100 'sync low
r=1e6/1200 'sync
u=1e6/1300 'sync high
b=1e6/1500 'black
v=1e6/1900 'black/white threshold
w=1e6/2300 'white

menu:
CLS
Print "SSTV Robot-8 playground":Print
Print "1 = measure frequency"
Print "2 = waterfall"
Print "3 = picture in burst mode (no hsync)"
Print "4 = picture monochrome"
Print "5 = picture in 4 green levels"
Print "6 = picture in dithered white"
Print "7 = stop"
Do
 kn$=Inkey$
Loop Until kn$<>""
Select Case Val(kn$)
 Case 1
   GoSub frequency
 Case 2
   GoSub waterfall
 Case 5
   GoSub greenvideo
 Case 3
   GoSub videobrute
 Case 6
   GoSub greyvideo
 Case 4
   GoSub video
 Case 7
   End
End Select
GoTo menu




frequency:
'measure time and convert to frequency
Do
 cnt=Peek(word ff) 'read fifo pio 1 seq 0
 period = cnt+3      'period
 Print @(300,240) Int(1e6/period);" Hz      "
 Pause 100
Loop While Inkey$=""
Return




waterfall:
'show frequency graph on horizontal axis, scolling down
CLS
Do
 Text 1,1,"frequency (Hz)","LT"
 Text r/2,1,"1200","CT"
 Text b/2,1,"1500","CT"
 Text w/2,1,"2300","CT"
 Line u/2,20,u/2,479
 Line l/2,20,l/2,479
 For y=20 To 479
   cnt=Peek(word ff)
   Pixel cnt/2,y,1
   Pause 0.5   'delay to slow waterfall
 Next y
 CLS
Loop While Inkey$=""
Return




video:
'video decode using both hsync and vsync
're-syncing every line and frame
Do
 'CLS
 y=180
 Do
   x=240
   Timer =0
   'pixel video read an display
   Do
     Pause 0.3 'horizontal timing
     x=Min(390,x+1)
     p=Peek(word ff)
     Pixel x,y,(p<v)
   Loop Until p>u And Timer>58
   Timer =0
   'hsync detect > 3.5ms, vsync > 10ms
   Do
     Pause 0.3 'lower misses syncs
     p=Peek(word ff)
   Loop Until p<u And Timer>3.5
   If Timer > 10 Then Exit
   Inc y
 Loop
Loop While Inkey$=""
Return




videobrute:
'video decode fixed timing from vertical sync

brute:
'find vsync
Do
 Do
   p=Peek(word ff)
 Loop Until p>u
 Timer =0
 Do
   p=Peek(word ff)
 Loop Until p<b
Loop Until Timer > 10

'brute force process all pixels and hsync equally
For y=180 To 298
 For x=240 To 359
   p=Peek(word ff)
   Pixel x,y,(p<v)
   Pause 0.487
 Next x
Next y
If Inkey$="" Then GoTo brute
Return




greenvideo:
'video decode in mode 2 using 4 level green
're-syncing every line and frame
MODE 2
Dim c%(3)=(0,&h4000,&h8000,&hC000) '3 green levels and black

Do
 CLS
 y=50
 Do
   x=80
   'capture pixel data and display
   Timer =0
   Do
     Pause 0.3 'rough horizontal timing
     x=Min(220,x+1)
     p=Peek(word ff)
     i=(p<580)+(p<522)+(p<470)
     Pixel x,y,c%(i)
   Loop Until p>u And Timer>60
   Timer =0
   'detect end of hsync to start new line
   Do
     p=Peek(word ff)
   Loop Until p<b And Timer>4
   If Timer > 10 Then Exit 'sync is vsync
   Inc y
 Loop
Loop While Inkey$=""
MODE 1
Return



greyvideo:
'create greyscale out of 3x3 tiles in B/W pixels
're-syncing every line and frame

CLS
Do
 y=50
 Do
   x=100
   'dither pixels by drawing them individually depending grey level
   Timer =0
   Do
     Pause 0.1
     x=Min(500,x+1)
     k=y+1:l=k+1
     p=Peek(word ff)
     Pixel x,y,(p<571)
     Pixel x,k,(p<522)
     Pixel x,l,(p<480)
     Inc x
     Pixel x,y,(p<500)
     Pixel x,k,(p<632)
     Pixel x,l,(p<445)
     Inc x
     Pixel x,y,(p<600)
     Pixel x,k,(p<462)
     Pixel x,l,(p<545)
   Loop Until p>u And Timer>60
   Timer =0
   Print @(0,0) x
   'detect end of hsync to start new line
   Do
     p=Peek(word ff)
   Loop Until p<u And Timer>3.5
   If Timer > 10 Then Exit 'sync is a vsync
   Inc y,3
 Loop Until y>407
Loop While Inkey$=""
Return