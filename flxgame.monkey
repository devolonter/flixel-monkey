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
	
	Field _replayTimer:Float
	
	Field _replayCallback:FlxReplayListener

Private
	Field _iState:FlxClass
	
	Field _created:Bool
	
	Field _total:Int
	
	Field _accumulator:Float	
	
	Field _step:Float
	
	Field _maxAccumulation:Float
	
	Field _soundTrayTimer:Float
	
	Field _soundTrayWidth:Float
	
	Field _soundTrayHeight:Float
	
	Field _soundTrayX:Float
	
	Field _soundTrayY:Float
	
	Field _soundTrayVisible:Bool
	
	Field _soundTrayLabel:FlxText
	
	Field _updaterate:Int
	
	Field _framerate:Int

Public
	Method New(gameSizeX:Int, gameSizeY:Int, initialState:FlxClass, zoom:Float = 1, updaterate:Int = 60, framerate:Int = 30, useSystemCursor:Bool = False)		
		_soundTrayTimer = 0
		_soundTrayWidth = 160
		_soundTrayHeight = 60
		_soundTrayX = 0
		_soundTrayY	= -_soundTrayHeight
		_soundTrayVisible = False
		
		FlxG.Init(Self, gameSizeX, gameSizeY, zoom)
		FlxG.Framerate = framerate
		FlxG.Updaterate = updaterate
		_total = 0
		
		_state = Null
		
		useSoundHotKeys = Not IsMobile()
		Self.useSystemCursor = useSystemCursor
		useVirtualResolution = True
		
		If (Not useSystemCursor) HideMouse()
		
		forceDebugger = False
		_debuggerUp = False		
		
		_replay = New FlxReplay()
		_replayRequested = False
		_recordingRequested = False
		_replaying = False
		_recording = False
		
		_iState = initialState
		_requestedState = Null
		_requestedReset = True
		_created = False		
	End Method
	
	Method OnCreate:Int()	
		_InitData()		
		_Step()
		
		_soundTrayX	= (FlxG.Width / 2) * FlxCamera.DefaultZoom * FlxG._DeviceScaleFactorX - (_soundTrayWidth / 2) + FlxG.Camera.X
		_soundTrayLabel = New FlxText(10, 32, _soundTrayWidth, "VOLUME")
		_soundTrayLabel.SetFormat(FlxText.SYSTEM_FONT, 16, FlxG.WHITE, FlxText.ALIGN_CENTER)
		Return 0
	End Method
	
	Method OnUpdate:Int()
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
			
			_UpdateSoundTray(_step)
		#End
		
		Return 0
	End Method
	
	Method OnRender:Int()
		If (FlxG.Framerate <> _framerate Or FlxG.Updaterate <> _updaterate) Then			
			_ResetFramerate()
		End If
	
		Local mark:Int = Millisecs()
		Local elapsedMS:Int = mark - _total
		_total = mark	
		
		If (_debugger <> Null) Then
			'TODO!			
		Else			
			_accumulator += elapsedMS
			
			if (_accumulator > _maxAccumulation) Then
				_accumulator = _maxAccumulation
			End If			
						
			While (_accumulator >= _step)
				_Step()
				_accumulator -= _step
			Wend
		End If
	
		FlxBasic._VisibleCount = 0
			
		_Draw()
		
		Return 0
	End Method
	
	Method OnSuspend:Int()
		ShowMouse()
		FlxG.PauseSounds()
		Return 0
	End Method
	
	Method OnResume:Int()
		If (Not _debuggerUp And Not useSystemCursor) Then
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
		FlxG.ResetInput()
		FlxG.DestroySounds()
		FlxG.ClearBitmapCache()
		
		If (_debugger <> Null) Then
			'TODO!
		End If		
		
		Local timeManager:TimerManager = FlxTimer.Manager()
		If (timeManager <> Null) timeManager.Clear()		
		
		If (_state <> Null) _state.Destroy()		
		
		_state = _requestedState
		_state.Create()
		
		If (FlxG.Framerate <> _framerate Or FlxG.Updaterate <> _updaterate) Then						
			_ResetFramerate()
		End If
	End Method

	Method _Step:Void()	
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
	
	Method _Update:Void()
		FlxG.Elapsed = FlxG.TimeScale * (_step / 1000.0)
				
		FlxG.UpdateSounds()	
		FlxG.UpdatePlugins()		
		_state.Update()
		FlxG.UpdateCameras()
		
		If (_debuggerUp) Then
			'TODO!
		End If
	End Method
	
	Method _UpdateSoundTray:Void(ms:Int)
		If (Not _soundTrayVisible) Return
	
		If (_soundTrayTimer > 0) Then
			_soundTrayTimer -= ms / 1000.0
		
		ElseIf (_soundTrayY > -_soundTrayHeight)
			_soundTrayY =_soundTrayY - (ms / 1000.0 * FlxG.Height * 2)
			
			If (_soundTrayY <= -_soundTrayHeight) Then
				_soundTrayVisible = False
				
				'TODO Save sound settings
			End If
		End If
	End Method
	
	Method _Draw:Void()
		Cls(FlxG._BgColor.r, FlxG._BgColor.g, FlxG._BgColor.b)
		
		PushMatrix()	
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
		
		PopMatrix()
		
		#If TARGET <> "ios" Or TARGET <> "android"
			_DrawSoundTray()
		#End
		
		FlxG.Mouse.Draw()		
	End Method
	
	Method _DrawSoundTray:Void()
		If (_soundTrayVisible) Then		
			Local globalVolume:Int = FlxU.Round(FlxG.Volume() * 10)
			If (FlxG.Mute) globalVolume = 0				
			
			PushMatrix()
			Translate(_soundTrayX, _soundTrayY)
			
			If (FlxG._LastDrawingAlpha <> .5) Then
				SetAlpha(.5)
				FlxG._LastDrawingAlpha = .5
			End If
			
			If (FlxG._LastDrawingColor <> FlxG.BLACK) Then
				SetColor(0, 0, 0)
			End If				
			
			DrawRect(0, 0, _soundTrayWidth, _soundTrayHeight)
			
			SetColor(255, 255, 255)
			FlxG._LastDrawingColor = FlxG.WHITE
			
			Local bx:Int = 20
			Local by:Int = 28

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
	End Method
	
	Method _Reset:Void()
		If (FlxG.Framerate <> _framerate Or FlxG.Updaterate <> _updaterate) Then			
			_ResetFramerate()
		End If
				
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
	End Method
	
	Method _ResetFramerate:Void()
		SetUpdateRate(FlxG.Framerate)

		_step = 1000.0 / FlxG.Updaterate		
		_maxAccumulation = 2000.0 / FlxG.Framerate - 1
		
		If (_maxAccumulation < _step) Then
			_maxAccumulation = _step
		End If
		
		_updaterate = FlxG.Updaterate
		_framerate = FlxG.Framerate
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
	
	Field _lastUpdateTime:Int

Public
	Method New()
		Reset()
	End Method
	
	Method Update:Void()
		If (_lastUpdateTime = 0) Then
			_lastUpdateTime = Millisecs()	
		ElseIf (Millisecs() - _lastUpdateTime >= 1000) Then
			FPS = _FPSCounter
			_lastUpdateTime = Millisecs()
			_FPSCounter = 0
		End If
		
		_FPSCounter += 1
	End Method
	
	Method Reset:Void()
		FPS = FlxG.Framerate
		_FPSCounter = 0
		_lastUpdateTime = 0
	End Method

End Class