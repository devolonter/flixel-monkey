Strict

Import flixel.flxg
Import flixel.flxpoint
Import resolutionpolicy

Class RelativeResolutionPolicy Implements FlxResolutionPolicy

Private
	Field _widthScale:Float
	
	Field _heightScale:Float

Public
	Method New(scale:Float)
		_Init(scale, scale)
	End Method

	Method New(widthScale:Float, heightScale:Float)
		_Init(widthScale, heightScale)
	End Method
	
	Method OnMeasure:Void(width:Int, height:Int, result:FlxPoint)
		result.x = Int(width * _widthScale)
		result.y = Int(height * _heightScale)
	End Method
	
Private
	Method _Init:Void(widthScale:Float, heightScale:Float)
		_widthScale = widthScale
		_heightScale = heightScale
	End Method

End Class