' TLSS = Ten Line Sokoban with Sprites

' control by cursor keys-128 (128,129,130,131 => 0,1,2,3 => ^ V < >)
' playfield values 0=empty, 1=target, 2=block, 3=wall
' press "r" to redo the level, "n" to skip to the next level

'z   = size block
'x,y = position human
'e,g = new position human
'o,p = position onscreen
'n   = ascii value key
'b,c = direction human
'd   = done
'a$  = key pressed
'l,m = vars for decoding rooms
'i,j = counters
'k   = value field f(i,j)
'f() = playing field
't() = target locations for the boxes
's   = size playfield (sxs)
'q   = boolean (human on target)
'w   = level (0....nn)
'v$()= array to create sprites
'r$  = sprite color

' for CMM2 players this is needed
option legacy on

' defines of the playfield and block size
s=11 'a playfield is 11x11 in size, larger is possible but supplied levels must be tuned
z=15 'block size is 15x15 pixels. This allows a 11x11 playfield to be displayed in mode4


'-----------------------------------------GAME ENGINE-------------------------------------

Dim f(s,s),t(s,s),v$(16) 'define the arrays matching the playfield and sprite size

GoSub 1:Sprite Load "x.s" ' subroutine "1" creates the file "x.s" from data statements
' the the sprites are loaded into CMM memory
' there are 8 sprites: empty square, target, block, wall and
' 4 orientations of the Mario guy

'this is the init loop, you NEVER leave this loop, exit statements bring you back here, and a level is started
Do
Mode 4
Read x,y ' read (X,Y) location of Mario
For i=1 To s
Read a$ ' read the 11 columns that define a field as hexadecimal numbers
l=Val("&h"+a$)
For j=1 To s ' in each column read 11 values from the large hexadecimal number
f(i,j)=3 And l ' by masking bits, put this info in the playfield f(i,j)
t(i,j)=(f(i,j)=1) ' if the playfield value is 1 (target) the copy that value in t(i,j)
l=l\4 ' and shifting by logical divide (not numerical divide)
Next j,i

' array f(i,j) gets update at each move, and has no "memory". The only thing worth remmebering
' is the location of the targets. These are stored in the t(i,j) array, so when Mario walks over
' a target, the target location is restored from t(i,j)

' Now we draw the playfield. For code compactness all is redrawn, not only the changed tiles
Cls
Print w,,"TLS" ' the header, and level (w) are printed on top of the screen
f(x,y)=4 ' locate mario at (x,y)

'this is the main game loop, als long as you play this level, you neve leave this loop
Do
d=0 ' d is used to check if the level is complete (done).

'draw the playfield by copying the filed info f(i,j) to the screen using sprites
For i=1 To s
For j=1 To s
k=f(i,j) ' k is only used to compact the code
o=120+z*(i-6) ' o = X screen coordinate
p=99+z*(j-6) ' p = Y screen coordinate
Sprite write Int(k+1+((k=4)*n)),o,p ' put sprite
d=d+(k=1) ' increment d only if you draw a target
Next j,i
If d+q=0 Then ' if there is no target shown
w=w+1 ' go to the next level
Exit ' and exit this do-loop
EndIf

Do ' check if player presses a key
a$=Inkey$
Loop While a$=""

n=3 And Asc(a$) ' this section decodes arrow keys (128/129/130/131)
c=(n<2)*(n*2-1) ' to b(delta X, value -1/0/1) and c (delta Y, value -1/0/1)
b=(n>1)*(n*2-5)
e=x+b ' and addst these to (x,y), the location of Mario
g=y+c ' the new location of Mario will be (e,g) if the move is allowed

If f(e,g)=3 Then ' if the next location for Mario is "3" (a Wall) the don't move.
b=0:c=0
ElseIf f(e,g)=2 Then ' if the next location for Mario is a box, the check if the box can move
If f(e+b,g+c)<2 Then ' check if the new location of the box is < 2 (either mepty of a target)
f(e,g)=t(e,g) ' restore the target
f(e+b,g+c)=2 ' and put the box at it's new postion
Else
b=0:c=0 ' if the box can't move, then als stop the move on Mario
EndIf
EndIf

f(x,y)=t(x,y) ' restore Mario's old position to it's former state (target or floor)
x=x+b:y=y+c ' move Mario to it's new position (if b=0,c=0 the new position is the old position)
f(x,y)=4 ' put Mario's position in the array

q=t(x,y) ' q is used to prevent the game to stop if Mario is standing on a target

' user manual control actions
If a$="r" Then ' if "r" is pressed the same level is restarted
Exit ' the exit leaves the game loop and enters the init loop
EndIf
If a$="n" Then ' if "m" is pressed the next level is started
w=w+1 ' w = next level
if w>19 then w=19 ' make sure you cannot get past level 19
Exit ' the exit leaves the game loop and enters the init loop
EndIf
Loop
Restore ' this always restures to the first data statement of the program
For i=1To(s+2)*w ' and then dummy reads w levels (x,y and 11 field values) to arrive at the
Read a$ ' right data for the level you want to play next
Next i
Loop: ' this is the outer init loop


' these are the data statements of the 20 embedded levels. The first 2 values each line are (x,y) of Mario
' then there are 11 hex numbers. In these are build up from 2 bit values per cell
' &b00 = empty floor, &b01 = target, &b10 = box, &b11 = wall. Mario is not part of the map, but is drawn later.

' example FFC -> &hFFC = 11 11 11 11 11 00 = wall,wall,wall,wall,wall,empty
' the lsb is the vertically highest tile on the screen (empty in this example).

