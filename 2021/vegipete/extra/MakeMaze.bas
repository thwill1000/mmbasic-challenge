' MakeMaze
' Generate encoded mazes for One-Page-Wonder maze
'
cls
size = 5
MAXSIZE = 29   ' max 30 x 30
sx = 1 : sy = 1 : sindex = sy*30+sx
ex = 3 : ey = 3 : eindex = ey*30+ex

dim maze(MAXSIZE,MAXSIZE)
DrawMaze

do
  update = 0
  kk = asc(ucase$(INKEY$)) ' grab any key press
  select case kk
    case 128  ' UP arrow
      y = y - (y>0)
    case 129  ' DOWN arrow
      y = y + (y<size-1)
    case 130  ' LEFT arrow
      x = x - (x>0)
    case 131  ' RIGHT arrow
      x = x + (x<size-1)
    case  32  ' SPACE bar
      maze(x,y) = (maze(x,y) = 0) ' toggle this cell
    case  65  ' A   increase size
      size = size + (size<MAXSIZE)
    case  83  ' S   start
      sx = x : sy = y : sindex = sy*30+sx
    case  88  ' X   exit
      ex = x : ey = y : eindex = ey*30+ex
    case  90  ' Z   decrease size
      size = size - (size>5)
  end select
  if kk then DrawMaze
  pause 20
loop

end

sub DrawMaze
  local i,j
  for j = 0 to 27
    for i = 0 to 27
      if i=sx and j=sy then
        text 100+i*12,100+j*12,chr$(152),CT
      elseif i=ex and j=ey then
        text 100+i*12,100+j*12,chr$(165),CT
      elseif i=x and j=y then
        if maze(i,j) then
          text 100+i*12,100+j*12,chr$(130),CT
        else
          text 100+i*12,100+j*12,chr$(131),CT
        endif
      else
        if maze(i,j) then
          text 100+i*12,100+j*12,chr$(178),CT '"X",CM
        else
          text 100+i*12,100+j*12,chr$(250),CT
        endif
      endif
    next i
  next j
  text 100,15,"Size:  "+str$(size)+" "
  text 100,30,"Byte:  "+str$((size+5)\6)
  text 100,45,"Start: ("+str$(sx)+","+str$(sy)+") "+str$(sindex)+"   "
  text 100,60,"End:   ("+str$(ex)+","+str$(ey)+") "+str$(eindex)+"   "
  text 200,96,"    ("+str$(x)+","+str$(y)+") "+str$(y*30+x)+"    ",CB

  mz$ = ""
  for j = 0 to size-1
    mzrow$ = ""
    for i = 0 to (size+5)\6-1  ' up to 5 characters per row
      tot = 0
      for k = 0 to 5  ' 6 bits per character
        tot = (tot>>1) + 32*maze(i*6+k,j)
      next k
      mzrow$ = chr$(tot+40) + mzrow$  ' build row of encoded maze backwards
      '? chr$(tot+40);
      'text 450+12*i,100+j*12,chr$(tot+40)
    next i
    mz$ = mz$ + mzrow$
  next j
  mz$ = "data "+str$(sindex)+","+str$(eindex)+","+str$((size+5)\6)+","+chr$(34)+mz$+chr$(34)
  ? @(0,0) mz$ space$(100-len(mz$))

end sub
