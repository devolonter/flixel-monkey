Strict

Import mojo

Import flxextern
Import flxpoint
Import flxg

Alias MonkeyAbs = monkey.math.Abs
Alias MonkeyFloor = monkey.math.Floor
Alias MonkeyCeil = monkey.math.Ceil
Alias MonkeyMin = monkey.math.Min
Alias MonkeyMax = monkey.math.Max
Alias NativeOpenURL = flxextern.OpenURL

Class FlxU

	Function OpenURL:Void(url:String)
		NativeOpenURL(url)
	End Function

	Function Abs:Float(value:Float)
		Return MonkeyAbs(value)		
	End Function
	
	Function Floor:Float(value:Float)
		Return MonkeyFloor(value)
	End Function
	
	Function Ceil:Float(value:Float)
		Return MonkeyCeil(value)
	End Function
	
	Function Round:Float(value:Float)		
		If (value > 0) Then
			Return Int(value + .5)
		Else
			Return Int(value - .5)
		End If
	End Function
	
	Function Min:Float(number1:Float, number2:Float)
		Return MonkeyMin(number1, number2)
	End Function
	
	Function Max:Float(number1:Float, number2:Float)
		Return MonkeyMax(number1, number2)
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
		If (resluts.Length() <> 4) resluts = resluts.Resize(4)
		
		resluts[0] = (color Shr 16) & $FF
		resluts[1] = (color Shr 8) & $FF
		resluts[2] = color & $FF
		resluts[3] = Float((color Shr 24) & $FF) / 255
		Return resluts
	End Function
	
	Function GetHSB:Float[](color:Int, resluts:Float[] = [])
		If (resluts.Length() <> 4) resluts = resluts.Resize(4)
		
		Local red:Float = Float((color Shr 16) & $FF) / 255
		Local green:Float = Float((color Shr 8) & $FF) / 255
		Local blue:Float = Float(color & $FF) / 255
		
		Local m:Float = MonkeyMax(red, green)
		Local dmax:Float = MonkeyMax(m, blue)
		m = MonkeyMin(red, green)
		Local dmin:Float = MonkeyMin(m, blue)
		Local range:Float = dmax - dmin
		
		resluts[2] = dmax
		resluts[1] = 0
		resluts[0] = 0
		
		If (dmax <> 0) resluts[1] = range / dmax
		
		If (resluts[1] <> 0) Then
			If (red = dmax) Then
				resluts[0] = (green - blue) / range
			
			ElseIf (green = dmax) Then
				resluts[0] = 2 + (blue - red) / range
				
			ElseIf (blue = dmax) Then
				resluts[0] = 4 + (red - green) / range
			End If
			
			resluts[0] *= 60			
			If (resluts[0] < 0) resluts[0] += 360
		End If
		
		resluts[3] = Float((color Shr 24) & $FF) / 255
		
		Return resluts
	End Function
	
	Function FromatTime:String(seconds:Float, showMS:Bool = False)
		Local timeString:StringStack = New StringStack()
		timeString.Push(Int(seconds / 60) + ":")
		
		Local timeStringHepler:Int = Int(seconds) Mod 60
		
		If (timeStringHepler < 10) Then
			timeString.Push("0")
		End If
		
		timeString.Push(timeStringHepler)
		
		If (showMS) Then
			timeString.Push(".")
			timeStringHepler = (seconds - Int(seconds)) * 100
			
			If (timeStringHepler < 10) Then
				timeString.Push("0")
			End If
			
			timeString.Push(timeStringHepler)
		End If
		
		Return timeString.Join("")
	End Function
	
	Function FromatMoney:String(amount:Float, showDecimal:Bool = True, englishStyle:Bool = True)
		Local helper:Int
		Local intAmount:Int = amount
		Local comma:String = ""
		Local result:String = ""
		Local zeroes:String = ""
		
		While (intAmount > 0)
			If (result.Length() > 0 And comma.Length() <= 0) Then
				If (englishStyle) Then
					comma = ","
				Else
					comma = "."
				End If
			End If
			
			helper = intAmount - Int(intAmount / 1000) * 1000
			intAmount /= 1000
			
			zeroes = ""
			
			If (intAmount > 0) Then
				If (helper < 100) Then
					zeroes = "0"
				End If
				
				If (helper < 10) Then
					zeroes = "00"
				End If
			End If
			
			result = zeroes + helper + comma + result
		Wend
		
		If (showDecimal) Then
			intAmount = Int(amount * 100) - (Int(amount) * 100)
			
			If (englishStyle) Then
				result += "." + intAmount
			Else
				result += "," + intAmount
			End If
			
			If (amount < 10) Then
				result += "0"
			End If
		End If
		
		Return result
	End Function
	
	Function ComputeVelocity:Float(velocity:Float, acceleration:Float = 0, drag:Float = 0, max:Float = 10000)
		If (acceleration <> 0) Then
			velocity += acceleration * FlxG.Elapsed
						
		ElseIf (drag <> 0) Then
			drag *= FlxG.Elapsed
			
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
		Local ay:Float = MonkeyAbs(y)
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
	
	Function GetDistance:Float(point1:FlxPoint, point2:FlxPoint)
		Local dx:Float = point1.x - point2.x
		Local dy:Float = point1.y - point2.y
		
		Return Sqrt(dx * dx + dy * dy)
	End Function
	
	Function GetDistance:Float(x1:Float, y1:Float, x2:Float, y2:Float)
		Local dx:Float = x1 - x2
		Local dy:Float = y1 - y2
		
		Return Sqrt(dx * dx + dy * dy)
	End Function

End Class