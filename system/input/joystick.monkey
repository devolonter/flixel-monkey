Strict

Import input
Import flixel.system.replay.xyzrecord

Class Joystick Extends Input

	Field unit:Int = 0
	
Private
	Const _COUNT_INDEXS:Int = 2

	Field _x:Float[_COUNT_INDEXS]
	
	Field _y:Float[_COUNT_INDEXS]
	
	Field _z:Float[_COUNT_INDEXS]
	
Public	
	Method New(unit:Int)
		Super.New(unit Shl 4 | KEY_JOY0, $20 | unit Shl 4 | KEY_JOY0)
		Self.unit = unit
		
		Local i:Int = 0
		
		While (i < _COUNT_INDEXS)
			_x[i] = 0
			_y[i] = 0
			_z[i] = 0
			
			i += 1
		Wend
	End Method
	
	Method Update:Void()
		Super.Update()
	
		Local i:Int = 0
		
		While (i < _COUNT_INDEXS)
			_x[i] = JoyX(i, unit)
			_y[i] = JoyY(i, unit)
			_z[i] = JoyZ(i, unit)
			
			i += 1
		Wend
	End Method
	
	Method Reset:Void()
		Local i:Int = 0
		
		While (i < _COUNT_INDEXS)
			_x[i] = 0
			_y[i] = 0
			_z[i] = 0
			
			i += 1
		Wend
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
	
	Method X:Float() Property
		Return _x[0]
	End Method
	
	Method Y:Float() Property
		Return _y[0]
	End Method
	
	Method Z:Float() Property
		Return _z[0]
	End Method
	
	Method X:Float(index:Int)
		Return _x[index]
	End Method
	
	Method Y:Float(index:Int)
		Return _y[index]
	End Method
	
	Method Z:Float(index:Int)
		Return _z[index]
	End Method
	
	Method RecordXYZ:XYZRecord[]()
		Local i:Int = 0
		Local data:XYZRecord[] 
		
		While (i < _COUNT_INDEXS)			
			If (Abs(_x[i]) < 0.001 And Abs(_y[i]) < 0.001 And Abs(_z[i]) < 0.001) Then
				i += 1
				Continue
			End If
			
			If (data.Length() = 0) data = data.Resize(_COUNT_INDEXS)		
			data[i] = New XYZRecord(_x[i], _y[i], _z[i])
			
			i += 1
		Wend
		
		Return data
	End Method
	
	Method PlaybackXYZ:Void(record:XYZRecord[])	
		Local xyz:XYZRecord
		Local i:Int = 0
		Local l:Int = record.Length()
	
		While (i < l)
			xyz = record[i]
			
			_x[i] = xyz.x
			_y[i] = xyz.y
			_z[i] = xyz.z
			
			i += 1
		Wend
	End Method


End Class