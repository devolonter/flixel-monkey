Strict

Import flxsignal

Class FlxSignalObserver

	Field enabled:Bool
	
Private
	Field _signal:FlxSignal
	
	Field _listener:FlxSignalListener
	
	Field _instant:Bool
	
	Field _priority:Int
	
Public
	Method New(listener:FlxSignalListener, instant:Bool = False, signal:FlxSignal = Null, priority:Int = 0)
		_signal = signal
		enabled = True
		_listener = listener
		_instant = instant
		_priority = priority
	End Method
	
	Method Destroy:Void()
		_signal = Null
		_listener = Null
	End Method
	
	Method Apply:Void(data:Object)
		If ( Not enabled) Return
		If (_instant) Remove()
		
		_listener.OnSignalEmit(_signal, data)
	End Method
	
	Method Remove:Void()
		_signal.Remove(Self)
	End Method

	Method Priority:Int() Property
		Return _priority
	End Method

End Class

Interface FlxSignalListener
	
	Method OnSignalEmit:Void(signal:FlxSignal, data:Object)

End Interface