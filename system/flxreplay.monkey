Strict

Import mojo

Import flixel.flxg
Import replay.keyrecord
Import replay.xyrecord
Import replay.xyzrecord
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
	
	Method Load:Void(fileContents:String)
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
				frameCount += 1
				
				If (frameCount >= _capacity) Then
					_capacity *= 2
					_frames = _frames.Resize(_capacity)
				End If				
			End If
			
			i += 1
		Wend
		
		Rewind()
	End Method
	
	Method Save:String()
		If (frameCount <= 0) Return ""
		
		Local output:StringStack = New StringStack()		
		output.Push(seed + "~n")	
		
		Local i:Int = 0
		While (i < frameCount)
			_frames[i].Save(output)
			output.Push("~n")
			i += 1
		Wend
	
		Return output.Join("")
	End Method
	
	Method RecordFrame:Void()
		Local accelRecord:XYZRecord
		Local joystickRecord:Stack<XYZRecord[]>
		Local touchRecord:Stack<XYRecord>
		Local keysRecord:Stack<KeyRecord>
		Local mouseRecord:XYRecord
	
		
	#If FLX_ACCEL_ENABLED = "1"
		accelRecord = FlxG.Accel.RecordXYZ()
	#End
	
	#If FLX_JOYSTICK_ENABLED = "1"
		Local joyCount:Int = FlxG.JoystickCount()
		Local joyXYZRecord:XYZRecord[]
	
		For Local i:Int = 0 Until joyCount
			joyXYZRecord = FlxG.Joystick(i).RecordXYZ()
			
			If (joyXYZRecord.Length() > 0) Then
				If (joystickRecord = Null) joystickRecord = New Stack<XYZRecord[]>()
				joystickRecord.Insert(i, joyXYZRecord)
			End If				
			
			keysRecord = FlxG.Joystick(i).RecordKeys(keysRecord)
		Next
	#End
	
	#If FLX_MULTITOUCH_ENABLED = "1"
		Local touchCount:Int = FlxG.TouchCount()
		Local touchXYRecord:XYRecord
	
		For Local i:Int = 1 Until touchCount
			If ( Not FlxG.Touch(i).Used) Exit
		
			touchXYRecord = FlxG.Touch(i).RecordXY()
		
			If (touchXYRecord <> Null) Then
				If (touchRecord = Null) touchRecord = New Stack<XYRecord>()				
				touchRecord.Insert(i, touchXYRecord)
			End If
			
			keysRecord = FlxG.Touch(i).RecordKeys(keysRecord)
		Next
	#End
		
	#If FLX_KEYBOARD_ENABLED = "1"
		keysRecord = FlxG.Keys.RecordKeys(keysRecord)
	#End
	
	#If FLX_MOUSE_ENABLED = "1"	
		mouseRecord = FlxG.Mouse.RecordXY()
		Local touch0XYRecord:XYRecord = FlxG.Touch(0).RecordXY()
		
		If (touch0XYRecord <> Null) Then
			If (touchRecord = Null) touchRecord = New Stack<XYRecord>()				
			touchRecord.Insert(0, touch0XYRecord)
		End If
		
		keysRecord = FlxG.Touch(0).RecordKeys(keysRecord)
	#End
			
		If (keysRecord = Null And mouseRecord = Null And joystickRecord = Null And touchRecord = Null And accelRecord = Null) Then
			frame += 1
			Return
		End If
		
		_frames[frameCount] = (New FrameRecord()).Create(frame, keysRecord, mouseRecord, joystickRecord, touchRecord, accelRecord)
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
		
		If (fr.keys <> Null) FlxG.Keys.PlaybackKeys(fr.keys)
		If (fr.mouse <> Null) FlxG.Mouse.PlaybackXY(fr.mouse)
		
		If (fr.joystick <> Null) Then
			Local i:Int = 0
			Local l:Int = fr.joystick.Length()
			
			While (i < l)
				FlxG.Joystick(i).PlaybackXYZ(fr.joystick.Get(i))
				i += 1
			Wend			
		End If
		
		If (fr.touch <> Null) Then
			Local i:Int = 0
			Local l:Int = FlxG.TouchCount()
			Local tr:XYRecord
			
			While (i < l)
				tr = fr.touch.Get(i)				
				If (tr = Null) Exit	
			
				FlxG.Touch(i).PlaybackXY(tr)
				
				i += 1
			Wend			
		End If
		
		If (fr.accel <> Null) FlxG.Accel.PlaybackXYZ(fr.accel)
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

Interface FlxReplayListener
	
	Method OnReplayComplete:Void()

End Interface
