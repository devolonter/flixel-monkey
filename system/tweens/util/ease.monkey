Strict

Class Ease
	
	Global QuadIn:FlxEaseFunction = New FlxEaseQuadIn()
	
	Global QuadOut:FlxEaseFunction = New FlxEaseQuadOut()
	
	Global QuadInOut:FlxEaseFunction = New FlxEaseQuadInOut()
	
	Global CubeIn:FlxEaseFunction = New FlxEaseCubeIn()
	
	Global CubeOut:FlxEaseFunction = New FlxEaseCubeOut()
	
	Global CubeInOut:FlxEaseFunction = New FlxEaseCubeInOut()
	
	Global QuartIn:FlxEaseFunction = New FlxEaseQuartIn()
	
	Global QuartOut:FlxEaseFunction = New FlxEaseQuartOut()
	
	Global QuartInOut:FlxEaseFunction = New FlxEaseQuartInOut()
	
	Global QuintIn:FlxEaseFunction = New FlxEaseQuintIn()
	
	Global QuintOut:FlxEaseFunction = New FlxEaseQuintOut()
	
	Global QuintInOut:FlxEaseFunction = New FlxEaseQuintInOut()
	
	Global SineIn:FlxEaseFunction = New FlxEaseSineIn()
	
	Global SineOut:FlxEaseFunction = New FlxEaseSineOut()
	
	Global SineInOut:FlxEaseFunction = New FlxEaseSineInOut()
	
	Global BounceIn:FlxEaseFunction = New FlxEaseBounceIn()
	
	Global BounceOut:FlxEaseFunction = New FlxEaseBounceOut()
	
	Global BounceInOut:FlxEaseFunction = New FlxEaseBounceInOut()
	
	Global CircIn:FlxEaseFunction = New FlxEaseCircIn()
	
	Global CircOut:FlxEaseFunction = New FlxEaseCircOut()
	
	Global CircInOut:FlxEaseFunction = New FlxEaseCircInOut()
	
	Global ExpoIn:FlxEaseFunction = New FlxEaseExpoIn()
	
	Global ExpoOut:FlxEaseFunction = New FlxEaseExpoOut()
	
	Global ExpoInOut:FlxEaseFunction = New FlxEaseExpoInOut()
	
	Global BackIn:FlxEaseFunction = New FlxEaseBackIn()
	
	Global BackOut:FlxEaseFunction = New FlxEaseBackOut()
	
	Global BackInOut:FlxEaseFunction = New FlxEaseBackInOut()

End Class

Interface FlxEaseFunction
	
	Method Ease:Float(t:Float)

End Interface

Private
Const B1:Float = 1 / 2.75
Const B2:Float = 2 / 2.75
Const B3:Float = 1.5 / 2.75
Const B4:Float = 2.5 / 2.75
Const B5:Float = 2.25 / 2.75
Const B6:Float = 2.625 / 2.75

Class FlxEaseQuadIn Implements FlxEaseFunction
	
	Method Ease:Float(t:Float)
		Return t * t
	End Method

End Class

Class FlxEaseQuadOut Implements FlxEaseFunction
	
	Method Ease:Float(t:Float)
		Return -t * (t - 2)
	End Method

End Class

Class FlxEaseQuadInOut Implements FlxEaseFunction
	
	Method Ease:Float(t:Float)
		If (t <= 0.5) Return t * t * 2
		t -= 1
		Return 1 - t * t * 2
	End Method

End Class

Class FlxEaseCubeIn Implements FlxEaseFunction
	
	Method Ease:Float(t:Float)
		Return t * t * t
	End Method

End Class

Class FlxEaseCubeOut Implements FlxEaseFunction
	
	Method Ease:Float(t:Float)
		t -= 1
		Return 1 + t * t * t
	End Method

End Class

Class FlxEaseCubeInOut Implements FlxEaseFunction
	
	Method Ease:Float(t:Float)
		If (t <= 0.5) Return t * t * t * 4
		t -= 1
		Return 1 + t * t * t * 4
	End Method

End Class

Class FlxEaseQuartIn Implements FlxEaseFunction
	
	Method Ease:Float(t:Float)
		Return t * t * t * t
	End Method

End Class

Class FlxEaseQuartOut Implements FlxEaseFunction
	
	Method Ease:Float(t:Float)
		t -= 1
		Return 1 - t * t * t * t
	End Method

End Class

Class FlxEaseQuartInOut Implements FlxEaseFunction
	
	Method Ease:Float(t:Float)
		If (t <= 0.5) Return t * t * t * t * 8
		t = t * 2 - 2
		Return(1 - t * t * t * t) / 2 + 0.5
	End Method

End Class

Class FlxEaseQuintIn Implements FlxEaseFunction
	
	Method Ease:Float(t:Float)
		Return t * t * t * t * t
	End Method

End Class

Class FlxEaseQuintOut Implements FlxEaseFunction
	
	Method Ease:Float(t:Float)
		t -= 1
		Return t * t * t * t * t + 1
	End Method

End Class

