Strict

Import mojo

Import flxextern
Import flxbasic
Import flxstate
Import flxcamera
Import flxtimer
Import flxtext
Import flxg
Import flxu
Import flxtilemap
Import system.flxassetsmanager
Import system.flxfont
Import system.flxdebugger
Import system.flxreplay
Import plugin.timermanager

Import "data/flx_beep.mp3"

'#HTML5_SUSPEND_ON_BLUR_ENABLED = "true"

Class FlxGame extends App

	Field useSoundHotKeys:Bool

	Field useSystemCursor:Bool
	
	Field forceDebugger:Bool

	Field _state:FlxState
	
	Field _requestedState:FlxState
	
	Field _requestedReset:Bool	
	
	Field _debugger:FlxDebugger
	
	Field _debuggerUp:Bool
	
	Field _replay:FlxReplay
	
	Field _replayRequested:Bool
	
	Field _recordingRequested:Bool	
	
	Field _replaying:Bool
	
	Field _recording:Bool
	
	Field _replayCancelKeys:Int[]
	
	Field _replayTimer:Int
	
	Field _replayCallback:FlxReplayListener

Private
	Field _iState:FlxClass
	
	Field _created:Bool

	Field _lostFocus:Bool	
	
	Field _step:Int
	
	Field _soundTrayTimer:Float
	
	Field _soundTrayWidth:Float
	
	Field _soundTrayHeight:Float
	
	Field _soundTrayX:Float
	
	Field _soundTrayY:Float
	
	Field _soundTrayVisible:Bool
	
	Field _soundTrayLabel:FlxText
	
	Field _targetElapsed:Float
	
	Field _fps:Int
	
	Field _fpsCounter:Int
	
	Field _fpsTime:Int
	
