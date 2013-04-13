Strict

Import flxsignalobserver

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
				Return New list.Node<T>(node, node.PrevNode(), signalObserver)
			End If
		Forever
		
		Return AddLast(signalObserver)
	End Method
	
	Method Remove:FlxSignalObserver(signalObserver:FlxSignalObserver)
		Self.RemoveFirst(signalObserver)
	End Method

End Class