Strict

Import mojo
Import reflection

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

#If  FLX_SOUND_EXTENSION = "unknown"

	Import "data/beep_flx.wav"
	Import "data/beep_flx.ogg"
	Import "data/beep_flx.mp3"

#Else

	Import "data/beep_flx.${FLX_SOUND_EXTENSION}"

#End

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
	
	Field _replayTimer:Float
	
	Field _replayCallback:FlxReplayListener

Private
	Field _iState:ClassInfo
	
	Field _step:Int
	
	Field _soundTrayTimer:Float
	
	Field _soundTrayWidth:Float
	
	Field _soundTrayHeight:Float
	
	Field _soundTrayX:Float
	
	Field _soundTrayY:Float
	
	Field _soundTrayVisible:Bool
	
	Field _soundTrayLabel:FlxText
	
	Field _updaterate:Int
	
	Field _switchStateListener:FlxSwitchStateListener

	'note: BUG: It seems we have bug in HTML5 vesion fo mojo	
#If TARGET = "html5" And Not FLX_WEBGL_ENABLED

	Field _stateIsReady:Bool

#End

Public
	Method New(gameSizeX:Int, gameSizeY:Int, initialState:ClassInfo, zoom:Float = 1, updaterate:Int = 60, useSystemCursor:Bool = False)
		Local classObject:GlobalInfo
		
		For Local classInfo:ClassInfo = EachIn GetClasses()
			classObject = classInfo.GetGlobal("__CLASS__", False)
			
			If (classObject <> Null) Then
				classObject.SetValue(classInfo)
			End If
		Next
	
		_soundTrayTimer = 0
		_soundTrayWidth = 160
		_soundTrayHeight = 45
		_soundTrayX = 0
		_soundTrayY	= -_soundTrayHeight
		_soundTrayVisible = False
		
		FlxG.Init(Self, gameSizeX, gameSizeY, zoom)
		FlxG.Updaterate = updaterate
		
		_state = Null
		
		useSoundHotKeys = Not FlxG.Mobile
		Self.useSystemCursor = useSystemCursor
		
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
	End Method
	
	Method OnCreate:Int()
		If ( Not useSystemCursor) HideMouse()
		_InitData()		
		_Reset()

		#Rem
		_soundTrayLabel = New FlxText(10, 32, _soundTrayWidth, "VOLUME")
		_soundTrayLabel.SetFormat(FlxText.SYSTEM_FONT, 16, FlxG.WHITE, FlxText.ALIGN_CENTER)
		#End
		Return 0
	End Method
	
	Method OnUpdate:Int()
		If (FlxG.Updaterate <> _updaterate) Then
			_ResetFramerate()
		End If
		
	#If FLX_ASYNC_EVENTS_ENABLED
		UpdateAsyncEvents()
	#End
	
		FlxG.UpdateDevice()
		_Step()
	
	#If TARGET <> "ios" And TARGET <> "android" And TARGET <> "psm"
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
	#If FLX_DEBUG_ENABLED
		FlxBasic._VisibleCount = 0
	#End
	
	#If TARGET = "html5" And Not FLX_WEBGL_ENABLED

		If ( Not _stateIsReady And _state) Then
			Cls(FlxG._BgColor.r, FlxG._BgColor.g, FlxG._BgColor.b)
			_state.Create()
			_stateIsReady = True
			Cls(FlxG._BgColor.r, FlxG._BgColor.g, FlxG._BgColor.b)
			
			Return 0
		End If
	
	#End	
		_Draw()
		Return 0
	End Method
	
	Method OnSuspend:Int()
		ShowMouse()
		FlxG.PauseSounds()
		Return 0
	End Method
	
	Method OnResume:Int()
	#If FLX_DEBUG_ENABLED
		If (Not _debuggerUp And Not useSystemCursor) Then
			HideMouse()
		End If
	#Else
		If ( Not useSystemCursor) Then
			HideMouse()
		End If
	#End
		
		FlxG.ResetInput()
		FlxG.ResumeSounds()
		Return 0
	End Method
	
	Method OnBack:Int()
		If (_state = Null Or _state.DoBack()) Then
			Return Super.OnBack()
		End If
		
		Return 0
	End Method
	
	Method OnClose:Int()
		If (_state = Null Or _state.DoClose()) Then
			Return Super.OnClose()
		End If
		
		Return 0
	End Method
	
	Method SetSwitchStateListener:Void(listener:FlxSwitchStateListener)
		_switchStateListener = listener
	End Method
	
	Method OnContentInit:Void()
	End Method
	