Public
	Method New(gameSizeX:Int, gameSizeY:Int, initialState:FlxClass, zoom:Float = 1, framerate:Int = 60, useSystemCursor:Bool = False)				
		_lostFocus = False		
		
		FlxG.Init(Self, gameSizeX, gameSizeY, zoom)
		FlxG.framerate = framerate
		
		useSoundHotKeys = Not IsMobile()
		Self.useSystemCursor = useSystemCursor
		If (Not useSystemCursor) HideMouse()
		_debuggerUp = False
		
		_state = Null
		
		_replay = New FlxReplay()
		_replayRequested = False
		_recordingRequested = False
		_replaying = False
		_recording = False
		
		_iState = initialState
		_requestedState = Null
		_requestedReset = True
		_created = False
		
		_soundTrayTimer = 0
		_soundTrayWidth = 160
		_soundTrayHeight = 60
		_soundTrayX = 0
		_soundTrayY	= -_soundTrayHeight
		_soundTrayVisible = False				
	End Method
	
	Method OnCreate:Int()
		SetUpdateRate(FlxG.framerate)
		Seed = SystemMillisecs()
		
		FlxG.deviceWidth = DeviceWidth()
		FlxG.deviceHeight = DeviceHeight()
		
		If (FlxG.targetWidth = 0) FlxG.targetWidth = FlxG.width
		If (FlxG.targetHeight = 0) FlxG.targetHeight = FlxG.height
		
		FlxG._deviceScaleFactorX = FlxG.deviceWidth / Float(FlxG.targetWidth)
		FlxG._deviceScaleFactorY = FlxG.deviceHeight / Float(FlxG.targetHeight)	
		
		_InitData()		
		_step = 1000.0 / FlxG.framerate
		_targetElapsed = 1.0 / FlxG.framerate
		_fps = -1
		_Step()
		
		_soundTrayX	= (FlxG.width / 2) * FlxCamera.defaultZoom - (_soundTrayWidth / 2)
		_soundTrayLabel = New FlxText(10, 32, _soundTrayWidth, "VOLUME")
		_soundTrayLabel.SetFormat(FlxText.SYSTEM_FONT, 16, FlxG.WHITE, FlxText.ALIGN_CENTER)
		Return 0
	End Method
	
	Method OnUpdate:Int()
		#If TARGET <> "ios" Or TARGET <> "android"
			If (useSoundHotKeys) Then
				If (KeyHit(KEY_0)) Then
					FlxG.mute = Not FlxG.mute
					
					If (FlxG.volumeHandler <> Null) Then
						If (FlxG.mute) Then
							FlxG.volumeHandler.OnVolumeChange(0)
						Else
							FlxG.volumeHandler.OnVolumeChange(FlxG.Volume())
						End If
					End If
					
					_ShowSoundTray()
				End If
			
				If (KeyHit(KEY_MINUS)) Then
					FlxG.mute = False
					FlxG.Volume(FlxG.Volume() - .1)
					_ShowSoundTray()
				End If
				
				If (KeyHit(KEY_EQUALS)) Then
					FlxG.mute = False
					FlxG.Volume(FlxG.Volume() + .1)
					_ShowSoundTray()
				End If	
			End If
		#End
	
		Return 0
	End Method
	
	Method OnRender:Int()
		If (_fps < 0) Then
			_fpsTime = Millisecs()
			_fps = FlxG.framerate
		Else
			If (Millisecs() - _fpsTime > 1000) Then
				_fps = _fpsCounter			
				_fpsCounter = 0
				_fpsTime = Millisecs()
			Else
				_fpsCounter += 1
			End If
		End If
	
		'Elapsed in Monkey very unstabled... TODO!
		If (_fps = FlxG.framerate) Then
			FlxG.elapsed = FlxG.timeScale * _targetElapsed
		Else
			FlxG.elapsed = FlxG.timeScale * (1.0 / _fps)
		End If		
		
		_UpdateSoundTray()
		_Step()			
		
		Cls(FlxG._bgColor.r, FlxG._bgColor.g, FlxG._bgColor.b)		
		Scale(FlxG._deviceScaleFactorX, FlxG._deviceScaleFactorY)		
		
		FlxG._lastDrawingColor = FlxG.WHITE
		FlxG._lastDrawingBlend = GetBlend()
		FlxG._lastDrawingAlpha = GetAlpha()
		FlxG._currentCamera = Null
		
		Local i:Int = 0
		Local l:Int = FlxG.cameras.Length()		
		
		While(i < l)
			FlxG._currentCamera = FlxG.cameras.Get(i)
			FlxG._currentCameraID = i
			
			If (FlxG._currentCamera = Null Or Not FlxG._currentCamera.exists Or Not FlxG._currentCamera.visible) Continue
			
			FlxG._currentCamera.DrawFX() 'not realy draw. Only calculation
			FlxG._currentCamera.Lock()			
			_state.Draw()
			FlxG.DrawPlugins()			
			FlxG._currentCamera.Unlock()
									
			i+=1
		Wend
		
		#If TARGET <> "ios" Or TARGET <> "android"
			If (_soundTrayVisible) Then			
				Local globalVolume:Int = FlxU.Round(FlxG.Volume() * 10)
				If (FlxG.mute) globalVolume = 0
				
				Local bx:Int = 20
				Local by:Int = 28
				
				If (FlxG._lastDrawingColor <> FlxG.WHITE) Then
					SetColor(255, 255, 255)
					FlxG._lastDrawingColor = FlxG.WHITE
				End If
				
				PushMatrix()
				Translate(_soundTrayX, _soundTrayY)
	
				Local i:Int = 0
				While (i < 10)
					If (i < globalVolume) Then
						If (FlxG._lastDrawingAlpha <> 1) Then
							SetAlpha(1)
							FlxG._lastDrawingAlpha = 1
						End If
						
					Else
						If (FlxG._lastDrawingAlpha <> .5) Then
							SetAlpha(.5)
							FlxG._lastDrawingAlpha = .5
						End If
					End If
					
					DrawRect(bx, by, 8, i * 2)				
					
					bx += 12
					by -= 2
					i += 1
				Wend
							
				_soundTrayLabel.Draw()
				
				PopMatrix()
			End If
		#End
		
		FlxG.mouse.Draw()
		
		#If CONFIG = "debug"
			DrawText("FPS: " + _fps, 10, 10)
		#End		
								
		Return 0	
	End Method
	
	Method OnSuspend:Int()
		ShowMouse()
		FlxG.PauseSounds()
		Return 0
	End Method
	
	Method OnResume:Int()
		If (Not _debuggerUp And useSystemCursor) Then
			HideMouse()
		End If
		FlxG.ResetInput()
		FlxG.ResumeSounds()
		Return 0
	End Method
	
	Method OnContentInit:Void()
	End Method
	
