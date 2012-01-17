Strict

Class FlxAnim

	Field name:String
	
	Field delay:Float
	
	Field frames:Int[]
	
	Field looped:Bool
	
	Method New(name:String, frames:Int[], frameRate:Float = 0, looped:Bool = True)
		Self.name = name
		delay = 0
		If (frameRate > 0) delay = 1.0 / frameRate
		Self.frames = frames
		Self.looped = looped	
	End Method

End Class