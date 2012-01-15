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
	
	Method MixARGB:Void(fore:FlxColor)
		r = Ceil((r * fore.a * fore.r) / 255.0)
		g = Ceil((g * fore.a * fore.g) / 255.0)
		b = Ceil((b * fore.a * fore.b) / 255.0)
		a = 1
		
		Self.argb = ($FF Shl 24) | (int(r) Shl 16) | (int(g) Shl 8) | int(b)
	End Method
	
	Method MixARGB:Void(back:FlxColor, fore:FlxColor)
		r = Ceil((back.r * fore.a * fore.r) / 255.0)
		g = Ceil((back.g * fore.a * fore.g) / 255.0)
		b = Ceil((back.b * fore.a * fore.b) / 255.0)
		a = 1
	
		Self.argb = ($FF Shl 24) | (int(r) Shl 16) | (int(g) Shl 8) | int(b)
	End Method
	
	Method FromColor:FlxColor(color:FlxColor)
		r = color.r
		g = color.g
		b = color.b
		a = color.a
		argb = color.argb
		
		Return Self
	End Method
	
	Function ARGB:FlxColor(argb:Int = $FFFFFFFF)
		Return New FlxColor(argb)
	End Function
	
	Function RGB:FlxColor(rgb:Int = $FFFFFF)
		Local color:FlxColor = New FlxColor()
		color.SetRGB(rgb)
		Return color
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