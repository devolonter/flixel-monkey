Strict

Import flixel.flxpoint
Import flxresolutionpolicy

Class FlxFillResolutionPolicy Implements FlxResolutionPolicy
	
	Method OnMeasure:Void(width:Int, height:Int, result:FlxPoint)
		result.x = width
		result.y = height
	End Method

End Class