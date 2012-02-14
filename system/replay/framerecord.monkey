Strict

Import keyrecord
Import xyrecord
Import xyzrecord

Class FrameRecord

	Field frame:Int
	
	Field keys:Stack<KeyRecord>
	
	Field mouse:XYRecord
	
	Field joystick:Stack<XYZRecord[]>
	
	Field touch:Stack<XYRecord>
	
	Field accel:XYZRecord
	
	Method New()
		frame = 0
		keys = Null
		mouse = Null	
	End Method
	
	Method Create:FrameRecord(frame:Int, keys:Stack<KeyRecord> = Null, mouse:XYRecord = Null, joystick:Stack<XYZRecord[]> = Null, touch:Stack<XYRecord> = Null, accel:XYZRecord = Null)
		Self.frame = frame
		Self.keys = keys
		Self.mouse = mouse
		Self.joystick = joystick
		Self.touch = touch
		Self.accel = accel
		
		Return Self
	End Method
	
	Method Destroy:Void()
		keys = Null
		mouse = Null
		joystick = Null
		touch = Null
		accel = Null
	End Method
	
	Method Save:String()
		Return Save(New StringStack()).Join("")
	End Method
	
	Method Save:StringStack(output:StringStack)			
		output.Push(frame + "k")
		
		If (keys <> Null) Then
			Local key:KeyRecord
			Local i:Int = 0
			Local l:Int = keys.Length()
			
			While (i < l)
				If (i > 0) output.Push(",")
				
				key = keys.Get(i)
							
				output.Push(key.code + ":" + key.value)
			
				i += 1
			Wend
		End If
		
		output.Push("m")
		
		If (mouse <> Null) Then
			output.Push(mouse.x + "," + mouse.y)
		End If
		
		output.Push("j")
		
		If (joystick <> Null) Then
			Local i:Int = 0
			Local l:Int = joystick.Length()
			Local xyzArray:XYZRecord[]
			
			While (i < l)
				If (i > 0) output.Push(",")
				output.Push(i)
				
				xyzArray = joystick.Get(i)
				For Local index:Int = 0 Until xyzArray.Length()
					If (xyzArray[index] = Null) xyzArray[index] = New XYZRecord(0, 0, 0)

					output.Push(":" + xyzArray[index].x + ":" + xyzArray[index].y + ":" + xyzArray[index].z)
				Next
			
				i += 1			
			Wend
		End If
		
		output.Push("t")
		
		If (touch <> Null) Then
			Local i:Int = 0
			Local l:Int = touch.Length()
			Local xy:XYRecord
			
			While (i < l)
				xy = touch.Get(i)				
				If (xy = Null) Exit
				
				If (i > 0) output.Push(",")	
				output.Push(xy.x + ":" + xy.y)
				
				i += 1			
			Wend
		End If
		
		output.Push("a")
		
		If (accel <> Null) Then
			output.Push(accel.x + "," + accel.y + "," + accel.z)		
		End If
		
		Return output
	End Method
	
	Method Load:FrameRecord(data:String)
		Local i:Int
		Local l:Int
		
		Local tmpArray:String[] = data.Split("k")
		
		frame = Int(tmpArray[0])
		
		tmpArray = tmpArray[1].Split("m")
		
		Local keyData:String = tmpArray[0]
		
		tmpArray = tmpArray[1].Split("j")
		
		Local mouseData:String = tmpArray[0]
		
		tmpArray = tmpArray[1].Split("t")
		
		Local joystickData:String = tmpArray[0]
		
		tmpArray = tmpArray[1].Split("a")
		
		Local touchData:String = tmpArray[0]
		
		Local accelData:String = tmpArray[1]
		
		If (keyData.Length() > 0) Then
			tmpArray = keyData.Split(",")
			
			Local keyPair:String[]
			i = 0
			l = tmpArray.Length()
			
			While (i < l)
				keyPair = tmpArray[i].Split(":")
				
				If (keyPair.Length() = 2) Then
					If (keys = Null) keys = New Stack<KeyRecord>()
					
					keys.Push(New KeyRecord(Int(keyPair[0]), Int(keyPair[1])))
				End If
				
				i += 1
			Wend
		End If
		
		If (mouseData.Length() > 0) Then
			tmpArray = mouseData.Split(",")
			
			If (tmpArray.Length() = 2) Then
				mouse = New XYRecord(Int(tmpArray[0]), Int(tmpArray[1]))
			End If
		End If
		
		If (joystickData.Length() > 0) Then
			tmpArray = joystickData.Split(",")
			
			Local joyData:String[]
			i = 0
			l = tmpArray.Length()
			
			While (i < l)
				joyData = tmpArray[i].Split(":")
			
				If (joyData.Length() > 3) Then
					If (joystick = Null) joystick = New Stack<XYZRecord[]>()
					
					Local jl:Int = joyData.Length()
					Local joyXYZRecord:XYZRecord[] = New XYZRecord[(jl - 1) / 3]
					Local index:Int = 0
					
					For Local ji:Int = 1 Until jl Step 3						
						joyXYZRecord[index] = New XYZRecord(Float(joyData[ji]), Float(joyData[ji + 1]), Float(joyData[ji + 2]))
						index += 1
					Next
					
					joystick.Insert(Int(joyData[0]), joyXYZRecord)
				End If
				
				i += 1
			Wend
		
		End If
		
		If (touchData.Length() > 0) Then
			tmpArray = touchData.Split(",")
			
			Local touchXY:String[]
			i = 0
			l = tmpArray.Length()
			
			While (i < l)
				touchXY = tmpArray[i].Split(":")
				
				If (touchXY.Length() = 2) Then
					If (touch = Null) touch = New Stack<XYRecord>()
					
					touch.Push(New XYRecord(Int(touchXY[0]), Int(touchXY[1])))
				End If
				
				i += 1
			Wend
		End If
		
		If (accelData.Length() > 0) Then
			tmpArray = accelData.Split(",")
			
			If (tmpArray.Length() = 3) Then
				accel = New XYZRecord(Float(tmpArray[0]), Float(tmpArray[1]), Float(tmpArray[2]))
			End If
		End If
		
		Return Self
	End Method
End Class