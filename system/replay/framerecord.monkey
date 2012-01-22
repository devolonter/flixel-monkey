Strict

Import keyrecord
Import xyrecord

Class FrameRecord

	Field frame:Int
	
	Field keys:Stack<KeyRecord>
	
	Field mouse:XYRecord
	
Private
	Global _stringBuffer:StringStack = New StringStack()
	
	Method New()
		frame = 0
		keys = Null
		mouse = Null	
	End Method
	
	Method Create:FrameRecord(frame:Int, keys:Stack<KeyRecord> = Null, mouse:XYRecord)
		Self.frame = frame
		Self.keys = keys
		Self.mouse = mouse
		
		Return Self
	End Method
	
	Method Destroy:Void()
		keys = Null
		mouse = Null	
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
							
				output.Push(key.code + ":" + key.value))
			
				i += 1
			Wend
		End If
		
		output.Push("m")
		
		If (mouse <> Null) Then
			output.Push(mouse.x + "," + mouse.y)
		End If
		
		Return output
	End Method
	
	Method Load:FrameRecord(data:String)
		Local i:Int
		Local l:Int
		
		Local array:String[] = data.Split("k")
		frame = Int(array[0])
		
		array = array[1].Split("m")
		
		Local keyData:String = array[0]
		Local mouseData:String = array[1]
		
		If (keyData.Length() > 0) Then
			array = keyData.Split(",")
			
			Local keyPair:String[]
			i = 0
			l = array.Length()
			
			While (i < l)
				keyPair = array[i].Split(":")
				
				If (keyPair.Length() = 2) Then
					If (keys = Null) keys = New Stack<KeyRecord>()
					
					keys.Push(New KeyRecord(Int(keyPair[0]), Int(keyPair[1])))
				End If
				
				i += 1
			Wend
		End If
		
		If (mouseData.Length() > 0) Then
			array = mouseData.Split(",")
			
			If (array.Length = 2) Then
				mouse = New XYRecord(Int(array[0]), Int(array[1]))
			End If
		End If
		
		Return Self
	End Method
End Class