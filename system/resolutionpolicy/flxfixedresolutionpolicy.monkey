Strict

Import flixel.flxg
Import flixel.flxpoint
Import flxresolutionpolicy

Class FlxFixedResolutionPolicy Implements FlxResolutionPolicy
	
	Method OnMeasure:Void(width:Int, height:Int, result:FlxPoint)
		result.x = FlxG.Width
		result.y = FlxG.Height
	End Method

End Class