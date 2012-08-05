Strict

Import flixel.flxbasic
Import flixel.flxg
Import util.ease

Class FlxTween

	Const PERSIST:Int = 1
	
	Const LOOPING:Int = 2
	
	Const TOANDFRO:Int = 4
	
	Const ONESHOT:Int = 8
	
	Const BACKWARD:Int = 16
	
	Field active:Bool
	
	Field complete:FlxTweenListener
	
	Field _parent:FlxBasic
	
	Field _finish:Bool
	
	Field _target:Float
	
	Field _ease:FlxEaseFunction

	Field _type:Int
	
	Field _t:Float
	
	Field _time:Float
	
	Field _backward:Bool
	
	Field _times:Int

Public
	Method New(duration:Float, type:Int = -1, complete:FlxTweenListener = Null, ease:FlxEaseFunction = Null)
		_target = duration
		
		_type = type
		If (_type < 0) _type = FlxTween.PERSIST
		
		Self.complete = complete
		_ease = ease
		_t = 0
		
		_backward = Bool(type & BACKWARD)
	End Method
	
	Method Destroy:Void()
		complete = Null
		_parent = Null
		_ease = Null
	End Method
	
	Method Update:Void()
		_time += FlxG.Elapsed
		_t = _time / _target
		
		If (_ease <> Null) _t = _ease.Ease(_t)
		If (_backward) _t = 1 - _t
		
		If (_time >= _target) Then
			If ( Not _backward) Then
				_t = 1
			Else
				_t = 0
			End If
			_finish = True
		End If
	End Method
	
	Method Start:Void()
		_time = 0
				
		If (_target = 0) Then
			active = False
			Return
		End If
		
		active = True
	End Method
	
	Method Finish:Void()
		Select( (_type & ~ BACKWARD))
			Case PERSIST
				_time = _target
				active = False
				
			Case LOOPING
				_time Mod = _target
				_t = _time / _target
				
				If (_ease <> Null And _t > 0 And _t < 1) Then
					_t = _ease.Ease(_t)
				End If
				
				Start()
				
			Case TOANDFRO
				_time Mod = _target
				_t = _time / _target
				
				If (_ease <> Null And _t > 0 And _t < 1) Then
					_t = _ease.Ease(_t)
				End If
				
				If (_backward) _t = 1 - _t
				_backward = Not _backward
				
				Start()
				
			Case ONESHOT
				_time = _target
				active = False
				_parent.RemoveTween(Self, True)
		End Select
		
		_finish = False
		If (complete <> Null) complete.OnTweenComplete()
	End Method
	
	Method Percent:Float() Property
		Return _time / _target
	End Method
	
	Method Percent:Void(value:Float) Property
		_time = _target * value
	End Method
	
	Method Scale:Float() Property
		Return _t
	End Method

End Class

Interface FlxTweenListener
	
	Method OnTweenComplete:Void()

End Interface