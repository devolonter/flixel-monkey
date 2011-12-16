Strict

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

End Class