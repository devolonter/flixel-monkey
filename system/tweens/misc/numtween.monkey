Strict

Import flixel.system.tweens.flxtween
Import flixel.system.tweens.util.ease

Class NumTween Extends FlxTween
	
	Field value:Float
	
Private
	Field _start:Float
	
	Field _range:Float
	
Public
	Method New(complete:FlxTweenListener = Null, type:Int = -1)
		Super.New(0, type, complete)
		value = 0
	End Method
	
	Method Tween:Void(fromValue:Float, toValue:Float, duration:Float, ease:FlxEaseFunction)
		value = fromValue
		
		_start = fromValue
		_range = toValue - value
		
		_target = duration
		_ease = ease
		
		Start()
	End Method
	
	Method Update:Void()
		Super.Update()
		value = _start + _range * _t
	End Method

End Class