Private
	Method _ShowSoundTray:Void(silent:Bool = False)
		If (Not silent) Then
			FlxG.Play("beep" + FlxG.DATA_SUFFIX)
		End If
		
		_soundTrayTimer = 1
		_soundTrayY = 0
		_soundTrayVisible = True
	End Method

	Method _SwitchState:Void()
		FlxG.ResetCameras()
		FlxG.ResetInput()
		FlxG.DestroySounds()
	
	#If FLX_DEBUG_ENABLED
		If (_debugger <> Null) Then
			'note: TODO:!
		End If
	#End
		
		Local timeManager:TimerManager = FlxTimer.Manager()
		If (timeManager <> Null) timeManager.Clear()		
		
		If (_state <> Null) _state.Destroy()
		If (_switchStateListener <> Null) _switchStateListener.OnSwitchState(_state, _requestedState)
		
		_state = _requestedState
		
	#If TARGET = "html5" And Not FLX_WEBGL_ENABLED
	
		_stateIsReady = False
		
	#Else
	
		BeginRender()
			Cls(FlxG._BgColor.r, FlxG._BgColor.g, FlxG._BgColor.b)
			_state.Create()
			Cls(FlxG._BgColor.r, FlxG._BgColor.g, FlxG._BgColor.b)
		EndRender()
		
	#End				
		
		If (FlxG.Updaterate <> _updaterate) Then
			_ResetFramerate()
		End If
	End Method

	Method _Step:Void()
		If (_requestedReset) Then
			_Reset()
		End If
		
		If (_recordingRequested) Then
			_recordingRequested = False
			_replay.Create(FlxG.GlobalSeed)
			_recording = True
		
		#If FLX_DEBUG_ENABLED
			If (_debugger <> Null) Then
				'note: TODO:
				FlxG.Log("FLIXEL: starting new flixel gameplay record.")
			End If
		#End
			
		ElseIf (_replayRequested)
			_replayRequested = False
			_replay.Rewind()
			FlxG.GlobalSeed = _replay.seed
		
		#If FLX_DEBUG_ENABLED
			If (_debugger <> Null) Then
				'note: TODO:
			End If
		#End
			
			_replaying = True
		End If
		
	#If TARGET = "html5" And Not FLX_WEBGL_ENABLED
	
		If (_state <> _requestedState) Then
			_SwitchState()
			Return
		End If
		
		If ( Not _stateIsReady) Return
		
	#Else
	
		If (_state <> _requestedState) _SwitchState()
		
	#end
		
	#If FLX_DEBUG_ENABLED
		FlxBasic._ActiveCount = 0
	#End
		
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
			
		#If FLX_DEBUG_ENABLED
			If (_debugger <> Null) Then
				'note: TODO:
			End If
		#End
				
		Else
			FlxG.UpdateInput()
		End If
		
		If (_recording) Then
			_replay.RecordFrame()
		
		#If FLX_DEBUG_ENABLED
			If (_debugger <> Null) Then
				'note: TODO:
			End If
		#End
		
		End If
		
		_Update()
		
	#If FLX_DEBUG_ENABLED
		If (_debugger <> Null) Then
			'note: TODO:
		End If
	#End	
	End Method	
	
	Method _Update:Void()
		FlxG.Elapsed = FlxG.TimeScale * (_step / 1000.0)
				
		FlxG.UpdateSounds()	
		FlxG.UpdatePlugins()		
		_state.DoUpdate()
		
		If (FlxG.Tweener.active And FlxG.Tweener.HasTween) Then
			FlxG.Tweener.UpdateTweens()
		End If
		
		FlxG.UpdateCameras()
	
	#If FLX_DEBUG_ENABLED
		If (_debuggerUp) Then
			'note: TODO:!
		End If
	#End	
	End Method
	
	Method _UpdateSoundTray:Void(ms:Int)
		If (Not _soundTrayVisible) Return
	
		If (_soundTrayTimer > 0) Then
			_soundTrayTimer -= ms / 1000.0
		
		ElseIf (_soundTrayY > -_soundTrayHeight)
			_soundTrayY =_soundTrayY - (ms / 1000.0 * FlxG.Height * 2)
			
			If (_soundTrayY <= -_soundTrayHeight) Then
				_soundTrayVisible = False
				
				'note: TODO: Save sound settings
			End If
		End If
	End Method
	
	Method _Draw:Void()
		Cls(FlxG._BgColor.r, FlxG._BgColor.g, FlxG._BgColor.b)
	
	#If TARGET <> "ios" And TARGET <> "android" And TARGET <> "psm" And TARGET <> "winrt"
		If( Not FlxG.Mobile) Then
			PushMatrix()
		End If
	#End
		
		Translate(FlxG._DeviceOffsetX, FlxG._DeviceOffsetY)
		Scale(FlxG._DeviceScaleFactorX, FlxG._DeviceScaleFactorY)
		
		FlxG._LastDrawingColor = FlxG.WHITE
		FlxG._LastDrawingBlend = GetBlend()
		FlxG._LastDrawingAlpha = GetAlpha()
		FlxG._CurrentCamera = Null
		
		Local i:Int = 0
		Local l:Int = FlxG.Cameras.Length()		
		
		While(i < l)		
			FlxG._CurrentCamera = FlxG.Cameras.Get(i)

			If (FlxG._CurrentCamera <> Null And FlxG._CurrentCamera.active And FlxG._CurrentCamera.exists And FlxG._CurrentCamera.visible) Then
				FlxG._CurrentCamera.DrawFX() 'not really draw. Only calculation
				FlxG._CurrentCamera.Lock()			
				_state.DoDraw()
				FlxG.DrawPlugins()			
				FlxG._CurrentCamera.Unlock()
			End If
									
			i+=1
		Wend
		
	#If TARGET <> "ios" And TARGET <> "android" And TARGET <> "psm" And TARGET <> "winrt"
		If( Not FlxG.Mobile) Then
			PopMatrix()
			_DrawSoundTray()
			FlxG.Mouse.Draw()
		End If
	#End	
	End Method
	
	Method _DrawSoundTray:Void()
		If (_soundTrayVisible) Then		
			Local globalVolume:Int = FlxU.Round(FlxG.Volume() * 10)
			If (FlxG.Mute) globalVolume = 0			
			
			PushMatrix()

			Transform(FlxG._DeviceScaleFactorX, 0, 0, FlxG._DeviceScaleFactorY, ( (FlxG.DeviceWidth - _soundTrayWidth * FlxG._DeviceScaleFactorX) * 0.5), _soundTrayY)
			
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
						
			'_soundTrayLabel.Draw()
			
			PopMatrix()
		End If
	End Method
	
	Method _Reset:Void()
		_requestedReset = False
		_requestedState = FlxState(_iState.NewInstance())
		_replayTimer = 0
		_replayCancelKeys =[]
	
		If (FlxG.Updaterate <> _updaterate) Then			
			_ResetFramerate()
		End If
		
		Local date:Int[] = GetDate()
				
		Seed = (date[3] * 3600 + date[4] * 60 + date[5]) * 1000 + date[6]
		FlxG.UpdateDevice()
		
		FlxG.Reset()
	End Method
	
	Method _ResetFramerate:Void()
		SetUpdateRate(FlxG.Updaterate)
		_step = 1000 / FlxG.Updaterate
		_updaterate = FlxG.Updaterate
	End Method
	
	Method _InitData:Void()
		FlxAssetsManager.Init()
		
		Local minSystemFontSize:Int = 8
		Local maxSystemFontSize:Int = 24
		Local fontPathPrefix:String = FlxText.SYSTEM_FONT + "_font_"
		
		Local system:FlxFont = 	FlxAssetsManager.AddFont(FlxText.SYSTEM_FONT)	
		
		For Local size:Int = minSystemFontSize To maxSystemFontSize
			system.SetPath(size, fontPathPrefix + size + FlxG.DATA_SUFFIX)
		Next
		
		FlxAssetsManager.AddImage("default" + FlxG.DATA_SUFFIX, "default" +  FlxG.DATA_SUFFIX + ".png")
		FlxAssetsManager.AddImage("button" + FlxG.DATA_SUFFIX, "button" + FlxG.DATA_SUFFIX + ".png")
		FlxAssetsManager.AddImage(FlxTilemap.AUTOTILES, FlxTilemap.AUTOTILES + ".png")
		FlxAssetsManager.AddImage(FlxTilemap.AUTOTILES_ALT, FlxTilemap.AUTOTILES_ALT + ".png")
		FlxAssetsManager.AddCursor("cursor" + FlxG.DATA_SUFFIX, "cursor" + FlxG.DATA_SUFFIX + ".png")
		
		FlxAssetsManager.AddSound("beep" + FlxG.DATA_SUFFIX, "beep" + FlxG.DATA_SUFFIX + "." + FlxSound.GetValidExt())
		
		Local contentInitTrigger:FunctionInfo
				
		For Local classInfo:ClassInfo = EachIn GetClasses()
			contentInitTrigger = classInfo.GetFunction("OnContentInit",[], False)
			If (contentInitTrigger <> Null) contentInitTrigger.Invoke([])
		Next
		
		Self.OnContentInit()
	End Method
End Class
