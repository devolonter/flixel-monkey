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

	Field _lastX:Float[_COUNT_INDEXS]
	
	Field _lastY:Float[_COUNT_INDEXS]
	
	Field _lastZ:Float[_COUNT_INDEXS]
	
Public	
	Method New(unit:Int)
		Super.New(unit Shl 4 | KEY_JOY0, $20 | unit Shl 4 | KEY_JOY0)
		Self.unit = unit
		
		Local i:Int = 0
		
		While (i < _COUNT_INDEXS)
			_x[i] = 0
			_y[i] = 0
			_z[i] = 0
			_lastX[i] = 0
			_lastY[i] = 0
			_lastZ[i] = 0
			
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
	
	Method Pressed:Bool(button:Int)
		Return Super.Pressed(button | unit Shl 4 | KEY_JOY0)
	End Method
	
	Method JustPressed:Bool(button:Int)
		Return Super.JustPressed(button | unit Shl 4 | KEY_JOY0)
	End Method
	
	Method JustReleased:Bool(button:Int)
		Return Super.JustReleased(button | unit Shl 4 | KEY_JOY0)
	End Method
	
	Method X:Float(index:Int = 0)
		Return _x[index]
	End Method
	
	Method Y:Float(index:Int = 0)
		Return _y[index]
	End Method
	
	Method Z:Float(index:Int = 0)
		Return _z[index]
	End Method
	
	Method RecordXYZ:XYZRecord[](data:XYZRecord[] = [])
		Local i:Int = 0
		
		While (i < _COUNT_INDEXS)
			If (_lastX[i] = x[i] And _lastY[i] = y[i] And _lastZ[i] = z[i]) Then
				Exit
			End If
			
			_lastX[i] = x[i]
			_lastY[i] = y[i]
			_lastZ[i] = z[i]
			
			If (data = Null) data = data.Resize(_COUNT_INDEXS)			
			data[i] = New XYZRecord(_lastX[i], _lastY[i], _lastZ[i])
			
			i += 1
		Wend
		
		Return data
	End Method
	
	Method PlaybackXYZ:Void(record:XYZRecord[])
		Local xyz:XYZRecord
	
		While (i < _COUNT_INDEXS)
			xyz = record[i]
			
			_x[i] = xyz.x
			_y[i] = xyz.y
			_z[i] = xyzz
			
			i += 1
		Wend
	End Method


End Class