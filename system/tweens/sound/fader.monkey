Strict

Import flixel.flxg
Import flixel.system.tweens.flxtween
Import flixel.system.tweens.util.ease

Class Fader Extends FlxTween

Private
	Field _start:Float
	
	Field _range:Float
	
Public
	Method New(complete:FlxTweenListener = Null, type:Int = -1)
		Super.New(0, type, complete)
	End Method
	
	Method FadeTo:Void(volume:Float, duration:Float, ease:FlxEaseFunction = Null)
		if (volume < 0) volume = 0
		_start = FlxG.Volume()
		_range = volume - _start
		_target = duration
		_ease = ease
		Start()
	End Method
	
	Method Update:Void()
		Super.Update()
		FlxG.Volume(_start + _range * _t)
	End Method

End Class