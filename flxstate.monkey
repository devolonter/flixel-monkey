Strict

Import flxgroup

Class FlxState Extends FlxGroup Abstract

	Field persistantUpdate:Bool = False
	
	Field persistantDraw:Bool = True
	
	Method Create:Void() Abstract
	
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
			If ( Not _subState.OnClose()) Then
				_subState.PreventDefault()
				_subState.StopPropagation()
				Return
			End If
			
			_subState._parent = Null
		End If
		
		_subState = subState
			_subState._parent = Self
		
		If (_subState <> Null) Then
			If ( Not _subState._initialized) Then
				_subState.Create()
				_subState._initialized = True
			End If
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
		
		If (persistantUpdate) Then
			Update()
		End If
		
		_subState.Update()
	End Method
	
	Method DoDraw:Void()
		If (_subState = Null) Then
			Draw()
			Return
		End If
		
		If (persistantDraw) Then
			Draw()
		End If
		
		_subState.Draw()
	End Method
	
	Method DoBack:Bool()
		If (_subState = Null) Then
			Return OnBack()
		End If
		
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
		
		_subState.Close()
		
		If ( Not _subState._stopPropagation) Then
			If ( Not _subState._preventDefault) Then
				Return OnClose()
			End If
			
			OnClose()
		End If
		
		Return Not _subState._preventDefault
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
	End Method
	
	Method GetParent:FlxState()
		Return _parent
	End Method
	
	Method OnClose:Bool()
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
	
End Class