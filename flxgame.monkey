Strict

Import mojo

Import flxg
Import flxbasic
Import flxstate
Import flxcamera
Import flxtimer
Import flxtext

Import plugin.timermanager
Import plugin.monkey.flxassetsmanager
Import plugin.monkey.flxfont

Class FlxGame extends App

Private
	Field _state:FlxState
	
	Field _iState:FlxClass
	
	Field _created:Bool

	Field _lostFocus:Bool
	
	Field _requestedState:FlxState
	
	Field _requestedReset:Bool
	
	Field _lastMillisecs:Float
	
	Field _step:Int
	
Public
	Method New(gameSizeX:Int, gameSizeY:Int, initialState:FlxClass, zoom:Float = 1, framerate:Int = 60, useSystemCursor:Bool = False)				
		_lostFocus = False		
		
		FlxG.Init(Self, gameSizeX, gameSizeY, zoom)
		FlxG.framerate = framerate		
		
		_state = Null
		
		_iState = initialState
		_requestedState = Null
		_requestedReset = True
		_created = False 				
	End Method
	
	Method OnCreate:Int()
		SetUpdateRate(FlxG.framerate)
		Seed = flixel.SystemMillisecs()
		
		FlxG.DEVICE_WIDTH = DeviceWidth()
		FlxG.DEVICE_HEIGHT = DeviceHeight()
		FlxG._deviceScaleFactorX = FlxG.DEVICE_WIDTH / Float(FlxG.width)
		FlxG._deviceScaleFactorY = FlxG.DEVICE_HEIGHT / Float(FlxG.height)		
		
		_InitData()		
		_step = 1000 / FlxG.framerate								
		_Step()				
		Return 0
	End Method
	
	Method OnUpdate:Int()		
		_Step()		
		Return 0
	End Method
	
	Method OnRender:Int()	
		Cls(FlxG._bgColor.r, FlxG._bgColor.g, FlxG._bgColor.b)		
		Scale(FlxG._deviceScaleFactorX, FlxG._deviceScaleFactorY)
		
		Local cam:FlxCamera
		Local cams:Stack<FlxCamera> = FlxG.cameras
		Local i:Int = 0
		Local l:Int = cams.Length()
		
		FlxG._lastDrawingColor = FlxG.WHITE
		FlxG._lastDrawingBlend = GetBlend()		
		
		While(i < l)
			cam = cams.Get(i)
			If (cam = Null Or Not cam.exists Or Not cam.visible) Continue
			
			cam.DrawFX() 'not realy draw. Only calculation
			cam.Lock()			
			_state.Draw()
			FlxG.DrawPlugins()			
			cam.Unlock()
									
			i+=1
		Wend
								
		Return 0	
	End Method
	
	Method OnContentInit:Void()
		
	End Method
	
	Method ToString:String()
		Return "FlxGame"	
	End Method
	
Private
	Method _SwitchState:Void()
		FlxG.ResetCameras()
		
		Local timeManager:TimerManager = FlxTimer.Manager()
		If (timeManager <> Null) timeManager.Clear()
		
		If (_state <> Null) _state.Destroy()		
		
		_state = _requestedState
		_state.Create()
		
		If (Millisecs() - _lastMillisecs > _step) Then
			_lastMillisecs = Millisecs() - _step
		End If
	End Method

	Method _Step:Void()
		If (_requestedReset) Then
			_requestedReset = False
			_requestedState = FlxState(_iState.CreateInstance())
			FlxG.Reset()
			_lastMillisecs = Millisecs() - _step			
		End If		
		
		If (_state <> _requestedState) _SwitchState()		
		
		_Update()
	End Method
	
	Method _Update:Void()
		FlxG.elapsed = FlxG.timeScale * ((Millisecs() - _lastMillisecs) / 1000.0)
		_lastMillisecs = Millisecs()
			
		FlxG.UpdatePlugins()		
		_state.Update()
		FlxG.UpdateCameras()
	End Method
	
	Method _InitData:Void()
		FlxAssetsManager.Init()
		
		Local minSystemFontSize:Int = 8
		Local maxSystemFontSize:Int = 24
		Local fontPathPrefix:String = FlxG.DATA_PREFIX + FlxText.SYSTEM_FONT + "_font"
		
		Local system:FlxFont = 	FlxAssetsManager.AddFont(FlxText.SYSTEM_FONT)	
		
		For Local size:Int = minSystemFontSize To maxSystemFontSize
			system.SetPath(size, fontPathPrefix + "_" + Min(size, 17) + ".png")
		Next
		
		Self.OnContentInit()
	End Method
End Class