Class FlxEaseQuintInOut Implements FlxEaseFunction
	
	Method Ease:Float(t:Float)
		t *= 2
		If (t < 1) Return(t * t * t * t * t) / 2
		t -= 2
		Return(t * t * t * t * t + 2) / 2
	End Method

End Class

Class FlxEaseSineIn Implements FlxEaseFunction
	
	Method Ease:Float(t:Float)
		Return -Cosr(HALFPI * t) + 1
	End Method

End Class

Class FlxEaseSineOut Implements FlxEaseFunction
	
	Method Ease:Float(t:Float)
		Return Sinr(HALFPI * t)
	End Method

End Class

Class FlxEaseSineInOut Implements FlxEaseFunction
	
	Method Ease:Float(t:Float)
		Return -Cosr(PI * t) / 2 + 0.5
	End Method

End Class

Class FlxEaseBounceIn Implements FlxEaseFunction
	
	Method Ease:Float(t:Float)
		t = 1 - t
		If (t < B1) Return 1 - 7.5625 * t * t
		If (t < B2) Return 1 - (7.5625 * (t - B3) * (t - B3) + 0.75)
		If (t < B4) Return 1 - (7.5625 * (t - B5) * (t - B5) + 0.9375)
		Return 1 - (7.5625 * (t - B6) * (t - B6) + 0.984375)
	End Method

End Class

Class FlxEaseBounceOut Implements FlxEaseFunction
	
	Method Ease:Float(t:Float)
		If (t < B1) Return 7.5625 * t * t
		If (t < B2) Return 7.5625 * (t - B3) * (t - B3) + 0.75
		If (t < B4) Return 7.5625 * (t - B5) * (t - B5) + 0.9375
		Return 7.5625 * (t - B6) * (t - B6) + 0.984375
	End Method

End Class

Class FlxEaseBounceInOut Implements FlxEaseFunction
	
	Method Ease:Float(t:Float)
		If (t < 0.5) Then
			t = 1 - t * 2
			If (t < B1) Return(1 - 7.5625 * t * t) / 2
			If (t < B2) Return(1 - (7.5625 * (t - B3) * (t - B3) + 0.75)) / 2
			If (t < B4) Return(1 - (7.5625 * (t - B5) * (t - B5) + 0.9375)) / 2
			Return(1 - (7.5625 * (t - B6) * (t - B6) + 0.984375)) / 2
		End If
	
		t = t * 2 - 1
		If (t < B1) Return(7.5625 * t * t) / 2 + 0.5
		If (t < B2) Return(7.5625 * (t - B3) * (t - B3) + 0.75) / 2 + 0.5
		If (t < B4) Return(7.5625 * (t - B5) * (t - B5) + 0.9375) / 2 + 0.5
		Return(7.5625 * (t - B6) * (t - B6) + 0.984375) / 2 + 0.5
	End Method

End Class

Class FlxEaseCircIn Implements FlxEaseFunction
	
	Method Ease:Float(t:Float)
		Return - (Sqrt(1 - t * t) - 1)
	End Method

End Class

Class FlxEaseCircOut Implements FlxEaseFunction
	
	Method Ease:Float(t:Float)
		Return Sqrt(1 - (t - 1) * (t - 1))
	End Method

End Class

Class FlxEaseCircInOut Implements FlxEaseFunction
	
	Method Ease:Float(t:Float)
		If (t <= 0.5) Return(Sqrt(1 - t * t * 4) - 1) / -2
		Return(Sqrt(1 - (t * 2 - 2) * (t * 2 - 2)) + 1) / 2
	End Method

End Class

Class FlxEaseExpoIn Implements FlxEaseFunction
	
	Method Ease:Float(t:Float)
		Return Pow(2, 10 * (t - 1))
	End Method

End Class

Class FlxEaseExpoOut Implements FlxEaseFunction
	
	Method Ease:Float(t:Float)
		Return -Pow(2, -10 * t) + 1
	End Method

End Class

Class FlxEaseExpoInOut Implements FlxEaseFunction
	
	Method Ease:Float(t:Float)
		If (t < 0.5) Return Pow(2, 10 * (t * 2 - 1)) / 2
		Return(-Pow(2, -10 * (t * 2 - 1)) + 2) / 2
	End Method

End Class

Class FlxEaseBackIn Implements FlxEaseFunction
	
	Method Ease:Float(t:Float)
		Return t * t * (2.70158 * t - 1.70158)
	End Method

End Class

Class FlxEaseBackOut Implements FlxEaseFunction
	
	Method Ease:Float(t:Float)
		t -= 1
		Return 1 - t * t * (-2.70158 * t - 1.70158)
	End Method

End Class

Class FlxEaseBackInOut Implements FlxEaseFunction
	
	Method Ease:Float(t:Float)
		t *= 2
		If (t < 1) Return t * t * (2.70158 * t - 1.70158) / 2
		t -= 2
		Return(1 - t * t * (-2.70158 * t - 1.70158)) / 2 + 0.5
	End Method

End Class