Strict

Import reflection

Import flixel.flxextern
Import flixel.flxbasic
Import flixel.flxtimer

Class TimerManager Extends FlxBasic

	Global ClassObject:ClassInfo

Private
	Field _timers:Stack<FlxTimer>

Public
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