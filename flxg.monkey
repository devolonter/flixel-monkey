Strict

Import mojo

Import flxextern
Import flxgame
Import flxcamera
Import flxu

Import system.input.accel
Import system.input.joystick
Import system.input.keyboard
Import system.input.mouse
Import system.input.touch
Import system.flxresourcesmanager
Import system.flxquadtree
Import system.flxreplay

Import plugin.timermanager
Import plugin.debugpathdisplay

Class FlxG	

	Const LIBRARY_NAME:String = "Monkey Flixel"
	
	Const LIBRARY_MAJOR_VERSION:Int = 1
	
	Const LIBRARY_MINOR_VERSION:Int = 0
	
	Const DATA_PREFIX:String = "flx_"
	
	Const RED:Int = $FFFF0012
	
	Const GREEN:Int = $FF00F225
	
	Const BLUE:Int = $FF0090E9
	
	Const PINK:Int = $FFF01EFF
	
	Const WHITE:Int = $FFFFFFFF
	
	Const BLACK:Int = $FF000000
	
	Global deviceWidth:Int
	
	Global deviceHeight:Int
	
	Global targetWidth:Int
	
	Global targetHeight:Int
	
	Global width:Int
	
	Global height:Int
	
	Global worldBounds:FlxRect
	
	Global worldDivisions:Int
			
	Global cameras:Stack<FlxCamera>
	
	Global camera:FlxCamera
	
	Global plugins:Stack<FlxBasic>
	
	Global elapsed:Float
	
	Global timeScale:Float
	
	Global visualDebug:Bool

	Global mobile:Bool
	
	Global globalSeed:Int
	
	Global scores:Stack<String>	
	
	Global score:Int
	
	Global accel:Accel	
	
	Global keys:Keyboard
	
	Global mouse:Mouse
		
	Global framerate:Int
	
	Global _deviceScaleFactorX:Float = 1	
	
	Global _deviceScaleFactorY:Float = 1
	
	Global _bgColor:FlxColor = FlxColor.ARGB(FlxG.BLACK)		
	
	Global _game:FlxGame
	
	Global _cache:FlxResourcesManager<Image>
	
	Global _lastDrawingColor:Int
	
	Global _lastDrawingAlpha:Float
	
	Global _lastDrawingBlend:Int
	
	Global _currentCamera:FlxCamera

Private
	Const _JOY_UNITS_COUNT:Int = 4
	
	Const _TOUCH_COUNT:Int = 32
	
	Global _joystick:Joystick[_JOY_UNITS_COUNT]
	
	Global _touch:Touch[_TOUCH_COUNT]
	

