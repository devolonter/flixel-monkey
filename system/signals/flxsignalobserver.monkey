Strict

Import flxsignal

Class FlxSignalObserver

	Field enabled:Bool
	
	Field listener:FlxSignalListener
	
Private
	Field _signal:FlxSignal
	
	Field _instant:Bool
	
	Field _priority:Int
	
Public
	Method New(listener:FlxSignalListener, instant:Bool = False, signal:FlxSignal = Null, priority:Int = 0)
		_signal = signal
		enabled = True
		Self.listener = listener
		_instant = instant
		_priority = priority
	End Method
	
	Method Destroy:Void()
		_signal = Null
		listener = Null
	End Method
	
	Method Apply:Void(data:Object)
		If ( Not enabled) Return
		If (_instant) Disconnect()
		
		listener.OnSignalEmitted(_signal, data)
	End Method
	
	Method Disconnect:Void()
		_signal.RemoveListener(listener)
	End Method

	Method Priority:Int() Property
		Return _priority
	End Method

End Class

Interface FlxSignalListener
	
	Method OnSignalEmitted:Void(signal:FlxSignal, data:Object)

End Interface