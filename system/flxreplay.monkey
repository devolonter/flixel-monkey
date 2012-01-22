Strict

Import flixel.flxg
Import replay.keyrecord
Import replay.xyrecord
Import replay.framerecord

Class FlxReplay
	
	Field seed:Float
	
	Field frame:Int
	
	Field frameCount:Int
	
	Field finished:Bool
	
Private
	Field _frames:FrameRecord[]
	
	Field _capacity:Int
	
	Field _marker:Int
	
Public
	Method New()
		seed = 0
		frame = 0
		frameCount = 0
		finished = False
		_frames = []
		_capacity = 0
		_marker = 0
	End Method
	
	Method Destroy:Void()
		If (_frames.Length() = 0) Return
		
		Local i:Int = frameCount - 1
		
		While (i >= 0)
			_frames[i].Destroy()
			i -= 1
		Wend
		
		_frames = []
	End Method	
	
	Method Create:Void(seed:Int)
		Destroy()
		_Init()
		Self.seed = seed
		Rewind()
	End Method
	
	Method Load:String(fileContents:String)
		_Init()
		
		Local lines:String[] = fileContents.Split("~n")
		
		seed = Int(lines[0])
		
		Local line:String
		Local i:Int = 1
		Local l:Int = lines.Length()
		
		While (i < l)
			line = lines[i]
			
			If (line.Length() > 3) Then
				_frames[frameCount] = (New FrameRecord()).Load(line)
				
				If (frameCount >= _capacity) Then
					_capacity *= 2
					_frames = _frames.Resize(_capacity)
				End If
				
				frameCount += 1
			End If
			
			i += 1
		Wend
		
		Rewind()
	End Method
	
	Method Save:String()
		If (frameCount <= 0) Return ""
		
		Local output:StringStack = New StringStack()
		Local i:Int = 0
		
		While (i < frameCount)
			_frames[i].Save(output)
			output.Push("\n")
			i += 1
		Wend
	
		Return output.Join("")
	End Method
	
	Method RecordFrame:Void()
		Local keysRecord:Stack<KeyRecord> = FlxG.keys.RecordKeys()
		Local mouseRecord:XYRecord = FlxG.mouse.RecordXY()
		
		If (keysRecord = Null And mouseRecord = Null) Then
			frame += 1
			Return
		End If
		
		_frames[frameCount] = (New FrameRecord(frame, keysRecord, mouseRecord)).Create()
		frame += 1
		frameCount += 1
		
		If (frameCount >= _capacity) Then
			_capacity *= 2
			_frames = _frames.Resize(_capacity)
		End If 
	End Method
	
	Method PlayNextFrame:Void()
		FlxG.ResetInput()
		
		If (_marker >= frameCount) Then
			finished = True
			Return
		End If
		
		If (_frames[_marker].frame <> frame) Then
			frame += 1
			Return
		End If
		
		frame += 1
		
		Local fr:FrameRecord = _frames[_marker]
		_marker += 1
		
		If (fr.keys <> Null) FlxG.keys.PlaybackKeys(fr.keys)
		If (fr.mouse <> Null) FlxG.mouse.PlaybackXY(fr.mouse)
	End Method
	
	Method Rewind:Void()
		_marker = 0
		frame = 0
		finished = False
	End Method
	
Private
	Method _Init:Void()
		_capacity = 100
		_frames = _frames.Resize(_capacity)
		frameCount = 0
	End Method

End Class