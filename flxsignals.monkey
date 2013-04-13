Strict

Import reflection
Import system.signals.flxsignal

Class FlxSignals
	
Private
	Field _signals:StringMap<FlxSignal>
	
	Field _methodSlots:List<FlxMethodSlot>
	
Public
	Method New()
		_signals = New StringMap<FlxSignal>()
		_methodSlots = New List<FlxMethodSlot>()
	End Method
	
	Method Connect:Void(signal:String, listener:FlxSignalListener)
		GetSignal(signal).RegisterListener(listener)
	End Method
	
	Method Connect:Void(signal:String, listener:FlxSignalListener, instant:Bool)
		GetSignal(signal).RegisterListener(listener, instant)
	End Method
	
	Method Connect:Void(signal:String, listener:FlxSignalListener, instant:Bool, priority:Int)
		GetSignal(signal).RegisterListener(listener, instant, priority)
	End Method
	
	Method Connect:Void(signal:String, methodName:String, context:Object)
		Connect(signal, GetMethodSlot(methodName, context))
	End Method
	
	Method Connect:Void(signal:String, methodName:String, context:Object, instant:Bool)
		Connect(signal, GetMethodSlot(methodName, context), instant)
	End Method
	
	Method Connect:Void(signal:String, methodName:String, context:Object, instant:Bool, priority:Int)
		Connect(signal, GetMethodSlot(methodName, context), instant, priority)
	End Method
	
	Method Emit:Void(signal:String, data:Object = Null)
		GetSignal(signal).Emit(data)
	End Method
	
Private
	Method GetSignal:FlxSignal(signal:String)
		Local s:FlxSignal = _signals.Get(signal)
		
		If (s = Null) Then
			s = New FlxSignal()
			_signals.Add(signal, s)
		End If
		
		Return s
	End Method
	
	Method GetMethodSlot:FlxMethodSlot(methodName:String, context:Object)
		Local classInfo:ClassInfo = GetClass(context)
		
		If (classInfo <> Null) Then
			Local methodInfo:MethodInfo = classInfo.GetMethod(methodName,[])
			
			If (methodInfo <> Null) Then
				Local node:list.Node<FlxMethodSlot> = _methodSlots.FirstNode()
		
				While (node <> Null)
					If (node.Value()._method = methodInfo And node.Value()._context = context) Then
						Return node.Value()
					End If

					node = node.NextNode()
				Wend
				
				Return _methodSlots.AddLast(New FlxMethodSlot(context, methodInfo)).Value()
			End If
		End If
		
		Return Null
	End Method

End Class

Private

Class FlxMethodSlot Implements FlxSignalListener

Private
	Field _context:Object

	Field _method:MethodInfo
	
Public
	Method New(context:Object, methodInfo:MethodInfo)
		_context = context
		_method = methodInfo
	End Method
	
	Method OnSignalEmitted:Void(signal:FlxSignal, data:Object)
		_method.Invoke(_context,[])
	End Method

End Class