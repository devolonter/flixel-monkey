Strict

Import flxg
Import flixel.plugin.timemanager

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
		'_timeCounter +=
	End Method
	
	Method Start:FlxTimer(time:Float = 1, loops:Int = 1, callback:FlxTimerCallback = Null)
	
	End Method
	
	Method Stop:Void()
		
	End Method
	
	Method TimeLeft:Float() Property
	
	End Method
	
	Method LoopsLeft:Int() Property
		
	End Method
	
	Method Progress:Float() Property
		
	End Method
	
	Method Manager:TimerManager() Property
			
	End Method
	
End Class