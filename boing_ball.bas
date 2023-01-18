

#Include "bola.bi"


Dim Shared As Integer x_pos=0
Dim Shared As Integer y_pos=0
Dim Shared As Integer x_scroll=1
Dim Shared As Integer y_scroll=-1
Dim Shared As Integer adjusted_y_scroll

Dim Shared As Integer color_cycle=2 


Dim As Integer x,y
Dim As Integer a,b,c,d,e,f,g,h
Dim As Integer p1,p2,p3,p4
Dim As Integer o1,o2,o3,o4

ScreenRes 340,240,8,2
	
	
	Dim As Integer ColorTable(31) ' reserva 32 colores, pero solo se usan 16
	
	Palette 0,RGB(&hf0,&hf0,&hf0) ' fondo blanco
	Palette 1,RGB(&ha0,&h0,&ha0)  ' rejilla magenta

	Palette 16,RGB(&h60,&h60,&h60) ' sombra gris

	ScreenSet 1,0
	
	
While 1	


	Cls


	' -----------------------------------------------------
	' dibuja la rejilla de fondo
	for f=0 To 15      
	 'lineas verticales de la pared del fondo
	  for g=48 To 299 Step 16       
	    Line (g,0)-(g,192),1
	  Next
	 
	 'lineas horozontales de la pared del fondo
	  for g=0 To 199 Step 16      
	    Line (48,g)-(288,g),1
	  Next
	 
	 ' lineas verticales en perspectiva del suelo
	  h=20
	  for g=48 To 299 Step 16         
	    Line (g,192)-(h,215),1
	    h+=20
	  Next
	 
	 ' lineas horizontales del suelo
	  Line (45,194)-(291,194),1
	  Line (41,197)-(295,197),1
	  Line (37,201)-(300,201),1
	  Line (30,207)-(308,207),1
	  Line (20,215)-(319,215),1
	Next



	' -----------------------------------------------------
   ' bola de 144x100 (9 words * 100 lines * 4bpp)
	x=150:y=50 ' posicion inicial de la bola
	For a=0 To 99
		For b=0 To 8 ' 9 grupos de 2 bytes de pixeles horizontal (144 pixels total)
			p1=aa(b+(a*9)+(0*900)) ' 900=100 lineas * 9 palabras
			p2=aa(b+(a*9)+(1*900))
			p3=aa(b+(a*9)+(2*900))
			p4=aa(b+(a*9)+(3*900))
			For c=15 To 0 Step -1
				o1=(p1 Shr c) And 1
				o2=(p2 Shr c) And 1
				o3=(p3 Shr c) And 1
				o4=(p4 Shr c) And 1
				e=(o4 Shl 3)+(o3 Shl 2)+(o2 Shl 1)+o1
				' la sombra es ligeramente distinta al fondo, para poder apreciarla
				' ademas, se respeta la regilla magenta, paa dar sensacion de profundidad
				If e=1 Then
					If Point(x+(x_pos+50)-100,(y-(y_pos+50)))=1 Then e=1 Else e=16
				EndIf
				' el fondo no se dibuja
				If e<>0 Then PSet (x+(x_pos+50)-100,(y-(y_pos+50))),e
				x=x+1
			Next
		Next
		y=y+1
		x=150 ' restaura la X de la bola a la posicion inicial
	Next

		
		
	' -----------------------------------------------------
		' alterna la paleta rojo/blanco de la bola
	    if (x_scroll>0) Then 
	      color_cycle-=1  
	    Else
	      color_cycle+=1 
  	    EndIf
	  
	    if (color_cycle=-1) Then 
	      color_cycle=13 
	    ElseIf (color_cycle=14) Then 	
	        color_cycle=0
	    EndIf
	  
	    'color blanco de la bola
	    for f=0 To 6      
	      if ((color_cycle+f)<14) Then 
	        ColorTable(color_cycle+f+ 2)=&hFFFFFF
	        ColorTable(color_cycle+f+18)=&hFFFFFF
	      Else
	        ColorTable(color_cycle+f-12)=&hFFFFFF 
	        ColorTable(color_cycle+f+ 4)=&hFFFFFF 
	      EndIf
	    Next
	 
	    ' color rojo de la bola
	    for f=7 To 13        
	      if ((color_cycle+f)<14) Then 
	        ColorTable(color_cycle+f+ 2)=&h0000FF 
	        ColorTable(color_cycle+f+18)=&h0000FF  
	      Else
	        ColorTable(color_cycle+f-12)=&h0000FF 
	        ColorTable(color_cycle+f+ 4)=&h0000FF 
	      EndIf
	    Next
	 
	 
	 
	' -----------------------------------------------------	 
	   ' mueve la bola por la pantalla (incluye "rebotes")
	    x_pos+=x_scroll  
	    
	    if (x_pos<=-95 Or x_pos>=95) Then 
	      x_scroll=-x_scroll
	    EndIf
	    
	    adjusted_y_scroll=y_scroll 
	    
	    if (y_pos>-10) Then 
	      adjusted_y_scroll*=1 
	    Else
	      if (y_pos>-30) Then 
	        adjusted_y_scroll*=2
	      Else
	        if (y_pos>-60) Then 
	          adjusted_y_scroll*=3
	        Else
	          adjusted_y_scroll*=4
	        End If
	      End If
	    EndIf
	  
	    y_pos+=adjusted_y_scroll 
	    if (y_pos<=-100 Or y_pos>=0) Then  y_scroll=-y_scroll 
	 
	 
	' -----------------------------------------------------	 
	 ' rotacion de la paleta rojo/blanco de la bola
	 ' colores 0-1 y 16-17 no se utilizan
	 For e=2 To 15
	 	Palette e,ColorTable(e)
	 Next
	 
	 'Sleep 20
	
	ScreenSync
	ScreenCopy
	
	If InKey<>"" Then end
	
Wend	
	
