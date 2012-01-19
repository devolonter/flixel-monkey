Strict

Import flixel.flxextern

Class FlxString Implements FlxStringable

Private
	Field _value:String
	Field _isChanged:Bool
	
Public
	Method New()
	End Method

	Method New(value:String)		
		_value = value
		_isChanged = True
	End Method

	Method ToString:String()		
		Return _value
	End Method
	
	Method FromString:Object(value:String)
		_value = value
		_isChanged = True
		Return Self
	End Method
	
	Method StringIsChanged:Bool()
		If (_isChanged) Then
			_isChanged = False		
			Return True
		End If
		
		Return False
	End Method
	
End Class