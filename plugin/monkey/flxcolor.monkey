Strict

Import mojo

Class FlxColor	

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
	
	Method SetRGB:Void(rgb:Int)
		r = (rgb Shr 16) & $FF
		g = (rgb Shr 8) & $FF
		b = rgb & $FF		
		a = 1
		
		Self.argb = ($FF Shl 24) + (rgb & $00FFFFFF)		
	End Method
	
	Function ARGB:FlxColor(argb:Int = $FFFFFFFF)
		Return New FlxColor(argb)
	End Function
	
	Function RGB:FlxColor(rgb:Int = $FFFFFF)
		Local color:FlxColor = New FlxColor()
		color.SetRGB(rgb)
		Return color
	End Function
	
	Function SetColor:Void(color:FlxColor)
		graphics.SetColor(FlxColor.r, FlxColor.g, FlxColor.b)
		graphics.SetAlpha(FlxColor.a)
	End Function
	
	Function Cls:Void(color:FlxColor)
		graphics.Cls(FlxColor.r, FlxColor.g, FlxColor.b)
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