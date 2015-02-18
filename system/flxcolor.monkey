Strict

Class FlxColor	

Public
	Field r:Float
	Field g:Float
	Field b:Float
	Field a:Float
	Field argb:Int
	
Private
	Global _Color:FlxColor = New FlxColor()
	
	Global _HexTransform:IntMap<Int>
	
Public
	Method New (argb:Int = $FFFFFFFF)
		_ParseARGB(argb)
	End Method
	
	Method SetARGB:Void(argb:Int)
		_ParseARGB(argb)		
	End Method
	
	Method SetARGB:Void(a:Float, r:Int, g:Int, b:Int)
		Self.a = a
		Self.r = r
		Self.g = g
		Self.b = b
		
		Self.argb = (a * 255 Shl 24) | (int(r) Shl 16) | (int(g) Shl 8) | int(b)
	End Method
	
	Method SetRGB:Void(rgb:Int)
		r = (rgb Shr 16) & $FF
		g = (rgb Shr 8) & $FF
		b = rgb & $FF		
		a = 1
		
		Self.argb = rgb | ($FF Shl 24)		
	End Method
	
	Method SetRGB:Void(a:Float, r:Int, g:Int, b:Int)
		SetARGB(1, r, g, b)
	End Method
	
	Method MixRGB:Void(fore:FlxColor)
		r = (r * fore.r) / 255.0
		g = (g * fore.g) / 255.0
		b = (b * fore.b) / 255.0
		a = 1
		
		Self.argb = ($FF Shl 24) | (int(r) Shl 16) | (int(g) Shl 8) | int(b)
	End Method
	
	Method MixRGB:Void(back:FlxColor, fore:FlxColor)
		r = (back.r * fore.r) / 255.0
		g = (back.g * fore.g) / 255.0
		b = (back.b * fore.b) / 255.0
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
	
	Function ARGB:Int(argb:Int = $FFFFFFFF, result:FlxColor = Null)
		If (result = Null) result = _Color
		result._ParseARGB(argb)
		Return result.argb
	End Function
	
	Function RGB:Int(rgb:Int = $FFFFFF, result:FlxColor = Null)
		If (result = Null) result = _Color
		result.SetRGB(rgb)
		Return result.argb
	End Function
	
	Function FromString:Int(stringColor:String, result:FlxColor = Null)
		If (result = Null) result = _Color
		If (stringColor.Length() = 0) Return result.argb
	
		If (stringColor.StartsWith("$") Or stringColor.StartsWith("#")) Then
			If (_HexTransform = Null) _InitHextTransform()
			Local value:Int = 0
			Local product:Int = 1
			Local l:Int = stringColor.Length() -1

			For Local i:Int = l To 1 Step - 1
				value += _HexTransform.Get(stringColor[i]) * product
				product *= 16
			Next
			
			If (product = 16777216) Then
				result.SetRGB(value)
			Else
				result.SetARGB(value)
			End If
		ElseIf(stringColor.StartsWith("argb")) Then
			Local colors:String[] = stringColor[stringColor.Find("(") + 1 .. stringColor.Find(")")].Split(",")
			If (colors.Length() <> 4) Return result.argb
			
			Local alpha:Float
			
			If (colors[0].Find(".") >= 0) Then
				alpha = Float(colors[0].Trim())
			Else
				alpha = Int(colors[0].Trim()) / 255.0
			End If
			
			result.SetARGB(alpha, Int(colors[1].Trim()), Int(colors[2].Trim()), Int(colors[3].Trim()))
			
		ElseIf(stringColor.StartsWith("rgb")) Then
			Local colors:String[] = stringColor[stringColor.Find("(") + 1 .. stringColor.Find(")")].Split(",")
			If (colors.Length() <> 3) Return result.argb
			
			result.SetARGB(1, Int(colors[0].Trim()), Int(colors[1].Trim()), Int(colors[2].Trim()))
		End If
		
		Return result.argb
	End Function
	
Private
	Method _ParseARGB:Void(argb:Int)
		r = (argb Shr 16) & $FF
		g = (argb Shr 8) & $FF
		b = argb & $FF
		a = Float((argb Shr 24) & $FF) / 255
		Self.argb = argb	
	End Method
	
	Function _InitHextTransform:Void()
		_HexTransform = New IntMap<Int>()
		
		Local value:Int = 0
				
		For Local i:Int = 48 To 57
			_HexTransform.Set(i, value)
			value += 1
		Next
		
		For Local i:Int = 65 To 70
			_HexTransform.Set(i, value)
			value += 1
		Next
		
		value -= 6
		
		For Local i:Int = 97 To 102
			_HexTransform.Set(i, value)
			value += 1
		Next
	End Function

End Class
