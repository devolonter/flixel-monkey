Strict

Import flxsignalobserverlist

Class FlxSignal
	
Private
	Field _observers:FlxSignalObserverList

Public
	Method New()
		_observers = New FlxSignalObserverList()
	End Method
	
	Method Destroy:Void()
		_observers.Destroy()
		_observers = Null
	End Method
	
	Method RegisterObserver:FlxSignalObserver(listener:FlxSignalListener)
		Local observer:FlxSignalObserver = _observers.Get(listener)
		
		If (observer = Null) Then
			observer = New FlxSignalObserver(listener, False, Self)
			_observers.AddLast(observer)
		End If
		
		Return observer
	End Method
	
	Method RegisterObserver:FlxSignalObserver(listener:FlxSignalListener, instant:Bool)
		Local observer:FlxSignalObserver = _observers.Get(listener)
		
		If (observer = Null) Then
			observer = New FlxSignalObserver(listener, instant, Self)
			_observers.AddLast(observer)
		End If
		
		Return observer
	End Method
	
	Method RegisterObserver:FlxSignalObserver(listener:FlxSignalListener, instant:Bool, priority:Bool)
		Local observer:FlxSignalObserver = _observers.Get(listener)
		
		If (observer = Null) Then
			observer = New FlxSignalObserver(listener, instant, Self, priority)
			_observers.InsertWithPriority(observer)
		End If
		
		Return observer
	End Method

	Method Remove:FlxSignalObserver(observer:FlxSignalObserver)
		Return _observers.RemoveFirst(observer)
	End Method
	
	Method Clear:Void()
		_observers.Clear()
	End Method
	
	Method Emit:Void()
		If (IsEmpty()) Return Null
	
		Local node:list.Node<FlxSignalObserver> = FirstNode()
		
		While (node <> Null)
			node.Value().Apply()
			node = node.NextNode()
		Wend
	End Method

End Class