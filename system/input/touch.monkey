Strict

Import xydevice

Class Touch Extends XYDevice

	Field index:Int
	
	Method New(index:Int)
		Super.New(KEY_TOUCH0 + index, KEY_TOUCH0 + index)
		Self.index = index
	End Method

	Method Pressed:Bool() Property
		Return Super.Pressed(KEY_TOUCH0 + index)
	End Method
	
	Method JustPressed:Bool() Property		
		Return Super.JustPressed(KEY_TOUCH0 + index)
	End Method
	
	Method JustReleased:Bool() Property
		Return Super.JustReleased(KEY_TOUCH0 + index)
	End Method	
	
End Class