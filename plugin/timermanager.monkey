Strict

Import flixel

Class TimerManager Extends FlxBasic

Private
	Field _timers:Stack<FlxTimer>

Public	
	Global CLASS_OBJECT:FlxClass = new TimerManagerClass()

	Method New()
		_timers = New Stack<FlxTimer>()
		visible = False
	End Method
	
	Method Destroy:Void()
		Clear()
		_timers = Null		
	End Method
	
	Method Update:Void()
		Local i:Int = _timers.Length() - 1
		Local timer:FlxTimer
		
		While (i >= 0)
			timer = _timers.Get(i)
			If (timer <> Null And Not timer.paused And Not timer.finished And timer.time > 0) Then
				timer.Update()
			End If
			i-=1		
		Wend
	End Method
	
	Method Add:Void(timer:FlxTimer)
		_timers.Push(timer)		
	End Method
	
	Method Remove:Void(timer:FlxTimer)
		_timers.RemoveEach(timer)	
	End Method
	
	Method Clear:Void()
		Local i:Int = _timers.Length() - 1
		Local timer:FlxTimer
		
		While (i >= 0)
			timer = _timers.Get(i)
			If (timer <> Null) timer.Destroy()	
			i-=1	
		Wend
		
		_timers.Clear()		
	End Method
	
	Method ToString:String()
		Return "TimerManager"
	End Method
	
End Class

Private
Class TimerManagerClass Implements FlxClass

	Method CreateInstance:FlxBasic()
		Return New TimerManager()
	End Method
	
	Method InstanceOf:Bool(object:FlxBasic)
		Return (TimerManager(object) <> Null)
	End Method	
	
End Class