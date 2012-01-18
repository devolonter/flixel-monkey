Strict

Class Input Abstract
	
Private
	Field _map:InputState[]
	Field _total:Int
	
Public
	Method New()
		_total = GetTotal()
		_map = _map.Resize(_total)
		
		Local i:Int = 0
			
		While (i < _total)
			_map = New InputState()
			i += 1
		Wend
	End Method
	
	Method Update:Void()
		Local i:Int = 0
		Local is:InputState
		 	
		While (i < _total)
			is = _map[i]
			
			If (GetState(i)) Then
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
		 	
		While (i < _total)
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
		
		While (i < _total)
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
		 	
		While (i < _total)
			If (_map[i].current > 0) Return True
			i += 1
		Wend
		
		Return False
	End Method
	
	Method Destroy:Void()
		_total = 0
	End Method

	Method GetTotal:Int() Abstract
	
	Method GetState:Bool(index:Int) Abstract

End Class

Class InputRecord
	
	Field code:Int
	Field value:Int
	
	Method New (code:Int, value:Int)
		Self.code = code
		Self.value = value
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