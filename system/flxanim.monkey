Strict

Class FlxAnim

	Field name:String
	
	Field delay:Float
	
	Field frames:Int[]
	
	Field looped:Bool
	
	Method New(name:String, frames:Int[], frameRate:Float = 0, looped:Bool = True)
		Self.name = name
		Self.frames = frames
		Self.looped = looped
		SetFrameRate(frameRate)
	End Method
	
	Method SetFrameRate:Void(frameRate:Float)
		delay = 0
		If (frameRate > 0) delay = 1.0 / frameRate
	End Method

End Class

Interface FlxAnimationListener
	
	Method OnAnimationFrame:Void(animName:String, frame:Int, index:Int)

End Interface