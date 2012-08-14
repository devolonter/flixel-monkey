Strict

Import flixel.flxg
Import flixel.flxsound
Import flixel.system.tweens.flxtween
Import flixel.system.tweens.util.ease

Class SfxFader Extends FlxTween Implements FlxTweenListener

Private
	Field _sfx:FlxSound

	Field _start:Float
	
	Field _range:Float
	
	Field _crossSfx:FlxSound
	
	Field _crossRange:Float
	
	Field _complete:FlxTweenListener
	
Public
	Method New(sfx:FlxSound, complete:FlxTweenListener = Null, type:Int = -1)
		Super.New(0, type, Self)
		_complete = complete
		_sfx = sfx
	End Method
	
	Method Destroy:Void()
		_sfx = Null
		_crossSfx = Null
		_complete = Null
		Super.Destroy()
	End Method
	
	Method FadeTo:Void(volume:Float, duration:Float, ease:FlxEaseFunction = Null)
		if (volume < 0) volume = 0
		_start = _sfx.Volume
		_range = volume - _start
		_target = duration
		_ease = ease
		Start()
	End Method
	
	Method CrossFade:Void(play:FlxSound, loop:Bool, duration:Float, volume:Float = 1, ease:FlxEaseFunction = Null)
		_crossSfx = play
		_crossRange = volume
		_start = _sfx.Volume
		_range = -_start
		_target = duration
		_ease = ease
		_crossSfx.Load(_crossSfx.name, loop, False, True)
		_crossSfx.Volume = 0
		_crossSfx.Play()
		Start()
	End Method
	
	Method Update:Void()
		Super.Update()
		If (_sfx <> Null) _sfx.Volume = _start + _range * _t
		If (_crossSfx <> Null) _crossSfx.Volume = _crossRange * _t
	End Method
	
	Method OnTweenComplete:Void()
		If (_crossSfx <> Null) Then
			If (_sfx <> Null) _sfx.Stop()
			_sfx = _crossSfx
			_crossSfx = Null
		End If
		
		If (_complete <> Null) _complete.OnTweenComplete()
	End Method

End Class