Private
	Method _ShowSoundTray:Void(silent:Bool = False)
		If (Not silent) Then
			FlxG.Play(FlxG.DATA_PREFIX + "beep")
		End If
		
		_soundTrayTimer = 1
		_soundTrayY = 0
		_soundTrayVisible = True
	End Method

	Method _SwitchState:Void()
		FlxG.ResetCameras()
		
		Local timeManager:TimerManager = FlxTimer.Manager()
		If (timeManager <> Null) timeManager.Clear()
		
		If (_state <> Null) _state.Destroy()		
		
		_state = _requestedState
		_state.Create()
	End Method

	Method _Step:Void()
		If (_requestedReset) Then
			_requestedReset = False
			_requestedState = FlxState(_iState.CreateInstance())
			_replayTimer = 0
			_replayCancelKeys = []
			FlxG.Reset()		
		End If
		
		If (_recordingRequested) Then
			_recordingRequested = False
			_replay.Create(FlxG.globalSeed)
			_recording = True
			
			If (_debugger <> Null) Then
				'TODO
				FlxG.Log("FLIXEL: starting new flixel gameplay record.")
			End If
			
		ElseIf (_replayRequested)
			_replayRequested = False
			_replay.Rewind()
			FlxG.globalSeed = _replay.seed
			
			If (_debugger <> Null) Then
				'TODO
			End If
			
			_replaying = True
		End If
		
		If (_state <> _requestedState) _SwitchState()
		
		FlxBasic._ACTIVECOUNT = 0
		
		If (_replaying) Then		
			If (_replayCancelKeys.Length() > 0 And Not KeyDown(192) And Not KeyDown(220)) Then
				Local i:Int = 0
				Local l:Int = _replayCancelKeys.Length()
				
				While (i < l) 
					If (KeyDown(_replayCancelKeys[i])) Then
						If (_replayCallback <> Null) Then
							_replayCallback.OnReplayComplete()
							_replayCallback = Null
						Else
							FlxG.StopReplay()
						End If
						
						Exit
					End If
					
					i += 1
				Wend
			End If
			
			_replay.PlayNextFrame()
			
			If (_replayTimer > 0) Then
				_replayTimer -= _step
				
				If (_replayTimer <= 0) Then
					If (_replayCallback <> Null) Then
						_replayCallback.OnReplayComplete()
						_replayCallback = Null
					Else
						FlxG.StopReplay()
					End If
				End If				
			End If
			
			If (_replaying And _replay.finished) Then
				FlxG.StopReplay()
				
				If (_replayCallback <> Null) Then
					_replayCallback.OnReplayComplete()
					_replayCallback = Null
				End If
			End If
			
			If (_debugger <> Null) Then
				'TODO
			End If
		Else
			FlxG.UpdateInput()
		End If
		
		If (_recording) Then
			_replay.RecordFrame()
						
			If (_debugger <> Null) Then
				'TODO
			End If
		End If
		
		_Update()
		
		If (_debugger <> Null) Then
			'TODO
		End If
	End Method
	
	Method _UpdateSoundTray:Void()
		If (Not _soundTrayVisible) Return
	
		If (_soundTrayTimer > 0) Then
			_soundTrayTimer -= FlxG.elapsed
		
		ElseIf (_soundTrayY > -_soundTrayHeight)
			_soundTrayY =_soundTrayY - (FlxG.elapsed * FlxG.height * 2)
			
			If (_soundTrayY <= -_soundTrayHeight) Then
				_soundTrayVisible = False
				
				'TODO Save sound settings
			End If
		End If
	End Method
	
	Method _Update:Void()			
		FlxG.UpdateSounds()	
		FlxG.UpdatePlugins()		
		_state.Update()
		FlxG.UpdateCameras()
	End Method
	
	Method _InitData:Void()
		FlxAssetsManager.Init()
		
		Local minSystemFontSize:Int = 8
		Local maxSystemFontSize:Int = 24
		Local fontPathPrefix:String = FlxG.DATA_PREFIX + FlxText.SYSTEM_FONT + "_font_"
		
		Local system:FlxFont = 	FlxAssetsManager.AddFont(FlxText.SYSTEM_FONT)	
		
		For Local size:Int = minSystemFontSize To maxSystemFontSize
			system.SetPath(size, fontPathPrefix + Min(size, 17) + ".png")
		Next
		
		FlxAssetsManager.AddImage(FlxG.DATA_PREFIX + "default", FlxG.DATA_PREFIX + "default.png")
		FlxAssetsManager.AddImage(FlxG.DATA_PREFIX + "button", FlxG.DATA_PREFIX + "button.png")
		FlxAssetsManager.AddImage(FlxTilemap.AUTOTILES, FlxTilemap.AUTOTILES + ".png")
		FlxAssetsManager.AddImage(FlxTilemap.AUTOTILES_ALT, FlxTilemap.AUTOTILES_ALT + ".png")
		FlxAssetsManager.AddCursor(FlxG.DATA_PREFIX + "cursor", FlxG.DATA_PREFIX + "cursor.png")
		FlxAssetsManager.AddSound(FlxG.DATA_PREFIX + "beep", FlxG.DATA_PREFIX + "beep.mp3")
		
		Self.OnContentInit()
	End Method
End Class