'For temporary use in FlxBasic

Import flxcamera

Class FlxG
	
	Global cameras:Stack<FlxCamera>
	
	Global elapsed:Float
	
	Global visualDebug:Bool
	
	Function GetRandom:FlxBasic(objects:FlxBasic[], startIndex:Int = 0, length:Int = 0)
		Return Null
	End Function
	
	Function GetPlugin:FlxBasic(creator:FlxBasicCreator)
		Return Null
	End Function

End Class
