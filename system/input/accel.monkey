Strict

Import flixel.system.replay.xyzrecord

Class Accel
	
	Field x:Float
	
	Field y:Float
	
	Field z:Float

Public	
	Method New()
		x = 0
		y = 0
		z = 0
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
		If (x = 0 And y = 0 And z = 0) Then
			Return Null
		End If
		
		Return New XYZRecord(x, y, z)
	End Method
	
	Method PlaybackXYZ:Void(record:XYZRecord)
		x = record.x
		y = record.y
		z = record.z
	End Method

End Class