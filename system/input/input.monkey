Strict

Import mojo

Import flixel.flxg
Import flixel.system.replay.keyrecord

Class Input Abstract	
	
Private
	Global _Map:Int[KEY_CLOSE + 1]
	
	Field _from:Int
	Field _to:Int
	
Public
	Method New(fromKey:Int, toKey:Int)		
		_from = fromKey
		_to = toKey + 1	
	End Method
	
	Method Destroy:Void()
		Reset()
		_from = 0
		_to = 0
	End Method
	
	Method Update:Void()
		Local i:Int = _from
		
		While (i < _to)
			If _Map[i] = OFF Then
                If KeyHit(i) Then _Map[i] = HIT
				
            ElseIf _Map[i] = HIT Then
                If KeyDown(i) Then
                    _Map[i] = DOWN
                Else
                    _Map[i] = UP
                End If
				
            Else
                If _Map[i] = UP Then
                   _Map[i] = OFF
                Else
                    If Not KeyDown(i) Then _Map[i] = UP
                End If
            End If
			
			i += 1
		Wend
	End Method
	
	Method Update:Void(x:Float, y:Float)
		Return
	End Method
	
	Method Reset:Void()
		Local i:Int = _from
		 	
		While (i < _to)
			_Map[i] = OFF
			i += 1
		Wend
	End Method
	
	Method Reset:Void(fromKey:Int, toKey:Int)
		Local i:Int = fromKey
		 	
		While (i < toKey)			
			_Map[i] = OFF
			i += 1
		Wend
	End Method
	
	Method Pressed:Bool()
		Return False
	End Method
	
	Method JustPressed:Bool()
		Return False
	End Method
	
	Method JustReleased:Bool()
		Return False
	End Method
	
	Method Used:Bool()
		Return False
	End Method
	
	Method Pressed:Bool(key:Int)
		Return _Map[key] > OFF
	End Method
	
	Method JustPressed:Bool(key:Int)
		Return _Map[key] = HIT
	End Method
	
	Method JustReleased:Bool(key:Int)
		Return _Map[key] = UP
	End Method
	
	Method Used:Bool(key:Int)
		Return _Map[key] <> OFF
	End Method
	
	Method RecordKeys:Stack<KeyRecord>(data:Stack<KeyRecord> = Null)
		Local i:Int = _from
		
		While (i < _to)
			If (_Map[i] = OFF) Then
				i += 1
				Continue
			End If
			
			If (data = Null) Then
				data = New Stack<KeyRecord>()
			End If
			
			data.Push(New KeyRecord(i, _Map[i]))
		Wend
		
		Return data
	End Method
	
	Method PlaybackKeys:Void(record:Stack<KeyRecord>)
		Local i:Int = 0
		Local l:Int = record.Length()
		Local kr:KeyRecord
		
		While (i < l)
			kr = record.Get(i)
			_Map[kr.code] = kr.value
			i += 1
		Wend
	End Method
	
	Method Any:Bool()
		Local i:Int = _from
		 	
		While (i < _to)
			If (_Map[i] <> OFF) Return True
			i += 1
		Wend
		
		Return False
	End Method
	
	Private
	
	Const OFF:Int = 0
	
    Const HIT:Int = 2
	
    Const DOWN:Int = 1
	
    Const UP:Int = -1

End Class
