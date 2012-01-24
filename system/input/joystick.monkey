Strict

Import input
Import flixel.system.replay.xyzrecord

Class Joystick Extends Input

	Field unit:Int = 0
	
	Field x:Float
	
	Field y:Float
	
	Field z:Float
	
Private
	Field _lastX:Float
	
	Field _lastY:Float
	
	Field _lastZ:Float
	
Public	
	Method New(unit:Int)
		Super.New(unit Shl 4 | KEY_JOY0, $20 | unit Shl 4 | KEY_JOY0)
		Self.unit = unit 
	End Method
	
	Method Pressed:Bool(button:Int)
		Return Super.Pressed(button | unit Shl 4 | KEY_JOY0)
	End Method
	
	Method JustPressed:Bool(button:Int)
		Return Super.JustPressed(button | unit Shl 4 | KEY_JOY0)
	End Method
	
	Method JustReleased:Bool(button:Int)
		Return Super.JustReleased(button | unit Shl 4 | KEY_JOY0)
	End Method
	
	Method RecordXYZ:XYZRecord()
		If (_lastX = x And _lastY = y And _lastZ = z) Then
			Return Null
		End If
		
		_lastX = x
		_lastY = y
		_lastZ = z
		
		Return New XYZRecord(_lastX, _lastY, _lastZ)
	End Method
	
	Method PlaybackXYZ:Void(record:XYZRecord)
		x = record.x
		y = record.y
		z = record.z
	End Method


End Class