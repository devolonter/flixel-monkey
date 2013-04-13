Strict

Import flxsignalobserver

Class FlxSignal
	
Private
	Field _observers:FlxSignalObserverList
	
	Field _id:Int

Public
	Method New(id:Int)
		_observers = New FlxSignalObserverList()
		_id = id
	End Method
	
	Method Destroy:Void()
		_observers.Destroy()
		_observers = Null
	End Method
	
	Method RegisterListener:FlxSignalObserver(listener:FlxSignalListener)
		If (listener = Null) Return Null
		
		Local observer:FlxSignalObserver = _observers.Get(listener)
		
		If (observer = Null) Then
			observer = New FlxSignalObserver(listener, False, Self)
			_observers.AddLast(observer)
		End If
		
		Return observer
	End Method
	
	Method RegisterListener:FlxSignalObserver(listener:FlxSignalListener, instant:Bool)
		If (listener = Null) Return Null
		
		Local observer:FlxSignalObserver = _observers.Get(listener)
		
		If (observer = Null) Then
			observer = New FlxSignalObserver(listener, instant, Self)
			_observers.AddLast(observer)
		End If
		
		Return observer
	End Method
	
	Method RegisterListener:FlxSignalObserver(listener:FlxSignalListener, instant:Bool, priority:Int)
		If (listener = Null) Return Null
		
		Local observer:FlxSignalObserver = _observers.Get(listener)
		
		If (observer = Null) Then
			observer = New FlxSignalObserver(listener, instant, Self, priority)
			_observers.InsertWithPriority(observer)
		End If
		
		Return observer
	End Method

	Method RemoveListener:FlxSignalObserver(listener:FlxSignalListener)
		If (listener = Null) Return Null
		Return _observers.Remove(listener)
	End Method
	
	Method Clear:Void()
		_observers.Clear()
	End Method
	
	Method Emit:Void(data:Object)
		Local node:list.Node<FlxSignalObserver> = _observers.FirstNode()
		
		While (node <> Null)
			node.Value().Apply(data)
			node = node.NextNode()
		Wend
	End Method
	
	Method ID:Int() Property
		Return _id
	End Method

End Class

Private
Class FlxSignalObserverList Extends List<FlxSignalObserver>

	Method Destroy:Void()
		Local node:list.Node<FlxSignalObserver> = FirstNode()
		
		While (node <> Null)
			node.Value().Destroy()
			node.Remove()
			
			node = node.NextNode()
		Wend
	End Method
	
	Method InsertWithPriority:list.Node<FlxSignalObserver>(signalObserver:FlxSignalObserver)
		If (IsEmpty()) Then
			Return AddFirst(signalObserver)
		End If
		
		Local node:list.Node<FlxSignalObserver> = FirstNode()
		Local priority:Int = signalObserver.Priority
		
		If (priority > node.Value().Priority) Then
			Return AddFirst(signalObserver)
		End If
		
		Repeat
			node = node.NextNode()
			If (node = Null) Exit
			
			If (priority > node.Value().Priority) Then
				Return New list.Node<FlxSignalObserver>(node, node.PrevNode(), signalObserver)
			End If
		Forever
		
		Return AddLast(signalObserver)
	End Method
	
	Method Remove:FlxSignalObserver(listener:FlxSignalListener)
		Local node:list.Node<FlxSignalObserver> = FirstNode()
		
		While (node <> Null)
			If (node.Value().listener = listener) Then
				node.Remove()
				Return node.Value()
			End If
			
			node = node.NextNode()
		Wend
		
		Return Null
	End Method
	
	Method Get:FlxSignalObserver(listener:FlxSignalListener)
		Local node:list.Node<FlxSignalObserver> = FirstNode()
		
		While (node <> Null)
			If (node.Value().listener = listener) Then
				Return node.Value()
			End If
			
			node = node.NextNode()
		Wend
		
		Return Null
	End Method

End Class