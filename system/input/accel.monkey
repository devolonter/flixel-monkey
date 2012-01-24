Strict

Import flixel.system.replay.xyzrecord

Class Accel
	
	Field x:Float
	
	Field y:Float
	
	Field z:Float
	
Private
	Field _lastX:Float
	
	Field _lastY:Float
	
	Field _lastZ:Float

Public	
	Method New()
		x = 0
		y = 0
		z = 0
		_lastX = 0
		_lastY = 0
		_lastZ = 0
	End Method
	
	Method Update:Void(x:Float, y:Float, z:Float)
		Self.x = x
		Self.y = y
		Self.z = z
	End Method
	
	Method Reset:Void()
		x = 0
		y = 0
		z = 0
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