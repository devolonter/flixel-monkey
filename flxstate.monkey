Strict

Import flxgroup

Class FlxState Extends FlxGroup Abstract

	Const ORDER_ASC:Int = 0
	Const ORDER_DESC:Int = 1	

	Field persistentUpdate:Bool = False
	
	Field persistentDraw:Bool = True
	
	Field drawOrder:Int
	
	Field updateOrder:Int
	
	Method Create:Void() Abstract
	
	Method OnActivate:Void(prevSubstate:FlxSubState)
	End Method
	
	Method Destroy:Void()
		Super.Destroy()
		
		If (_subState <> Null And _subState._initialized) Then
			_subState.Destroy()
		End If
	End Method
	
	Method OnBack:Bool()
		Return True
	End Method
	
	Method OnClose:Bool()
		Return True
	End Method
	
	Method SetSubState:Void(subState:FlxSubState)
		If (_subState = subState) Return
		
		If (_subState <> Null) Then
			If ( Not _subState.OnClose(_subState._closedBySystem)) Then
				_subState.PreventDefault()
				_subState.StopPropagation()
				Return
			End If
			
			_subState._parent = Null
		End If
		
		If (subState <> Null) Then
			_subState = subState
			_subState._parent = Self
		
			If ( Not _subState._initialized) Then
				_subState.Create()
				_subState._initialized = True
			End If
			
			_subState.OnActivate()
		Else
			subState = _subState
			_subState = Null
			OnActivate(subState)
		End If
	End Method
	
	Method GetSubState:FlxSubState()
		Return _subState
	End Method
	
	Method CloseSubState:Void()
		If (_subState = Null) Return
		SetSubState(Null)
	End Method
	
	Method DoUpdate:Void()
		If (_subState = Null) Then
			Update()
			Return
		End If
		
		If (updateOrder = ORDER_DESC) Then
			_subState.Update()
		End If
		
		If (persistentUpdate) Then
			Update()
		End If
		
		If (updateOrder = ORDER_ASC) Then
			_subState.Update()
		End If
	End Method
	
	Method DoDraw:Void()
		If (_subState = Null) Then
			Draw()
			Return
		End If
		
		If (drawOrder = ORDER_DESC) Then			
			_subState.Draw()
		End If
		
		If (persistentDraw) Then
			Draw()
		End If
		
		If (drawOrder = ORDER_ASC) Then
			_subState.Draw()
		End If
	End Method
	
	Method DoBack:Bool()
		If (_subState = Null) Then
			Return OnBack()
		End If
		
		_subState._closedBySystem = True
		_subState.Close()
		
		If ( Not _subState._stopPropagation) Then
			If ( Not _subState._preventDefault) Then
				Return OnBack()
			End If
			
			OnBack()
		End If
		
		Return Not _subState._preventDefault
	End Method
	
	Method DoClose:Bool()
		If (_subState = Null) Then
			Return OnClose()
		End If
		
		Local subState:FlxSubState = _subState
		subState._closedBySystem = True
		subState.Close()
		
		If ( Not subState._stopPropagation) Then
			If ( Not subState._preventDefault) Then
				Return OnClose()
			End If
			
			OnClose()
		End If
		
		Return Not subState._preventDefault
	End Method
	
	Private
	
	Field _subState:FlxSubState

End Class

Class FlxSubState Extends FlxGroup Abstract

	Method Create:Void() Abstract
	
	Method Destroy:Void()
		Super.Destroy()
		
		_parent = Null
		_initialized = False
	End Method

	Method Close:Void()
		If (_parent = Null) Return
		
		_preventDefault = False
		_stopPropagation = False
		
		_parent.CloseSubState()
		
		_closedBySystem = False
	End Method
	
	Method GetParent:FlxState()
		Return _parent
	End Method
	
	Method OnActivate:Void()
	End Method
	
	Method OnClose:Bool(system:Bool)
		Destroy()
		Return True
	End Method
	
	Method StopPropagation:Void()
		_stopPropagation = True
	End Method
	
	Method PreventDefault:Void()
		_preventDefault = True
	End Method

	Private
	
	Field _parent:FlxState
	
	Field _initialized:Bool
	
	Field _preventDefault:Bool
	
	Field _stopPropagation:Bool
	
	Field _closedBySystem:Bool
	
End Class

Interface FlxSwitchStateListener
	
	Method OnSwitchState:Void(oldState:FlxState, newState:FlxState)

End Interface