Data 9,2,FFC,3003,3003,30C3,FC0,,FFC,3217,3203,3003,FFC
Data 5,2,,,,FFFF,D5F3,CBC3,C023,C3CF,EC0C,C0FC,FFC0
Data 8,5,,,,FC0,DC0,CFF,FE87,D83F,FFB0,370,3F0
Data 6,3,,,3FF,3FF03,30FA3,30083,303FF,3F300,C3F0,C570,FFF0
Data 5,4,,,,FF0,C30,E3F,3DA3,3163,3163,3F03,3FF
Data 7,7,,,,FF00,C3F0,C03F,CE07,C897,C87F,C3F0,FF00
Data 6,6,,,3FF,3F03,3023,30E3,3163,317F,32F0,30C0,3FC0
Data 9,7,,,,,FFFF,C017,C897,FABB,C897,C017,FFFF
Data 7,6,,,FFFF,D503,D1B3,CB03,C23F,F30C,328C,3F0C,3FC
Data 7,6,,,,3FF0,303F,3053,3373,32B3,3C23,C0F,FFC
Data 8,2,,,,FF0,C3F,FC03,C273,CE23,C44F,FF0C,3FC
Data 6,2,,,,,FFFF,C303,C0B3,DA13,CDEF,C10C,FFFC
Data 2,3,FFC,3FC0C,30C8C,300BF,37F23,37203,37003,3723F,37F30,30030,3FFF0
Data 6,3,,,,3FFFC,321DC,32FCF,31323,36683,32043,31FFF,3FC00
Data 10,7,,FF,3FFCC3,300FE3,339003,331FEF,339C0C,3C1CEC,3F100C,30FFC,3FC00
Data 5,10,,,3FFFC0,3005C0,33F5FF,303003,32B0C3,3E3FCF,32000C,303F0C,3FF3FC
Data 5,3,3FC0,30FF,F023,C2C3,CC8F,C0BC,FF0C,F0C,D0C,D5C,FFC
Data 3,8,FFFFC,C3C0C,C008C,C0F0F,FC8C3,C803,FC3F,3570,3030,30F0,3FC0
Data 9,7,,,,3FFF,3003,3333,3003,FF3F,C2A3,C153,FFFF
'the last level cannot be finished per design, and therefore the game stops here.
Data 10,10,3FF003,3333FF,303003,0,3FF3FF,8030,3FF3FF,0,3FF3FF,307333,FC303


' This is a separate section of the program that "creates" the file "x.s" that is the sprite file
' for the floor, target,box and wall, and 4 instances of Mario (8 spritest total)
' this section uses a line number since that is the most compact form of a label.

1 Open"x.s" For output As #1 ' open the file
Print #1,"16,8" ' write the size and number of sprites

Do ' read the data statements in a loop until you hit the "s"
Read a$ ' the "s" signifies the start of the sprite data.
Loop Until a$="s"

' start of reading the actua sprite data. The data is RLE (run length encoded.
' example: a sprite line that has (16) value 11111333333333 it is encoded as 5193 (5 x "1" and 9 x "3")
' the v() array is used to store the decoded values, and is used specificly for repeating data.
For i=1 To 8 ' for all 8 sprites
For j=1 To 14 ' read the 14 values (the 16x16 spritest only use 14x14 data)
Read a$
b=Len(a$) ' the length is ised to distinguish between repeats and new data
v$(j)=""
If b=1Then ' a string length pf 1 (single digit) signifies a pointer to a previous
v$(j)=v$(Val(a$)) ' value, and that copy is made
Else
For k=1 To b Step 2 ' read RLE pairs from the string
n=Val("&h"+Mid$(a$,k,1)) ' n= the number (in hex value so a single digit stores a value 0..15
r$=Mid$(a$,k+1,1) ' r$ is the pixel color (0...7 for 8 color CMM1)
For l=1 To n ' add n instances of r$
v$(j)=v$(j)+r$
Next l,k
EndIf
Print#1,v$(j)+"  " ' add 2 spaces (transparent pixels) to the line
Next j
Print#1,Space$(16) ' at the end of 14 lines of sprite data add 2 lines of spaces
Print#1,Space$(16) ' transparent lines to fill the 16x16 field
Next i ' next sprite

Close#1 ' close the file, so it can be re-opened by Sprite Load
Restore ' put the data pointer to the first data statement, so the game can read
Return ' the playfield. Then return to the game


'this is the data for the 8 sprites
Data s ' indicates start of sprite data

Data E0,1,1,1,1,1,1,1,1,1,1,1,1 '14 x "0" = black, then 13 repeats of this same line
Data 1,E0,1,1,3016601630,4016401640,5016201650,602660,7,6,5,4,1,1,1,2210821022
Data 1,E0,1,1,1,1,1,1,1,1,3,1,1,4410441044,1,E0,14104410441024,4,3,1,1,3,4,4,3
Data 1,1,2730443027,2720642027,2710841027,27102445241027,271014154415141027
Data 27111564151127,2711841127,7,7,10171184111710,1031643110,2031443120,308130
Data 406140,406140,308130,2031443120,1031643110,10171184111710,2711841127,6,6
Data 27111564151127,271014154415141027,27102445241027,2710841027,2720642027
Data 2730443027,9750,A71130,507120,203415443110,1034156431,34158421,6,6,6,5,4,3
Data 2,1,5097,3011A7,207150,103144153420,3164153410,21841534,6,6,6,5,4,3,2,1
