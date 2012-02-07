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
	
	Field useVirtualResolution:Bool
	
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
	
	Field _updatesCounter:FlxFPSCounter
	
	Field _rendersCounter:FlxFPSCounter	
	
Public
	Method New(gameSizeX:Int, gameSizeY:Int, initialState:FlxClass, zoom:Float = 1, framerate:Int = 60, useSystemCursor:Bool = False)				
		_lostFocus = False		
		
		FlxG.Init(Self, gameSizeX, gameSizeY, zoom)
		FlxG.Framerate = framerate
		
		useSoundHotKeys = Not IsMobile()
		Self.useSystemCursor = useSystemCursor
		useVirtualResolution = True
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
		
		_updatesCounter = New FlxFPSCounter()
		_rendersCounter = New FlxFPSCounter()				
	End Method
	
	Method OnCreate:Int()
		_Reset()		
		_InitData()		
		_Step()
		
		_soundTrayX	= (FlxG.Width / 2) * FlxCamera.DefaultZoom - (_soundTrayWidth / 2)
		_soundTrayLabel = New FlxText(10, 32, _soundTrayWidth, "VOLUME")
		_soundTrayLabel.SetFormat(FlxText.SYSTEM_FONT, 16, FlxG.WHITE, FlxText.ALIGN_CENTER)
		Return 0
	End Method
	
	Method OnUpdate:Int()
		If (_rendersCounter.FPS >= 0 And _rendersCounter.FPS < 30) Then
			_updatesCounter.Update()
			
			FlxG.Elapsed = FlxG.TimeScale * (1.0 / _updatesCounter.FPS)		
			_Step()	
		End If	
		Return 0
	End Method
	
	Method OnRender:Int()
		If (Not _replaying) Then	
			_rendersCounter.Update()
		End If						
		
		If (_rendersCounter.FPS >= 30) Then
			FlxG.Elapsed = FlxG.TimeScale * (1.0 / _rendersCounter.FPS)
			_Step()
		End If			
		
		Cls(FlxG._BgColor.r, FlxG._BgColor.g, FlxG._BgColor.b)		
		Scale(FlxG._DeviceScaleFactorX, FlxG._DeviceScaleFactorY)		
		
		FlxG._LastDrawingColor = FlxG.WHITE
		FlxG._LastDrawingBlend = GetBlend()
		FlxG._LastDrawingAlpha = GetAlpha()
		FlxG._CurrentCamera = Null
		
		Local i:Int = 0
		Local l:Int = FlxG.Cameras.Length()		
		
		While(i < l)		
			FlxG._CurrentCamera = FlxG.Cameras.Get(i)
			
			If (Not FlxG._CurrentCamera.active) Then
				i+=1
				Continue
			End If
			
			FlxG._CurrentCameraID = i
			
			If (FlxG._CurrentCamera = Null Or Not FlxG._CurrentCamera.exists Or Not FlxG._CurrentCamera.visible) Continue
			
			FlxG._CurrentCamera.DrawFX() 'not realy draw. Only calculation
			FlxG._CurrentCamera.Lock()			
			_state.Draw()
			FlxG.DrawPlugins()			
			FlxG._CurrentCamera.Unlock()
									
			i+=1
		Wend
		
		#If TARGET <> "ios" Or TARGET <> "android"
			If (_soundTrayVisible) Then			
				Local globalVolume:Int = FlxU.Round(FlxG.Volume() * 10)
				If (FlxG.Mute) globalVolume = 0
				
				Local bx:Int = 20
				Local by:Int = 28
				
				If (FlxG._LastDrawingColor <> FlxG.WHITE) Then
					SetColor(255, 255, 255)
					FlxG._LastDrawingColor = FlxG.WHITE
				End If
				
				PushMatrix()
				Translate(_soundTrayX, _soundTrayY)
	
				Local i:Int = 0
				While (i < 10)
					If (i < globalVolume) Then
						If (FlxG._LastDrawingAlpha <> 1) Then
							SetAlpha(1)
							FlxG._LastDrawingAlpha = 1
						End If
						
					Else
						If (FlxG._LastDrawingAlpha <> .5) Then
							SetAlpha(.5)
							FlxG._LastDrawingAlpha = .5
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
		
		FlxG.Mouse.Draw()
		
		#If CONFIG = "debug"
			SetColor(255, 255, 255)
			DrawText("FPS: " + _renderFPS, 10, 10)
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
		#If TARGET <> "ios" Or TARGET <> "android"
			If (useSoundHotKeys) Then
				If (KeyHit(KEY_0)) Then
					FlxG.Mute = Not FlxG.Mute
					
					If (FlxG.VolumeHandler <> Null) Then
						If (FlxG.Mute) Then
							FlxG.VolumeHandler.OnVolumeChange(0)
						Else
							FlxG.VolumeHandler.OnVolumeChange(FlxG.Volume())
						End If
					End If
					
					_ShowSoundTray()
				End If
			
				If (KeyHit(KEY_MINUS)) Then
					FlxG.Mute = False
					FlxG.Volume(FlxG.Volume() - .1)
					_ShowSoundTray()
				End If
				
				If (KeyHit(KEY_EQUALS)) Then
					FlxG.Mute = False
					FlxG.Volume(FlxG.Volume() + .1)
					_ShowSoundTray()
				End If	
			End If
			
			_UpdateSoundTray()
		#End
	
		If (_requestedReset) Then
			_requestedReset = False
			_requestedState = FlxState(_iState.CreateInstance())
			_replayTimer = 0
			_replayCancelKeys = []
			_Reset()
			FlxG.Reset()		
		End If
		
		If (_recordingRequested) Then
			_recordingRequested = False
			_replay.Create(FlxG.GlobalSeed)
			_recording = True
			
			If (_debugger <> Null) Then
				'TODO
				FlxG.Log("FLIXEL: starting new flixel gameplay record.")
			End If
			
		ElseIf (_replayRequested)
			_replayRequested = False
			_replay.Rewind()
			FlxG.GlobalSeed = _replay.seed
			
			If (_debugger <> Null) Then
				'TODO
			End If
			
			_replaying = True
		End If
		
		If (_state <> _requestedState) _SwitchState()
		
		FlxBasic._ActiveCount = 0
		
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
			_soundTrayTimer -= FlxG.Elapsed
		
		ElseIf (_soundTrayY > -_soundTrayHeight)
			_soundTrayY =_soundTrayY - (FlxG.Elapsed * FlxG.Height * 2)
			
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
	
	Method _Reset:Void()
		SetUpdateRate(FlxG.Framerate)
		Seed = SystemMillisecs()
		
		FlxG.DeviceWidth = DeviceWidth()
		FlxG.DeviceHeight = DeviceHeight()
		
		If (useVirtualResolution) Then
			FlxG._DeviceScaleFactorX = FlxG.DeviceWidth / Float(FlxG.Width)
			FlxG._DeviceScaleFactorY = FlxG.DeviceHeight / Float(FlxG.Height)
		Else
			FlxG._DeviceScaleFactorX = 1
			FlxG._DeviceScaleFactorY = 1
		End If
		
		_step = 1000.0 / FlxG.Framerate
		
		_updatesCounter.Reset()
		_rendersCounter.Reset()
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

Private
Class FlxFPSCounter
	
	Field FPS:Int	

Private	
	Field _FPSCounter:Int
	
	Field _lastFPSCounter:Int
	
	Field _lastUpdateTime:Int
	
Public
	Method New()
		Reset()
	End Method
	
	Method Update:Void()
		If (FPS < 0) Then
			_lastUpdateTime = Millisecs()
			FPS = FlxG.Framerate
			_lastFPSCounter = FPS
		Else
			If (Millisecs() - _lastUpdateTime > 1000) Then
				If (Abs(_lastFPSCounter - _FPSCounter) < 10) Then
					FPS = _FPSCounter
				End If
				
				_lastFPSCounter = _FPSCounter
				_FPSCounter = 0
				_lastUpdateTime = Millisecs()
			Else
				_FPSCounter += 1
			End If
		End If
	End Method
	
	Method Reset:Void()
		FPS = -1
		_FPSCounter = 0
		_lastFPSCounter = 0
		_lastUpdateTime = 0
	End Method

End Class