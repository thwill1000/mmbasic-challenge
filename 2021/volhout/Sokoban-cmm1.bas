' Copyright (c) Volhout 2021

s=11:z=16:Dim f(s,s),t(s,s),v$(16):GoSub 1:Sprite Load"x.s":Do:Mode 4:Read x,y
For i=1To s:Read a$:l=Val("&h"+a$):For j=1To s:f(i,j)=3And l:t(i,j)=(f(i,j)=1)
l=l\4:Next j,i:Cls:Print w,,"TLS":f(x,y)=4:Do:d=0:For i=1To s:For j=1To s:k=f(i,j)
o=120+z*(i-6):p=99+z*(j-6):Sprite paste Int(k+1+((k=4)*n)),o,p:d=d+(k=1):Next j,i
If d+q=0Then:w=w+1:Exit:EndIf:Data 9,2,FFC,3003,3003,30C3:Do:a$=Inkey$
Loop While a$="":n=3And Asc(a$):c=(n<2)*(n*2-1):b=(n>1)*(n*2-5):e=x+b:g=y+c
If f(e,g)=3Then:b=0:c=0:ElseIf f(e,g)=2Then:If f(e+b,g+c)<2Then:f(e,g)=t(e,g)
f(e+b,g+c)=2:Else:b=0:c=0:EndIf:EndIf:f(x,y)=t(x,y):x=x+b:y=y+c:f(x,y)=4:q=t(x,y)
If a$="r"Then:Exit:EndIf:Data FC0,,FFC,3217,3203,3003,FFC,5,2,,,,FFFF,D5F3,CBC3
Loop:Restore:For i=1To(s+2)*w:Read a$:Next i:Loop:Data C023,C3CF,EC0C,C0FC,FFC0
Data 8,5,,,,FC0,DC0,CFF,FE87,D83F,FFB0,370,3F0,6,3,,,3FF,3FF03,30FA3,30083,303FF
Data 3F300,C3F0,C570,FFF0,5,4,,,,FF0,C30,E3F,3DA3,3163,3163,3F03,3FF,7,7,,,,FF00
Data C3F0,C03F,CE07,C897,C87F,C3F0,FF00,6,6,,,3FF,3F03,3023,30E3,3163,317F,32F0
Data 30C0,3FC0,9,7,,,,,FFFF,C017,C897,FABB,C897,C017,FFFF,7,6,,,FFFF,D503,D1B3
Data CB03,C23F,F30C,328C,3F0C,3FC,7,6,,,,3FF0,303F,3053,3373,32B3,3C23,C0F,FFC
Data 8,2,,,,FF0,C3F,FC03,C273,CE23,C44F,FF0C,3FC,6,2,,,,,FFFF,C303,C0B3,DA13
Data CDEF,C10C,FFFC,2,3,FFC,3FC0C,30C8C,300BF,37F23,37203,37003,3723F,37F30
Data 30030,3FFF0,6,3,,,,3FFFC,321DC,32FCF,31323,36683,32043,31FFF,3FC00,10,7,,FF
Data 3FFCC3,300FE3,339003,331FEF,339C0C,301CEC,3F100C,30FFC,3FC00,5,10,,,3FFFC0
Data 3005C0,33F5FF,303003,32B0C3,3E3FCF,32000C,303F0C,3FF3FC,5,3,3FC0,30FF,F023
Data C2C3,CC8F,C0BC,FF0C,F0C,D0C,D5C,FFC,3,8,FFFFC,C3C0C,C008C,C0F0F,FC8C3,C803
Data FC3F,3570,3030,30F0,3FC0,9,7,,,,3FFF,3003,3333,3003,FF3F,C2A3,C153,FFFF
Data 10,10,3FF003,3333FF,303003,0,3FF3FF,8030,3FF3FF,0,3FF3FF,307333,FC303
1 Open"x.s"For output As#1:Print#1,"16,8":Do:Read a$:Loop Until a$="s"
For i=1To 8:For j=1To 14:Read a$:b=Len(a$):v$(j)="":If b=1Then:v$(j)=v$(Val(a$))
Else:For k=1To b Step 2:n=Val("&h"+Mid$(a$,k,1)):r$=Mid$(a$,k+1,1):For l=1To n
v$(j)=v$(j)+r$:Next l,k:EndIf:Print#1,v$(j)+"  ":Next j:Print#1,Spc(16)
Print#1,Spc(16):Next i:Close#1:Restore:Return:Data s,E0,1,1,1,1,1,1,1,1,1,1,1,1
Data 1,E0,1,1,3016601630,4016401640,5016201650,602660,7,6,5,4,1,1,1,2210821022
Data 1,E0,1,1,1,1,1,1,1,1,3,1,1,4410441044,1,E0,14104410441024,4,3,1,1,3,4,4,3
Data 1,1,2730443027,2720642027,2710841027,27102445241027,271014154415141027
Data 27111564151127,2711841127,7,7,10171184111710,1031643110,2031443120,308130
Data 406140,406140,308130,2031443120,1031643110,10171184111710,2711841127,6,6
Data 27111564151127,271014154415141027,27102445241027,2710841027,2720642027
Data 2730443027,9750,A71130,507120,203415443110,1034156431,34158421,6,6,6,5,4,3
Data 2,1,5097,3011A7,207150,103144153420,3164153410,21841534,6,6,6,5,4,3,2,1
