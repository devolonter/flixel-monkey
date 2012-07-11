
Type TColor

	Field r:Int
	
	Field g:Int
	
	Field b:Int
	
	Method Set(rgb:Int)
		r = (rgb Shr 16) & $FF
		g = (rgb Shr 8) & $FF
		b = rgb & $FF
	End Method

	Method ToString:String()
		Return "" + r + "," + g + "," + b
	End Method

	Method FromString(s$)
		Local p:Int = s.Find(",") + 1
		If Not p Return
		
		Local q:Int = s.Find(",", p) + 1
		If Not q Return
		
		r = Int(s[..p - 1])
		g = Int(s[p..q - 1])
		b = Int(s[q..])
	End Method

	Method Request:Int()
		If RequestColor(r, g, b)
			r = RequestedRed()
			g = RequestedGreen()
			b = RequestedBlue()
			Return True
		EndIf				
	End Method

End Type
