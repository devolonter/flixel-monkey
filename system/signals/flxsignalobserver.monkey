Strict

Class FlxSignalObserver
	
Private
	Field _priority:Int
	
Public
	Method New(priority:Int)
		_priority = priority
	End Method

	Method Priority:Int() Property
		Return _priority
	End Method

End Class