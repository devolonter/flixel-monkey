Strict

Import reflection
Import system.signals.flxsignal

Class FlxSignals
	
Private
	Field _signals:IntMap<FlxSignal>
	
	Field _methodSlots:List<FlxMethodSlot>
	
	Field _functionSlots:List<FlxFunctionSlot>
	
Public
	Method New()
		_signals = New IntMap<FlxSignal>()
		_methodSlots = New List<FlxMethodSlot>()
		_functionSlots = New List<FlxFunctionSlot>()
	End Method
	
	Method Connect:Void(signalID:Int, listener:FlxSignalListener)
		GetSignal(signalID).RegisterListener(listener)
	End Method
	
	Method Connect:Void(signalID:Int, listener:FlxSignalListener, instant:Bool)
		GetSignal(signalID).RegisterListener(listener, instant)
	End Method
	
	Method Connect:Void(signalID:Int, listener:FlxSignalListener, instant:Bool, priority:Int)
		GetSignal(signalID).RegisterListener(listener, instant, priority)
	End Method
	
	Method Connect:Void(signalID:Int, methodName:String, context:Object)
		Connect(signalID, GetMethodSlot(methodName, context))
	End Method
	
	Method Connect:Void(signalID:Int, methodName:String, context:Object, instant:Bool)
		Connect(signalID, GetMethodSlot(methodName, context), instant)
	End Method
	
	Method Connect:Void(signalID:Int, methodName:String, context:Object, instant:Bool, priority:Int)
		Connect(signalID, GetMethodSlot(methodName, context), instant, priority)
	End Method
	
	Method Connect:Void(signalID:Int, functionName:String)
		Connect(signalID, GetFunctionSlot(functionName))
	End Method
	
	Method Connect:Void(signalID:Int, functionName:String, instant:Bool)
		Connect(signalID, GetFunctionSlot(functionName), instant)
	End Method
	
	Method Connect:Void(signalID:Int, functionName:String, instant:Bool, priority:Int)
		Connect(signalID, GetFunctionSlot(functionName), instant, priority)
	End Method
	
	Method Emit:Void(signalID:Int, data:Object = Null)
		GetSignal(signalID).Emit(data)
	End Method
	
Private
	Method GetSignal:FlxSignal(signalID:Int)
		Local s:FlxSignal = _signals.Get(signalID)
		
		If (s = Null) Then
			s = New FlxSignal()
			_signals.Set(signalID, s)
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
	
	Method GetFunctionSlot:FlxFunctionSlot(functionName:String)
		Local functionInfo:FunctionInfo = GetFunction(functionName,[])
		
		If (functionInfo <> Null) Then
			Local node:list.Node<FlxFunctionSlot> = _functionSlots.FirstNode()
	
			While (node <> Null)
				If (node.Value()._function = functionInfo) Then
					Return node.Value()
				End If

				node = node.NextNode()
			Wend
			
			Return _functionSlots.AddLast(New FlxFunctionSlot(functionInfo)).Value()
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

Class FlxFunctionSlot Implements FlxSignalListener

Private
	Field _function:FunctionInfo
	
Public
	Method New(functionInfo:FunctionInfo)
		_function = functionInfo
	End Method
	
	Method OnSignalEmitted:Void(signal:FlxSignal, data:Object)
		_function.Invoke([])
	End Method

End Class