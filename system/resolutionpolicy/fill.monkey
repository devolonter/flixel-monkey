Strict

Import flixel.flxpoint
Import resolutionpolicy

Class FillResolutionPolicy Implements FlxResolutionPolicy
	
	Method OnMeasure:Void(width:Int, height:Int, result:FlxPoint)
		result.x = width
		result.y = height
	End Method

End Class