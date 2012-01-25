Strict

Import xydevice

Class Touch Extends XYDevice

	Field index:Int
	
	Method New(index:Int)
		Super.New(KEY_TOUCH0 + index, KEY_TOUCH0 + index)
		Self.index = index
	End Method

	Method Pressed:Bool()
		Print KEY_TOUCH0 + index
		Return Super.Pressed(KEY_TOUCH0 + index)
	End Method
	
	Method JustPressed:Bool()		
		Return Super.JustPressed(KEY_TOUCH0 + index)
	End Method
	
	Method JustReleased:Bool()
		Return Super.JustReleased(KEY_TOUCH0 + index)
	End Method
	
End Class