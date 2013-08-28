Strict

Import mojo
Import reflection

Import flxextern
Import flxbasic
Import flxgame
Import flxcamera
Import flxobject
Import flxsignals
Import flxsound
Import flxmusic
Import flxu

Import system.input.accel
Import system.input.joystick
Import system.input.keyboard
Import system.input.mouse
Import system.input.touch
Import system.tweens.flxtween
Import system.tweens.util.ease
Import system.tweens.misc.multivartween
Import system.resolutionpolicy.flxresolutionpolicy
Import system.resolutionpolicy.fill
Import system.flxresourcesmanager
Import system.flxquadtree
Import system.flxreplay
Import system.flximagedata

Import plugin.timermanager
Import plugin.debugpathdisplay

Alias AccelInput = accel.Accel
Alias MouseInput = mouse.Mouse
Alias TouchInput = touch.Touch
Alias JoystickInput = joystick.Joystick
Alias MojoDeviceWidth = mojo.graphics.DeviceWidth
Alias MojoDeviceHeight = mojo.graphics.DeviceHeight

Class FlxG

	Const LIBRARY_NAME:String = "Flixel for Monkey"
	
	Const LIBRARY_MAJOR_VERSION:Int = 1
	
	Const LIBRARY_MINOR_VERSION:Int = 0
	
	Const DATA_SUFFIX:String = "_flx"
	
	Const RED:Int = $FFFF0012
	
	Const GREEN:Int = $FF00F225
	
	Const BLUE:Int = $FF0090E9
	
	Const PINK:Int = $FFF01EFF
	
	Const WHITE:Int = $FFFFFFFF
	
	Const BLACK:Int = $FF000000
	
	Global Paused:Bool
	
#If FLX_DEBUG_ENABLED = "1"
	Global Debug:Bool = True
#Else
	Global Debug:Bool = False
#End
	
	Global Elapsed:Float
	
	Global TimeScale:Float

	Global DeviceWidth:Int
	
	Global DeviceHeight:Int
	
	Global Width:Int
	
	Global Height:Int
	
	Global WorldBounds:FlxRect
	
	Global WorldDivisions:Int
	
	Global VisualDebug:Bool
	
	Global Mobile:Bool
	
	Global GlobalSeed:Int
	
	Global Scores:Stack<Int>	
	
	Global Score:Int
	
	Global Levels:Stack<Int>	
	
	Global Level:Int	
	
	Global Accel:AccelInput	
	
	Global Keys:Keyboard
	
	Global Mouse:MouseInput
	
	Global Music:FlxMusic
	
	Global Sounds:FlxGroup
	
	Global Mute:Bool
	
	Global Cameras:Stack<FlxCamera>
	
	Global Camera:FlxCamera
	
	Global Plugins:Stack<FlxBasic>
	
	Global VolumeHandler:FlxVolumeChangeListener	
	
	Global Updaterate:Int
	
	Global Tweener:FlxBasic
	
	Global Signals:FlxSignals
	
	Global _DeviceScaleFactorX:Float = 1	
	
	Global _DeviceScaleFactorY:Float = 1
	
	Global _DeviceOffsetX:Int
	
	Global _DeviceOffsetY:Int
	
	Global _BgColor:FlxColor = FlxColor.ARGB(FlxG.BLACK)		
	
	Global _Game:FlxGame
	
	Global _Volume:Float
	
	Global _BitmapCache:FlxResourcesManager<Image>
	
	Global _SoundCache:FlxResourcesManager<Sound>
	
	Global _LastDrawingColor:Int
	
	Global _LastDrawingAlpha:Float
	
	Global _LastDrawingBlend:Int
	
	Global _CurrentCamera:FlxCamera

Private
#If TARGET = "psm"
	Const _JOY_UNITS_COUNT:Int = 1
#Else
	Const _JOY_UNITS_COUNT:Int = 4
#End	
	Const _TOUCH_COUNT:Int = 32
	
	Global _Joystick:JoystickInput[_JOY_UNITS_COUNT]
	
	Global _Touch:TouchInput[_TOUCH_COUNT]
	
	Global _CollideListener:FlxCollideProcessListener = New FlxCollideProcessListener()
	
	Global _ResolutionPolicy:FlxResolutionPolicy = New FillResolutionPolicy()
	
	Global _Point:FlxPoint = New FlxPoint()	

