Strict

Import mojo

Import flxextern
Import flxgame
Import flxcamera
Import flxu

Import plugin.monkey.flxresourcesmanager

Import plugin.timermanager
Import plugin.debugpathdisplay

Class FlxG	

	Const LIBRARY_NAME:String = "Monkey flixel"
	
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
			
	Global cameras:Stack<FlxCamera>
	
	Global camera:FlxCamera
	
	Global plugins:Stack<FlxBasic>
	
	Global elapsed:Float
	
	Global timeScale:Float
	
	Global visualDebug:Bool
	
	Global globalSeed:Int
	
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
		If (newCamera = Null) newCamera = New FlxCamera(0, 0, FlxG.width, FlxG.height)
		
		FlxG.camera = FlxG.AddCamera(newCamera)	
	End Function
	
	Function Flash:Void(color:Int = FlxG.WHITE, duration:Float = 1, onComplete:FlxFunction = Null, force:Bool = False)
		Local i:Int = 0
		Local l:Int = FlxG.cameras.Length()
				
		While(i < l)
			FlxG.cameras.Get(i).Flash(color, duration, onComplete, force)
			i+=1
		Wend
	End Function
	
	Function Fade:Void(color:Int = FlxG.BLACK, duration:Float = 1, onComplete:FlxFunction = Null, force:Bool = False)
		Local i:Int = 0
		Local l:Int = FlxG.cameras.Length()
				
		While(i < l)
			FlxG.cameras.Get(i).Fade(color, duration, onComplete, force)
			i+=1
		Wend
	End Function
	
	Function Shake:Void(intensity:Float = 0.05, duration:Float = 0.5, onComplete:FlxFunction = Null, force:Bool = True, direction:Int = FlxCamera.SHAKE_BOTH_AXES)
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
	End Function
	
	Function Reset:Void()		
		FlxG.timeScale = 1
		FlxG.elapsed = 0 
		FlxG.globalSeed = Rnd(1, 10000000)
		FlxG.worldBounds = New FlxRect(-10, -10, FlxG.width + 20, FlxG.height + 20)
		Local debugPathDisplay:DebugPathDisplay = DebugPathDisplay(FlxG.GetPlugin(DebugPathDisplay._CLASS))
		If (debugPathDisplay <> Null) debugPathDisplay.Clear()
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

End Class
