Strict

Import mojo

Import flixel.system.replay.keysrecord

Class Input Abstract
	
Private
	Global _map:InputState[]
	CONST _TOTAL:Int = 416
	
Public
	Method New()
		If (_map.Length() = 0) Then
			_map = _map.Resize(_TOTAL)
		
			Local i:Int = 0			
			While (i < _TOTAL)
				_map[i] = New InputState()
				i += 1
			Wend
		End If
	End Method
	
	Method UpdateKeys:Void()
		Local i:Int = 0
		Local is:InputState
		 	
		While (i < _TOTAL)
			is = _map[i]
			
			If (KeyDown(i)) Then
				If (is.current > 0 And is.last = 2) Then
					is.current = 1
				Else
					is.current = 2
				End If
			Else
				If (is.current > 0 And is.last > 0) Then
					is.current = -1
				Else
					is.current = 0			
				End If
			End If
			
			is.last = is.current
		Wend
	End Method
	
	Method Reset:Void()
		Local i:Int = 0
		Local is:InputState
		 	
		While (i < _TOTAL)
			is = _map[i]			
			is.current = 0
			is.last = 0
		Wend
	End Method
	
	Method Pressed:Bool(key:Int)
		Return _map[key] = 1
	End Method
	
	Method JustPressed:Bool(key:Int)
		Return _map[key] = 2
	End Method
	
	Method JustReleased:Bool(key:Int)
		Return _map[key] = -1
	End Method
	
	Method Record:Stack<InputRecord>()
		Local data:Stack<InputRecord> = Null
		Local i:Int = 0
		Local is:InputState
		
		While (i < _TOTAL)
			is = _map[i]
			
			If (is.current = 0) Continue
			
			If (data = Null) Then
				data = New Stack<InputRecord>()
			End If
			
			data.Push(New InputRecord(i, is.current))
			
			i += 1
		Wend
		
		Return data
	End Method
	
	Method Playback:Void(record:Stack<InputRecord>)
		Local i:Int = 0
		Local l:Int = record.Length()
		Local ir:InputRecord
		
		While (i < l)
			ir = record[i]
			_map[ir.code].current = ir.value
			i += 1
		Wend
	End Method
	
	Method Any:Bool()
		Local i:Int = 0
		 	
		While (i < _TOTAL)
			If (_map[i].current > 0) Then
				If (i <> MOUSE_LEFT And i <> MOUSE_RIGHT And i <> MOUSE_MIDDLE) Then
					Return True
				End If
			End If
			i += 1
		Wend
		
		Return False
	End Method

End Class

Private
Class InputState
	
	Field current:Int
	Field last:Int
	
	Method New()
		current = 0
		last = 0	
	End Method

End Class