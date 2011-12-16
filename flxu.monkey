Strict

Import mojo.app

Class FlxU

	Function Abs:Float(value:Float)
		Return monkey.math.Abs(value)		
	End Function
	
	Function Floor:Float(value:Float)
		Return monkey.math.Floor(value)
	End Function
	
	Function Ceil:Float(value:Float)
		Return monkey.math.Ceil(value)
	End Function
	
	Function Round:Float(value:Float)		
		If (value > 0) Then
			Return Int(value + .5)
		Else
			Return Int(value - .5)
		End If
	End Function
	
	Function Min:Float(number1:Float, number2:Float)
		Return monkey.math.Min(number1, number2)
	End Function
	
	Function Max:Float(number1:Float, number2:Float)
		Return monkey.math.Max(number1, number2)
	End Function
	
	Function Bound:Float(value:Float, min:Float, max:Float)
		Return Clamp(value, min, max)
	End Function
	
	Function Srand:Float(seed:Float)
		Return Float(seed Shr 8 & $ffffff)/$1000000
	End Function
	
	#Rem
	Function Shuffle:Object[](objects:Object[], howManyTimes:Int)
		Shuffle is not currently supported in Monkey. Use FlxArray.Shuffle method
	End Function
	#End
	
	#Rem	
	Function GetRandom:FlxBasic(objects:FlxBasic[], startIndex:Int = 0, length:Int = 0)
		GetRandom is not currently supported in Monkey. Use FlxArray.GetRandom method
	End Function
	#End
	
	Function GetTicks:Int()
		Return Millisecs()
	End Function
	
	Function FormatTicks:String(startTicks:Int, endTicks:Int)
		Return ((endTicks - startTicks) / 1000) + "s"
	End Function
	
	Function MakeColor:Int(red:Int, green:Int, blue:Int, alpha:Float = 1)
		If (alpha <= 1) alpha *= 255
		Return (alpha & $FF) Shl 24 | (red & $FF) Shl 16 | (green & $FF) Shl 8 | (blue & $FF)
	End Function
	
	Function MakeColorFromHSB:Int(hue:Float, saturation:Float, brightness:Float, alpha:Float = 1)
		Local red:Float
		Local green:Float
		Local blue:Float
		
		If (saturation = 0)
			red = brightness
			green = brightness
			blue = brightness
		Else
			If (hue = 360) hue = 0
			
			Local slice:Int = hue / 60
			Local hf:Float = hue / 60 - slice
			Local aa:Float = brightness * (1 - saturation)
			Local bb:Float = brightness * (1 - saturation * hf)
			Local cc:Float = brightness * (1 - saturation * (1.0 - hf))
			
			Select (slice)
				Case 0
					red = brightness
					green = cc
					blue = aa
				
				Case 1
					red = bb
					green = brightness
					blue = aa
					
				Case 2
					red = aa
					green = brightness
					blue = cc
					
				Case 3
					red = aa
					green = bb
					blue = brightness
					
				Case 4
					red = cc
					green = aa
					blue = brightness
					
				Case 5
					red = brightness
					green = aa
					blue = bb
					
				Default
					red = 0
					green = 0
					blue = 0				
			End Select			
		End If
		
		If (alpha <= 1) alpha *= 255
		Return (alpha & $FF) Shl 24 | int(red * 255) Shl 16 | int(green * 255) Shl 8 | int(blue * 255)
	End Function

End Class