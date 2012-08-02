Strict

Import flixel.system.tweens.flxtween

Class Alarm Extends FlxTween

	Method New(duration:Float, complete:FlxTweenListener = Null, type:Int = FlxTween.ONESHOT)
		Super.New(duration, type, complete, Null)
	End Method
	
	Method Reset:Void()
		_target = Duration
		Start()
	End Method
	
	Method Elapsed:Float() Property
		Return _time
	End Method
	
	Method Duration:Float() Property
		Return _target
	End Method
	
	Method Remaining:Float() Property
		Return _target - _time
	End Method

End Class