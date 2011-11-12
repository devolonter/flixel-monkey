Strict

Import mojo

Class Color	

	Field r:Float
	Field g:Float
	Field b:Float
	Field a:Float
	Field integer:Int 
	
	Method New (color:Int)
		r = (color Shr 16) & $FF
		g = (color Shr 8) & $FF
		b = color & $FF
		a = Float((color Shr 24) & $FF) / 255
		integer = color
	End Method
	
	Function SetColor:Void(color:Color)
		graphics.SetColor(color.r, color.g, color.b)
		graphics.SetAlpha(color.a)
	End Function
	
	Function Cls:Void(color:Color)
		graphics.Cls(color.r, color.g, color.b)
	End Function

End Class