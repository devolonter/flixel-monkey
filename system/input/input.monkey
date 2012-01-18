Strict

Import mojo

Import flixel.flxg

Import flixel.system.replay.keyrecord

Class Input Abstract
	
Private
	Global _map:InputState[]
	Global _from:Int
	Global _to:Int
	
Public
	Method New()
		If (_to = 0) Then
			If (FlxG.mobile) Then
				_from = KEY_TOUCH0
				_to = KEY_TOUCH0 + 32
			Else
				_from = KEY_BACKSPACE
				_to = KEY_TOUCH0 + 1
			End If
		
			_map = _map.Resize(_to)
		
			Local i:Int = KEY_BACKSPACE
			While (i < KEY_TOUCH0 + 32)
				_map[i] = New InputState()
				i += 1
			Wend
		End If
	End Method
	
	Method Update:Void()
		Local i:Int = _from
		Local is:InputState
		
		While (i < _to)
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
		Local i:Int = _from
		Local is:InputState
		 	
		While (i < _to)
			is = _map[i]			
			is.current = 0
			is.last = 0
		Wend
	End Method
	
	Method Pressed:Bool(key:Int)
		Return _map[key].current > 0
	End Method
	
	Method JustPressed:Bool(key:Int)
		Return _map[key].current = 2
	End Method
	
	Method JustReleased:Bool(key:Int)
		Return _map[key].current = -1
	End Method
	
	Method Record:Stack<KeyRecord>()
		Local data:Stack<KeyRecord> = Null
		Local i:Int = _from
		Local is:InputState
		
		While (i < _to)
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
	
	Method Playback:Void(record:Stack<KeyRecord>)
		Local i:Int = 0
		Local l:Int = record.Length()
		Local kr:KeyRecord
		
		While (i < l)
			kr = record[i]
			_map[kr.code].current = kr.value
			i += 1
		Wend
	End Method
	
	Method Any:Bool()
		Local i:Int = _from
		 	
		While (i < _to)
			If (_map[i].current > 0) Return True
			i += 1
		Wend
		
		Return False
	End Method
	
	Method Destroy:Void()
		Local i:Int = _from
		 	
		While (i < _to)
			_map[i] = Null
			i += 1
		Wend
		
		_to = 0
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