Public
	Function GetLibraryName:String()
		Return FlxG.LIBRARY_NAME + " v" + FlxG.LIBRARY_MAJOR_VERSION + "." + FlxG.LIBRARY_MINOR_VERSION
	End Function
	
	Function Log:Void(data:String)
	#If FLX_DEBUG_ENABLED = "1"
		'note: TODO: to add log objects
		Print data
	#End
	End Function

	Function Random:Float()
		FlxG.GlobalSeed = (FlxG.GlobalSeed * 1664525 + 1013904223) | 0
		Return FlxU.Srand(FlxG.GlobalSeed)
	End Function
	
	Function Random:Float(range:Float)
		Return FlxG.Random() * range
	End Function
	
	Function Random:Float(low:Float, high:Float)
		Return FlxG.Random(high - low) + low
	End Function
	
	Function Random:Int(range:Int)
		Return Int(FlxG.Random() * (1 + range))
	End Function
	
	Function Random:Int(low:Int, high:Int)
		Return FlxG.Random(high - low) + low
	End Function
	
	#Rem
	Function GetRandom:Object(objects:Object[], startIndex:Int = 0, length:Int = 0)
		GetRandom is not currently supported in Monkey. Use FlxArray.GetSafeRandom method
	End Function
	#End
	
	Function LoadReplay:Void(data:String, state:FlxState = Null, cancelKeys:Int[] = [], timeout:Float = 0, callback:FlxReplayListener = Null)
		_Game._replay.Load(data)
		If (state = Null) Then
			FlxG.ResetGame()
		Else
			FlxG.SwitchState(state)
		End If
		
		_Game._replayCancelKeys = cancelKeys
		_Game._replayTimer = timeout * 1000
		_Game._replayCallback = callback
		_Game._replayRequested = True
	End Function
	
	Function ReloadReplay:Void(standardMode:Bool = True)
		If (standardMode) Then
			FlxG.ResetGame()
		Else
			FlxG.ResetState()
		End If
		
		If (_Game._replay.frameCount > 0) _Game._replayRequested = True
	End Function	
	
	Function StopReplay:Void()
		_Game._replaying = False
		
	#If FLX_DEBUG_ENABLED = "1"
		If (_Game._debugger <> Null) Then
			'note: TODO:
		End If
	#End
		
		ResetInput()
	End Function
	
	Function RecordReplay:Void(standardMode:Bool = True)
		If (standardMode) Then
			FlxG.ResetGame()
		Else
			FlxG.ResetState()
		End If
		
		_Game._recordingRequested = True
	End Function
	
	Function StopRecording:String()
		_Game._recording = False
	
	#If FLX_DEBUG_ENABLED = "1"	
		If (_Game._debugger <> Null) Then
			'note: TODO:
		End If
	#End
		
		Return _Game._replay.Save()
	End Function
	
	Function ResetState:Void()
		_Game._requestedState = FlxState(_Game._state.GetClassInfo().NewInstance())
	End Function
	
	Function ResetGame:Void()
		_Game._requestedReset = True
	End Function
	
	Function ResetInput:Void()
		For Local i:Int = 0 Until _JOY_UNITS_COUNT
			_Joystick[i].Reset()
		Next
		
		For Local i:Int = 0 Until _TOUCH_COUNT
			_Touch[i].Reset()
		Next
		
		Accel.Reset()		
		Mouse.Reset()
		Keys.Reset()
	End Function
	
	Function PlayMusic:Void(music:String, volume:Float = 1.0)
		If (FlxG.Music = Null) Then
			FlxG.Music = New FlxMusic()
			
		ElseIf (FlxG.Music.active) Then
			FlxG.Music.Stop()
		End If
		
		FlxG.Music.Load(music, True)
		FlxG.Music.Volume = volume
		FlxG.Music.survive = True
		
		FlxG.Music.Play()
	End Function
	
	Function LoadSound:FlxSound(sound:String, volume:Float = 1.0, looped:Bool = False, autoDestroy:Bool = False, autoPlay:Bool = False, stopPrevious:Bool = True)
		Local s:FlxSound = FlxSound(Sounds.Recycle(FlxSound.__CLASS__))
		
		s.Load(sound, looped, autoDestroy, stopPrevious)
		s.Volume = volume		
		If (autoPlay) s.Play()
				
		Return s
	End Function
	
	Function Play:FlxSound(sound:String, volume:Float = 1.0, looped:Bool = False, autoDestroy:Bool = True)
		Local s:FlxSound = FlxG.LoadSound(sound, volume, looped, autoDestroy, True, False)
		If (Not looped) s.exists = False
		Return s
	End Function
	
	Function Volume:Float()
		Return _Volume
	End Function
	
	Function Volume:Void(volume:Float)
		_Volume = volume
		
		If (_Volume < 0) Then
			_Volume = 0
		ElseIf (_Volume > 1) Then
			_Volume = 1
		End If
		
		If (VolumeHandler <> Null) Then
			If (FlxG.Mute) Then
				VolumeHandler.OnVolumeChange(0)
			Else
				VolumeHandler.OnVolumeChange(_Volume)
			End If
		End If
		
		If (Music <> Null And Music.active) Then
			Music._UpdateTransform()
		End If
		
		For Local basic:FlxBasic = EachIn Sounds
			FlxSound(basic)._UpdateTransform()
		Next
	End Function
	
	Function DestroySounds:Void(forceDestroy:Bool = False)
		If (Music <> Null And (forceDestroy Or Not Music.survive)) Then
			Music.Destroy()
			Music = Null
		End If
		
		Local sound:FlxSound
		
		For Local basic:FlxBasic = EachIn Sounds
			sound = FlxSound(basic)
			
			If (sound <> Null And (forceDestroy Or Not sound.survive)) Then
				sound.Destroy()
			End If
		Next
	End Function
	
	Function UpdateSounds:Void()
		If (Music <> Null And Music.active) Then
			Music.Update()
		End If
		
		If (Sounds <> Null And Sounds.active) Then
			Sounds.Update()
		End If
	End Function
	
	Function PauseSounds:Void()
		If (Music <> Null And Music.exists And Music.active) Then
			Music.Pause()
		End If
		
		Local sound:FlxSound
		
		For Local basic:FlxBasic = EachIn Sounds
			sound = FlxSound(basic)
			
			If (sound <> Null And sound.exists And sound.active) Then
				sound.Pause()
			End If
		Next
	End Function
	
	Function ResumeSounds:Void()
		If (Music <> Null And Music.exists) Then
			Music.Play()
		End If
		
		Local sound:FlxSound
		
		For Local basic:FlxBasic = EachIn Sounds
			sound = FlxSound(basic)
			
			If (sound <> Null And sound.exists) Then
				sound.Resume()
			End If
		Next
	End Function
	
	Function CheckBitmapCache:Bool(key:String)
		Return _BitmapCache.CheckResource(key)
	End Function
	
	Function CreateBitmap:Image(width:Int, height:Int, color:Int, unigue:Bool, key:String = "")
		If (key.Length() = 0) Then
			key = width + "x" + height + ":" + color
			
			If (unigue And CheckBitmapCache(key)) Then
				Local inc:Int = 0
				Local ukey:String
				
				Repeat
					ukey = key + inc
					inc += 1
				Until (CheckBitmapCache(ukey))
				
				key = ukey
			End If
		End If
		
		Return _BitmapCache.GetResource(key, New CreateImageResource(key, width, height, color))
	End Function
	
	Function AddBitmap:Image(resource:FlxResource<Image>, unique:Bool = False, key:String = "")
		If (key.Length() = 0) Then
			key = resource.name
			
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
		
		Return _BitmapCache.GetResource(key, resource)
	End Function
	
	Function RemoveBitmap:Void(graphic:String)
		If (_BitmapCache <> Null) Then
			_BitmapCache.RemoveResource(graphic)
		End If
	End Function
	
	Function ClearBitmapCache:Void()
		If (_BitmapCache = Null) _BitmapCache = New FlxResourcesManager<Image>()
		_BitmapCache.Clear()
	End Function
	
	Function AddSound:Sound(resource:FlxResource<Sound>)
		Return _SoundCache.GetResource(resource.name, resource)
	End Function
	
	Function ClearSoundCache:Void()
		If (_SoundCache = Null) _SoundCache = New FlxResourcesManager<Sound>()
		_SoundCache.Clear()
	End Function
	
	Function State:FlxState()
		Return _Game._state
	End Function
	
	Function SwitchState:Void(state:FlxState)
		FlxG._Game._requestedState = state
	End Function
	
	Function SetSwitchStateListener:Void(listener:FlxSwitchStateListener)
		FlxG._Game.SetSwitchStateListener(listener)
	End Function
	
	Function AddCamera:FlxCamera(newCamera:FlxCamera)
		FlxG.Cameras.Push(newCamera)
		Return newCamera
	End Function
	
	Function RemoveCamera:Void(camera:FlxCamera, destroy:Bool = True)
		FlxG.Cameras.RemoveEach(camera)
		If (destroy) camera.Destroy()
	End Function
	
	Function ResetCameras:Void(newCamera:FlxCamera = Null)	
		Local cam:FlxCamera
		Local i:Int = 0
		Local l:Int = FlxG.Cameras.Length()
		
		While(i < l)
			cam = FlxG.Cameras.Get(i)
			cam.Destroy()
			i+=1
		Wend
		
		FlxG.Cameras.Clear()
		FlxG.Camera = Null
		
		If (newCamera = Null) newCamera = New FlxCamera(0, 0, FlxG.Width, FlxG.Height)
		
		FlxG.Camera = FlxG.AddCamera(newCamera)	
	End Function
	
	Function Flash:Void(color:Int = FlxG.WHITE, duration:Float = 1, onComplete:FlxCameraFlashListener = Null, force:Bool = False)
		Local i:Int = 0
		Local l:Int = FlxG.Cameras.Length()
				
		While(i < l)
			FlxG.Cameras.Get(i).Flash(color, duration, onComplete, force)
			i+=1
		Wend
	End Function
	
	Function Fade:Void(color:Int = FlxG.BLACK, duration:Float = 1, onComplete:FlxCameraFadeListener = Null, force:Bool = False)
		Local i:Int = 0
		Local l:Int = FlxG.Cameras.Length()
				
		While(i < l)
			FlxG.Cameras.Get(i).Fade(color, duration, onComplete, force)
			i+=1
		Wend
	End Function
	
	Function Shake:Void(intensity:Float = 0.05, duration:Float = 0.5, onComplete:FlxCameraShakeListener = Null, force:Bool = True, direction:Int = FlxCamera.SHAKE_BOTH_AXES)
		Local i:Int = 0
		Local l:Int = FlxG.Cameras.Length()
				
		While(i < l)
			FlxG.Cameras.Get(i).Shake(intensity, duration, onComplete, force, direction)
			i+=1
		Wend
	End Function
	
	Function BgColor:Int()
		If (FlxG.Camera = Null Or Not FlxG.Camera.alive) Return FlxG._BgColor.argb	
		Return FlxG.Camera.BgColor
	End Function
	
	Function SetBgColor:Void(color:Int)
		Local i:Int = 0
		Local l:Int = FlxG.Cameras.Length()
		
		While(i < l)
			FlxG.Cameras.Get(i).BgColor = color
			i+=1
		Wend
		
		FlxG._BgColor.SetARGB(color)
	End Function
	
	Function Overlap:Bool(objectOrGroup1:FlxBasic = Null, objectOrGroup2:FlxBasic, notifyCallback:FlxOverlapNotifyListener = Null, processCallback:FlxOverlapProcessListener = Null)
		If (objectOrGroup1 = Null) objectOrGroup1 = FlxG.State()
		If (objectOrGroup2 = objectOrGroup1) objectOrGroup2 = Null
		
		FlxQuadTree.Divisions = FlxG.WorldDivisions
		
		Local quadTree:FlxQuadTree = FlxQuadTree.Recycle(FlxG.WorldBounds.x, FlxG.WorldBounds.y, FlxG.WorldBounds.width, FlxG.WorldBounds.height)
		quadTree.Load(objectOrGroup1, objectOrGroup2, notifyCallback, processCallback)
		
		Local result:Bool = quadTree.Execute()
		quadTree.Destroy()
		
		Return result
	End Function
	
	Function Collide:Bool(objectOrGroup1:FlxBasic = Null, objectOrGroup2:FlxBasic = Null, notifyCallback:FlxOverlapNotifyListener = Null)
		Return	Overlap(objectOrGroup1, objectOrGroup2, notifyCallback, _CollideListener)
	End Function
	
	Function AddPlugin:FlxBasic(plugin:FlxBasic)
		Local pluginList:Stack<FlxBasic> = FlxG.Plugins
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
	
	Function GetPlugin:FlxBasic(objectClass:ClassInfo)
		Local pluginList:Stack<FlxBasic> = FlxG.Plugins
		Local plugin:FlxBasic
		Local i:Int = 0
		Local l:Int = pluginList.Length()
		
		While(i < l)
			plugin = pluginList.Get(i)
			If (plugin.GetClassInfo().ExtendsClass(objectClass)) Return plugin
			
			i+=1
		Wend
		
		Return Null	
	End Function
	
	Function GetPlugin:FlxBasic(objectOrClass:Object)
		If (ClassInfo(objectOrClass) <> Null) Then
			Return GetPlugin(ClassInfo(objectOrClass))
		Else
			Return GetPlugin(GetClass(objectOrClass))
		End If
	End Function

	Function RemovePlugin:FlxBasic(plugin:FlxBasic)
		Plugins.RemoveEach(plugin)
		Return plugin
	End Function
	
	Function RemovePluginType:Bool(objectClass:ClassInfo)
		Local results:Bool = False
		Local pluginList:Stack<FlxBasic> = FlxG.Plugins
		Local i:Int = pluginList.Length() - 1	
		
		While(i >= 0)
			If (pluginList.Get(i).GetClassInfo().ExtendsClass(objectClass)) Then
				pluginList.Remove(i)
				results = True	
			End If
			
			i-=1
		Wend
	
		Return results
	End Function
	
	Function Init:Void(game:FlxGame, width:Int, height:Int, zoom:Float)
		FlxG._Game = game
		FlxG.Width = width
		FlxG.Height = height
		
		FlxG.Tweener = New FlxBasic()
		FlxG.Signals = New FlxSignals()
		
		FlxG.Mute = False
		FlxG._Volume = .5
		FlxG.Sounds = New FlxGroup()
		FlxG.VolumeHandler = Null
		
		FlxG.ClearBitmapCache()		
		
		FlxCamera.DefaultZoom = zoom
		FlxG.Cameras = New Stack<FlxCamera>()		
		
		Plugins = New Stack<FlxBasic>
		
	#If FLX_DEBUG_ENABLED = "1"
		AddPlugin(New DebugPathDisplay())
	#End
		AddPlugin(New TimerManager())
		
		FlxG.Accel = New AccelInput()
		FlxG.Keys = New Keyboard()
		FlxG.Mouse = New MouseInput()
		
		For Local i:Int = 0 Until _JOY_UNITS_COUNT
			_Joystick[i] = New JoystickInput(i)
		Next
		
		For Local i:Int = 0 Until _TOUCH_COUNT
			_Touch[i] = New TouchInput(i)
		Next
		
		FlxG.Mobile = FlxIsMobile()
		
		FlxG.Scores = New Stack<Int>()
		FlxG.Levels = New Stack<Int>()
		FlxG.VisualDebug = False	
	End Function
	
	Function Reset:Void()
		FlxG.ClearBitmapCache()
		FlxG.DestroySounds(True)
		FlxG.ClearSoundCache()
		FlxG.ResetInput()
		FlxG.Signals.Destroy()
		FlxG.Levels.Clear()
		FlxG.Scores.Clear()
		FlxG.Level = 0		
		FlxG.Score = 0	
		FlxG.TimeScale = 1
		FlxG.Elapsed = 0 
		FlxG.GlobalSeed = Seed
		FlxG.WorldBounds = New FlxRect(-10, -10, FlxG.Width + 20, FlxG.Height + 20)
		FlxG.WorldDivisions = 6
		
	#If FLX_DEBUG_ENABLED = "1"
		Local debugPathDisplay:DebugPathDisplay = DebugPathDisplay(FlxG.GetPlugin(DebugPathDisplay.__CLASS__))
		If (debugPathDisplay <> Null) debugPathDisplay.Clear()
	#End
	End Function
	
	Function UpdateInput:Void()
	#If FLX_MOUSE_ENABLED = "1"
		#If FLX_DEBUG_ENABLED = "1"	
			If (Not _Game._debuggerUp Or Not _Game._debugger.hasMouse) Then
				Mouse.Update(MouseX(), MouseY())
			End If
		#Else
			Mouse.Update(MouseX(), MouseY())
		#End
		
		_Touch[0].Update(TouchX(), TouchY())
	#End
	
	#If FLX_KEYBOARD_ENABLED = "1"
		Keys.Update()
	#End			
	
	#If FLX_JOYSTICK_ENABLED = "1"
		For Local i:Int = 0 Until _JOY_UNITS_COUNT
			_Joystick[i].Update()
		Next
	#End
	
	#If FLX_MULTITOUCH_ENABLED = "1"
		For Local i:Int = 1 Until _TOUCH_COUNT
			_Touch[i].Update(TouchX(i), TouchY(i))
			
			If ( Not _Touch[i].Used) Exit
		Next
	#End
	
	#If FLX_ACCEL_ENABLED = "1"
		Accel.Update(AccelX(), AccelY(), AccelZ())
	#End
	End Function
	
	Function UpdateCameras:Void()
		Local cam:FlxCamera
		Local cams:Stack<FlxCamera> = FlxG.Cameras
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
		Local pluginList:Stack<FlxBasic> = FlxG.Plugins
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
		Local pluginList:Stack<FlxBasic> = FlxG.Plugins
		Local i:Int = 0
		Local l:Int = pluginList.Length()
		
		While(i < l)
			plugin = pluginList.Get(i)
			If (plugin.exists And plugin.visible) plugin.Draw()			
			i+=1
		Wend
	End Function
	
	Function Joystick:JoystickInput(unit:Int = 0)
		Return _Joystick[unit]
	End Function
	
	Function Touch:TouchInput(index:Int = 0)
		Return _Touch[index]
	End Function
	
	Function JoystickCount:Int()
		Return _JOY_UNITS_COUNT
	End Function
	
	Function TouchCount:Int()
		Return _TOUCH_COUNT
	End Function
	
	Function SetResolutionPolicy:Void(resolutionPolicy:FlxResolutionPolicy)
		_ResolutionPolicy = resolutionPolicy
		_Measure()
	End Function
	
	Function UpdateDevice:Void()
		If(FlxG.DeviceWidth <> MojoDeviceWidth() Or FlxG.DeviceHeight <> MojoDeviceHeight()) Then
			_Measure()
		End If
	End Function
	
	Function Tween:MultiVarTween(object:Object, values:StringMap<Float>, duration:Float, type:Int = FlxTween.ONESHOT, complete:FlxTweenListener = Null, ease:FlxEaseFunction = Null, tweener:FlxBasic = Null)
		If (tweener = Null) Then
			If (FlxBasic(object) <> Null) Then
				tweener = FlxBasic(object)
			Else
				tweener = FlxG.Tweener
			End If
		End If
		
		Local tween:MultiVarTween = New MultiVarTween(complete, type)
		tween.Tween(object, values, duration, ease)
		tweener.AddTween(tween)
		
		Return tween
	End Function
	
