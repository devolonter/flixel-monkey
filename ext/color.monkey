Strict

Import mojo

Class Color	

	Field r:Float
	Field g:Float
	Field b:Float
	Field a:Float
	Field hex:Int 
	
	Method New (color:Int)
		_parseColor(color)
	End Method
	
	Method Hex:Void(color:Int) Property
		_parseColor(color)		
	End Method
	
	Function FromInt:Color(color:Int)
		Return new Color(color)	 
	End Function
	
	Function SetColor:Void(color:Color)
		graphics.SetColor(color.r, color.g, color.b)
		graphics.SetAlpha(color.a)
	End Function
	
	Function Cls:Void(color:Color)
		graphics.Cls(color.r, color.g, color.b)
	End Function
	
Private
	Method _parseColor:Void(color:Int)
		r = (color Shr 16) & $FF
		g = (color Shr 8) & $FF
		b = color & $FF
		a = Float((color Shr 24) & $FF) / 255
		hex = color	
	End Method

End Class