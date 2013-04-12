Strict

Import flxsignalobserverlist

Class FlxSignal
	
Private
	Field _observers:FlxSignalObserverList

Public
	Method Remove:FlxSignalObserver(observer:FlxSignalObserver)
		Return _observers.RemoveFirst(observer)
	End Method

End Class