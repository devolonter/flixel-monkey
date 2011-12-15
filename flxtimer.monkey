Strict

Import flxg
Import plugin.timermanager

Interface FlxTimerCallback
	
	Method onTimer:Void(timer:FlxTimer)

End Interface

Class FlxTimer
	
	Field time:Float
	
	Field loops:Int
	
	Field paused:Bool
	
	Field finished:Bool
	
Private
	Field _callback:FlxTimerCallback
	
	Field _timeCounter:Float
	
	Field _loopsCounter:Int
	
Public
	Method New()
		time = 0
		loops = 0
		_callback = Null
		_timeCounter = 0
		_loopsCounter = 0
		
		paused = False
		finished = False			
	End Method
	
	Method Destroy:Void()
		Stop()
		_callback = Null	
	End Method
	
	Method Update:Void()
		_timeCounter += FlxG.elapsed
		
		While (_timeCounter >= time And Not paused And Not finished)
			_timeCounter -= time
			
			_loopsCounter += 1
			If (loops > 0 And _loopsCounter >= loops) Stop()
			
			If (_callback <> Null) _callback.onTimer(Self)		
		Wend
	End Method
	
	Method Start:FlxTimer(time:Float = 1, loops:Int = 1, callback:FlxTimerCallback = Null)
		Local timerManager:TimerManager = Manager		
		If (timerManager <> Null) timerManager.Add(Self)
		
		If (paused) Then
			paused = False
			Return Self						
		End If
		
		paused = False
		finished = False
		Self.time = time
		Self.loops = loops
		_callback = callback
		_timeCounter = 0
		_loopsCounter = 0
		
		Return Self
	End Method
	
	Method Stop:Void()
		finished = True
		
		Local timerManger:TimerManager = FlxTimer.Manager()
		If (timerManger <> Null) timerManger.Remove(Self)			
	End Method
	
	Method TimeLeft:Int() Property
		Return time - _timeCounter
	End Method
	
	Method LoopsLeft:Int() Property
		Return loops - _loopsCounter
	End Method
	
	Method Progress:Float() Property
		If (time > 0) Return _timeCounter/Float(time)
		
		Return .0
	End Method
	
	Function Manager:TimerManager()
		Return TimerManager(FlxG.GetPlugin(TimerManager.CLASS_OBJECT))				
	End Function
	
	Method ToString:String()
		Return "FlxTimer"
	End Method
	
End Class