Private
	Function _Measure:Void()
		FlxG.DeviceWidth = MojoDeviceWidth()
		FlxG.DeviceHeight = MojoDeviceHeight()

		_ResolutionPolicy.OnMeasure(FlxG.DeviceWidth, FlxG.DeviceHeight, _Point)
		
		FlxG._DeviceScaleFactorX = _Point.x / Float(FlxG.Width)
		FlxG._DeviceScaleFactorY = _Point.y / Float(FlxG.Height)
		
		Local zoom:Float = FlxCamera.DefaultZoom
		If(FlxG.Camera <> Null) zoom = FlxG.Camera.Zoom
	
		FlxG._DeviceOffsetX = Ceil( (FlxG.DeviceWidth - _Point.x * zoom) * 0.5)
		FlxG._DeviceOffsetY = Ceil( (FlxG.DeviceHeight - _Point.y * zoom) * 0.5)
	
		Local i:Int = 0
		Local l:Int = FlxG.Cameras.Length()
		Local cam:FlxCamera
	
		While(i < l)
			cam = FlxG.Cameras.Get(i)
			
			'recalc values
			cam.X = cam.X
			cam.Y = cam.Y
			cam.Width = cam.Width
			cam.Height = cam.Height
			
			i += 1
		Wend
	End Function

End Class

Interface FlxVolumeChangeListener

	Method OnVolumeChange:Void(volume:Float)

 End Interface

Private

Class FlxCollideProcessListener Implements FlxOverlapProcessListener
	
	Method OnOverlapProcess:Bool(object1:FlxObject, object2:FlxObject)
		Return FlxObject.Separate(object1, object2)
	End Method

End Class

Class CreateImageResource Extends FlxResource<Image>
	
	Field width:Float
	
	Field height:Float
	
	Field color:Int

	Field image:Image
	
	Method New(name:String, width:Float, height:Float, color:Int)
		Super.New(name)
		Self.width = width
		Self.height = height
		Self.color = color
	End Method

	Method Load:Image()
		image = (New FlxImageData(width, height, False, color)).Image
		Return image
	End Method
	
	Method Use:Image()
		Return image
	End Method
	
	Method Discard:Void()
		image.Discard()
		image = Null
	End Method

End Class