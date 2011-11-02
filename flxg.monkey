Strict

Import flxcamera
Import flxgame

Import plugin.timemanager

Class FlxG
	
	Global cameras:Stack<FlxCamera>
	
	Global plugins:Stack<FlxBasic>
	
	Global elapsed:Int
	
	Global visualDebug:Bool
	
	Function init:Void(game:FlxGame, width:Int, height:Int, zoom:Float)
		
		plugins = New Stack<FlxBasic>
		AddPlugin(New TimerManager())	
	End Function
	
	Function GetRandom:FlxBasic(objects:FlxBasic[], startIndex:Int = 0, length:Int = 0)
		Return Null
	End Function
	
	Function AddPlugin:FlxBasic(plugin:FlxBasic)
		Local pluginList:Stack<FlxBasic> = FlxG.plugins
		Local i:Int = 0
		Local l:Int = plugins.Length()
		
		While(i < l)
			If (pluginList.Get(i).ToString() = plugin.ToString()) Then
				Return plugin	
			End If
			
			i+=1
		Wend
		
		pluginList.Push(plugin)
		Return plugin
	End Function
	
	Function GetPlugin:FlxBasic(creator:FlxClassCreator)
		Local pluginList:Stack<FlxBasic> = FlxG.plugins
		Local plugin:FlxBasic
		Local i:Int = 0
		Local l:Int = plugins.Length()
		
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
	
	Function RemovePluginType:Bool(creator:FlxClassCreator)
		Local results:Bool = False
		Local pluginList:Stack<FlxBasic> = FlxG.plugins
		Local i:Int = plugins.Length() - 1	
		
		While(i >= 0)
			If (creator.InstanceOf(creator)) Then
				pluginList.Remove(i)
				results = True	
			End If
			
			i-=1
		Wend
	
		Return results
	End Function

End Class