Public
	Function GetLibraryName:String()
		Return FlxG.LIBRARY_NAME + " v" + FlxG.LIBRARY_MAJOR_VERSION + "." + FlxG.LIBRARY_MINOR_VERSION
	End Function
	
	Function Log:Void(data:String)
		Print data
		'TODO
	End Function
	
	Function Random:Float()
		FlxG.globalSeed = (FlxG.globalSeed * 1664525 + 1013904223)|0
		Return FlxU.Srand(FlxG.globalSeed)
	End Function
	
	Function GetRandom:FlxBasic(objects:FlxBasic[], startIndex:Int = 0, length:Int = 0)
		If (objects.Length() > 0) Then
			Local l:Int = length
			
			If (l = 0 Or l > objects.Length() - startIndex) Then
				l = objects.Length() - startIndex
			End if
			
			If (l > 0) Return objects[startIndex + int(FlxG.Random()*l)]	
		End If
		
		Return Null
	End Function
	
	#Rem
	Function GetRandom:Object(objects:Object[], startIndex:Int = 0, length:Int = 0)
		GetRandom is not currently supported in Monkey. Use FlxArray.GetSafeRandom method
	End Function
	#End
	
	Function LoadReplay:Void(data:String, state:FlxState = Null, cancelKeys:Int[] = [], timeout:Float = 0, callback:FlxReplayListener = Null)
		_game._replay.Load(data)
		If (state = Null) Then
			FlxG.ResetGame()
		Else
			FlxG.SwitchState(state)
		End If
		
		_game._replayCancelKeys = cancelKeys
		_game._replayTimer = timeout * 1000
		_game._replayCallback = callback
		_game._replayRequested = True
	End Function
	
	Function ReloadReplay:Void(standardMode:Bool = True)
		If (standardMode) Then
			FlxG.ResetGame()
		Else
			FlxG.ResetState()
		End If
		
		If (_game._replay.frameCount > 0) _game._replayRequested = True
	End Function	
	
	Function StopReplay:Void()
		_game._replaying = False
		
		If (_game._debugger <> Null) Then
			'TODO
		End If
		
		ResetInput()
	End Function
	
	Function RecordReplay:Void(standardMode:Bool = True)
		If (standardMode) Then
			FlxG.ResetGame()
		Else
			FlxG.ResetState()
		End If
		
		_game._recordingRequested = True
	End Function
	
	Function StopRecording:String()
		_game._recording = False
		
		If (_game._debugger <> Null) Then
			'TODO
		End if
		
		Return _game._replay.Save()
	End Function
	
	Function ResetState:Void()
		_game._requestedState = FlxState(_game._state.GetClass().CreateInstance())
	End Function
	
	Function ResetGame:Void()
		_game._requestedReset = True
	End Function
	
	Function ResetInput:Void()
		#If TARGET = "html5" Or TARGET = "ios" Or TARGET = "android"
			accel.Reset()
		#End				
		
		#If TARGET = "xna" Or TARGET = "glfw"
			If (Not FlxG.mobile) Then
				For Local i:Int = 0 Until _JOY_UNITS_COUNT
					_joystick[i].Reset()
				Next
			End If
		#End
		
		#If TARGET = "ios" Or TARGET = "android"
			For Local i:Int = 0 Until _TOUCH_COUNT
				_touch[i].Reset()
			Next
		#ElseIf TARGET = "xna" Or TARGET = "html5"
			If (Not FlxG.mobile) Then
				keys.Reset()
			End If
			
			_touch[0].Reset()
		#Else
			keys.Reset()
			_touch[0].Reset()			
		#End
		
		mouse.Reset()
	End Function
	
	Function CheckBitmapCache:Bool(key:String)
		Return _cache.CheckResource(key)
	End Function
	
	Function AddBitmap:Image(graphic:String, graphicLoader:FlxResourceLoader<Image>, unique:Bool = False, key:String = "")
		If (key.Length() = 0) Then
			key = graphic
			
			If (unique And CheckBitmapCache(key)) Then
				Local inc:Int = 0
				Local ukey:String
				
				Repeat
					ukey = key + inc
					inc += 1
				Until(CheckBitmapCache(ukey))
				
				key = ukey
			End If
		End If
		
		Return _cache.GetResource(key, graphicLoader)
	End Function
	
	Function ClearBitmapCache:Void()
		If (_cache = Null) _cache = New FlxResourcesManager<Image>()
		_cache.Clear()
	End Function
	
	Function State:FlxState()
		Return _game._state
	End Function
	
	Function SwitchState:Void(state:FlxState)
		FlxG._game._requestedState = state
	End Function
	
	Function AddCamera:FlxCamera(newCamera:FlxCamera)
		FlxG.cameras.Push(newCamera)
		Return newCamera
	End Function
	
	Function RemoveCamera:Void(camera:FlxCamera, destroy:Bool = True)
		FlxG.cameras.RemoveEach(camera)
		If (destroy) camera.Destroy()
	End Function
	
	Function ResetCameras:Void(newCamera:FlxCamera = Null)
		Local cam:FlxCamera
		Local i:Int = 0
		Local l:Int = FlxG.cameras.Length()
		
		While(i < l)
			cam = FlxG.cameras.Get(i)
			cam.Destroy()
			i+=1
		Wend
		
		FlxG.cameras.Clear()
		FlxG.camera = Null
		
		If (newCamera = Null) newCamera = New FlxCamera(0, 0, FlxG.width, FlxG.height)
		
		FlxG.camera = FlxG.AddCamera(newCamera)	
	End Function
	
	Function Flash:Void(color:Int = FlxG.WHITE, duration:Float = 1, onComplete:FlxCameraFlashListener = Null, force:Bool = False)
		Local i:Int = 0
		Local l:Int = FlxG.cameras.Length()
				
		While(i < l)
			FlxG.cameras.Get(i).Flash(color, duration, onComplete, force)
			i+=1
		Wend
	End Function
	
	Function Fade:Void(color:Int = FlxG.BLACK, duration:Float = 1, onComplete:FlxCameraFadeListener = Null, force:Bool = False)
		Local i:Int = 0
		Local l:Int = FlxG.cameras.Length()
				
		While(i < l)
			FlxG.cameras.Get(i).Fade(color, duration, onComplete, force)
			i+=1
		Wend
	End Function
	
	Function Shake:Void(intensity:Float = 0.05, duration:Float = 0.5, onComplete:FlxCameraShakeListener = Null, force:Bool = True, direction:Int = FlxCamera.SHAKE_BOTH_AXES)
		Local i:Int = 0
		Local l:Int = FlxG.cameras.Length()
				
		While(i < l)
			FlxG.cameras.Get(i).Shake(intensity, duration, onComplete, force, direction)
			i+=1
		Wend
	End Function		
	
	Function BgColor:Int()
		If (FlxG.camera = Null Or Not FlxG.camera.alive) Return FlxG._bgColor.argb	
		Return FlxG.camera.BgColor
	End Function
	
	Function BgColor:Void(color:Int)
		Local i:Int = 0
		Local l:Int = FlxG.cameras.Length()
		
		While(i < l)
			FlxG.cameras.Get(i).BgColor = color
			i+=1
		Wend
		
		FlxG._bgColor.SetARGB(color)
	End Function
	
	Function Overlap:Bool(objectOrGroup1:FlxBasic = Null, objectOrGroup2:FlxBasic, notifyCallback:FlxOverlapNotifyCallback = Null, processCallback:FlxOverlapProcessCallback = Null)
		If (objectOrGroup1 = Null) objectOrGroup1 = FlxG.State()
		If (objectOrGroup2 = objectOrGroup1) objectOrGroup2 = Null
		
		FlxQuadTree.divisions = FlxG.worldDivisions
		
		Local quadTree:FlxQuadTree = New FlxQuadTree(FlxG.worldBounds.x, FlxG.worldBounds.y, FlxG.worldBounds.width, FlxG.worldBounds.height)
		quadTree.Load(objectOrGroup1, objectOrGroup2, notifyCallback, processCallback)
		
		Local result:Bool = quadTree.Execute()
		quadTree.Destroy()
		
		Return result
	End Function
	
	Function AddPlugin:FlxBasic(plugin:FlxBasic)
		Local pluginList:Stack<FlxBasic> = FlxG.plugins
		Local i:Int = 0
		Local l:Int = pluginList.Length()
		
		While(i < l)
			If (pluginList.Get(i).ToString() = plugin.ToString()) Then
				Return plugin	
			End If
			
			i+=1
		Wend
		
		pluginList.Push(plugin)
		Return plugin
	End Function
	
	Function GetPlugin:FlxBasic(creator:FlxClass)
		Local pluginList:Stack<FlxBasic> = FlxG.plugins
		Local plugin:FlxBasic
		Local i:Int = 0
		Local l:Int = pluginList.Length()
		
		While(i < l)
			plugin = pluginList.Get(i)
			If (creator.InstanceOf(plugin)) Return plugin
			
			i+=1
		Wend
		
		Return Null	
	End Function
	
	Function RemovePlugin:FlxBasic(plugin:FlxBasic)
		plugins.RemoveEach(plugin)
		Return plugin
	End Function
	
	Function RemovePluginType:Bool(creator:FlxClass)
		Local results:Bool = False
		Local pluginList:Stack<FlxBasic> = FlxG.plugins
		Local i:Int = pluginList.Length() - 1	
		
		While(i >= 0)
			If (creator.InstanceOf(pluginList.Get(i))) Then
				pluginList.Remove(i)
				results = True	
			End If
			
			i-=1
		Wend
	
		Return results
	End Function
	
	Function Init:Void(game:FlxGame, width:Int, height:Int, zoom:Float)
		FlxG._game = game
		FlxG.width = width
		FlxG.height = height
		
		FlxG.ClearBitmapCache()		
		
		FlxCamera.defaultZoom = zoom
		FlxG.cameras = New Stack<FlxCamera>()		
		
		plugins = New Stack<FlxBasic>
		AddPlugin(New DebugPathDisplay())
		AddPlugin(New TimerManager())
		
		FlxG.accel = New Accel()
		FlxG.keys = New Keyboard()
		FlxG.mouse = New Mouse()
		
		For Local i:Int = 0 Until _JOY_UNITS_COUNT
			_joystick[i] = New Joystick(i)
		Next
		
		For Local i:Int = 0 Until _TOUCH_COUNT
			_touch[i] = New Touch(i)
		Next
		
		FlxG.scores = New Stack<String>()		
	End Function
	
	Function Reset:Void()
		FlxG.ClearBitmapCache()
		FlxG.ResetInput()
		FlxG.scores.Clear()
		FlxG.score = 0	
		FlxG.timeScale = 1
		FlxG.elapsed = 0 
		FlxG.globalSeed = Rnd(1, 10000000)
		FlxG.worldBounds = New FlxRect(-10, -10, FlxG.width + 20, FlxG.height + 20)
		FlxG.worldDivisions = 6
		Local debugPathDisplay:DebugPathDisplay = DebugPathDisplay(FlxG.GetPlugin(DebugPathDisplay._CLASS))
		If (debugPathDisplay <> Null) debugPathDisplay.Clear()
	End Function
	
	Function UpdateInput:Void()
		#If TARGET = "html5" Or TARGET = "ios" Or TARGET = "android"
			accel.Update(AccelX(), AccelY(), AccelZ())
		#End		
		
		#If TARGET = "xna" Or TARGET = "glfw"
			If (Not FlxG.mobile) Then
				For Local i:Int = 0 Until _JOY_UNITS_COUNT
					_joystick[i].Update()
				Next
			End If
		#End
		
		#If TARGET = "ios" Or TARGET = "android"
			For Local i:Int = 0 Until _TOUCH_COUNT
				_touch[i].Update(TouchX(i), TouchY(i))
				
				If (i <> _TOUCH_COUNT - 1 And Not _touch[i + 1].Used() And Not TouchDown(i + 1)) Exit
			Next
		#ElseIf TARGET = "xna" Or TARGET = "html5"
			If (Not FlxG.mobile) Then
				FlxG.keys.Update()
			End If
			
			_touch[0].Update(TouchX(), TouchY())
		#Else
			FlxG.keys.Update()				
			_touch[0].Update(TouchX(), TouchY())
		#End
		
		If (Not _game._debuggerUp Or Not _game._debugger.hasMouse) Then
			FlxG.mouse.Update(MouseX(), MouseY())
		End If
	End Function
	
	Function UpdateCameras:Void()
		Local cam:FlxCamera
		Local cams:Stack<FlxCamera> = FlxG.cameras
		Local i:Int = 0
		Local l:Int = cams.Length()
		
		While(i < l)
			cam = cams.Get(i)
			If (cam <> Null And cam.exists And cam.active) cam.Update()			
			i+=1
		Wend
	End Function
	
	Function UpdatePlugins:Void()
		Local plugin:FlxBasic
		Local pluginList:Stack<FlxBasic> = FlxG.plugins
		Local i:Int = 0
		Local l:Int = pluginList.Length()
		
		While(i < l)
			plugin = pluginList.Get(i)
			If (plugin.exists And plugin.active) plugin.Update()			
			i+=1
		Wend
	End Function
	
	Function DrawPlugins:Void()
		Local plugin:FlxBasic
		Local pluginList:Stack<FlxBasic> = FlxG.plugins
		Local i:Int = 0
		Local l:Int = pluginList.Length()
		
		While(i < l)
			plugin = pluginList.Get(i)
			If (plugin.exists And plugin.visible) plugin.Draw()			
			i+=1
		Wend
	End Function
	
	Function Joystick:Joystick(unit:Int = 0)
		Return _joystick[unit]
	End Function
	
	Function Touch:Touch(index:Int = 0)
		Return _touch[index]
	End Function
	
	Function JoystickCount:Int()
		Return _JOY_UNITS_COUNT
	End Function
	
	Function TouchCount:Int()
		Return _TOUCH_COUNT
	End Function

End Class
