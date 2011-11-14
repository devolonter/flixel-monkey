Strict

Import mojo

Class Color	

Public
	Field r:Float
	Field g:Float
	Field b:Float
	Field a:Float
	Field argb:Int 
	
	Method New (argb:Int = $FFFFFFFF)
		_parseARGB(argb)
	End Method
	
	Method SetARGB:Void(argb:Int)
		_parseARGB(argb)		
	End Method
	
	Function ARGB:Color(argb:Int = $FFFFFFFF)
		Return New Color(argb)
	End Function
	
	Function SetColor:Void(color:Color)
		graphics.SetColor(color.r, color.g, color.b)
		graphics.SetAlpha(color.a)
	End Function
	
	Function Cls:Void(color:Color)
		graphics.Cls(color.r, color.g, color.b)
	End Function
	
Private
	Method _parseARGB:Void(argb:Int)	
		r = (argb Shr 16) & $FF
		g = (argb Shr 8) & $FF
		b = argb & $FF
		a = Float((argb Shr 24) & $FF) / 255
		Self.argb = argb	
	End Method

End Class