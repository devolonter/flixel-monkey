Strict

Import flixel.system.tweens.flxtween
Import flixel.system.tweens.util.ease
Import flixel.system.flxarray

Class AngleTween Extends FlxTween

	Field angle:Float
	
Private
	Field _start:Float
	
	Field _range:Float
	
Public
	Method New(complete:FlxTweenListener = Null, type:Int = FlxTween.ONESHOT)
		Super.New(0, type, complete)
		angle = 0
	End Method
	
	Method Tween:Void(fromAngle:Float, toAngle:Float, duration:Float, ease:FlxEaseFunction = Null)
		_start = fromAngle
		angle = fromAngle
		
		Local d:Float = toAngle - angle
		Local a:Float = Abs(d)
		
		If (a > 181) Then
			If (d > 0) Then
				_range = - (360 - a)
			Else
				_range = 360 - a
			End If
		ElseIf(a < 179) Then
			_range = d
		Else
			_range = FlxArray<Int>.GetRandom([180, -180])
		End If
		
		_target = duration
		_ease = ease
		Start()
	End Method
	
	Method Update:Void()
		Super.Update()
		angle = (_start + _range * _t) Mod 360
		if (angle < 0) angle += 360
	End Method

End Class