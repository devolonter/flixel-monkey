Strict

Import mojo

Class Color	

	Field r:Float = 255
	Field g:Float = 255
	Field b:Float = 255
	Field a:Float = 1
	
	Method New (color:Int)
		r = (color Shr 16) & $FF
		g = (color Shr 8) & $FF
		b = color & $FF
		a = Float((color Shr 24) & $FF) / 255
	End Method
	
	Function SetColor:Void(color:Color)
		graphics.SetColor(color.r, color.g, color.b)
		graphics.SetAlpha(color.a)
	End Function
	
	Function Cls:Void(color:Color)
		graphics.Cls(color.r, color.g, color.b)
	End Function

End Class