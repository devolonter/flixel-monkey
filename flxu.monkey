Strict

Import mojo.app
Import flxpoint
Import flxg

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
	
	Function GetRGBA:Float[](color:Int, resluts:Float[] = [])
		If (resluts.Length <> 4) resluts = resluts.Resize(4)
		
		resluts[0] = (color Shr 16) & $FF
		resluts[1] = (color Shr 8) & $FF
		resluts[2] = color & $FF
		resluts[3] = Float((color Shr 24) & $FF) / 255
		Return resluts
	End Function
	
	Function ComputeVelocity:Float(velocity:Float, acceleration:Float = 0, drag:Float = 0, max:Float = 10000)
		If (acceleration <> 0) Then
			velocity += acceleration * FlxG.elapsed
						
		ElseIf (drag <> 0) Then
			drag *= FlxG.elapsed
			
			If (velocity - drag > 0) Then
				velocity -= drag			
			ElseIf (velocity + drag < 0) Then
				velocity += drag			
			Else
				velocity = 0
			End If
		End If
		
		If (velocity <> 0 And max <> 10000) Then
			If (velocity > max) Then
				velocity = max
			ElseIf (velocity < -max) Then
				velocity = -max	
			End If
		End If
		
		Return velocity
	End Function
	
	Function RotatePoint:FlxPoint(x:Float, y:Float, pivotX:Float, pivotY:Float, angle:Float, point:FlxPoint = Null)
		Local sin:Float = 0
		Local cos:Float = 0
		Local radians:Float = angle * -0.017453293
		
		While (radians < -PI)
			radians += TWOPI	
		Wend
		
		While (radians > PI)
			radians = radians - TWOPI
		Wend
		
		If (radians < 0) Then
			sin =  1.27323954 * radians + .405284735 * radians * radians
			If (sin < 0) Then
				sin = .225 * (sin * -sin - sin) + sin
			Else
				sin = .225 * (sin * sin - sin) + sin	
			End If
		Else
			sin = 1.27323954 * radians - 0.405284735 * radians * radians
			If (sin < 0) Then
				sin = .225 * (sin * -sin - sin) + sin
			Else
				sin = .225 * (sin * sin - sin) + sin		
			End If
		End If
		
		radians += HALFPI		
		If (radians > PI) radians -= TWOPI
		
		If (radians < 0) Then
			cos = 1.27323954 * radians + 0.405284735 * radians * radians
			If (cos < 0) Then
				cos = .225 * (cos * -cos - cos) + cos
			Else
				cos = .225 * (cos * cos - cos) + cos			
			End If
		Else
			cos = 1.27323954 * radians - 0.405284735 * radians * radians
			If (cos < 0) Then
				cos = .225 * (cos * -cos - cos) + cos
			Else
				cos = .225 * (cos * cos - cos) + cos					
			End If
		End If
		
		Local dx:Float = x - pivotX
		Local dy:Float = pivotY + y
		
		If (point = Null) point = New FlxPoint()
		point.x = pivotX + cos * dx - sin * dy
		point.y = pivotY - sin * dx - cos * dy
		
		Return point
	End Function
	
	Function GetAngle:Float(point1:FlxPoint, point2:FlxPoint)
		Local x:Float = point2.x - point1.x
		Local y:Float = point2.y - point1.y
		
		If (x = 0 And y = 0) Return 0
		
		Local c1:Float = PI * .25
		Local c2:Float = 3 * c1		
		Local ay:Float = Abs(y)
		Local angle:Float = 0
		
		If (x >= 0) Then
			angle = c1 - c1 * ((x - ay) / (x + ay))
		Else
			angle = c2 - c1 * ((x + ay) / (ay - x))	
		End If
		
		If (y < 0) Then
			angle =	-angle * 57.2957796
		Else
			angle =	angle * 57.2957796
		End If
		
		If (angle > 90) Then
			angle = angle - 270
		Else
			angle += 90			
		End If
		
		Return angle
	End Function

End Class