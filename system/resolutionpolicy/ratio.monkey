Strict

Import flixel.flxg
Import flixel.flxpoint
Import resolutionpolicy

Class RatioResolutionPolicy Implements FlxResolutionPolicy
	
	Method OnMeasure:Void(width:Int, height:Int, result:FlxPoint)
		Local ratio:Float = Float(FlxG.Width) / FlxG.Height
		Local realRatio:Float = Float(width) / height
		
		If(realRatio < ratio) Then
			result.x = width
			result.y = result.x / ratio
		Else
			result.y = height
			result.x = result.y * ratio
		End If
	End Method

End Class