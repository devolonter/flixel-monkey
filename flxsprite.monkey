Strict

Import flxobject

Import "data/default.png"

Class FlxSprite Extends FlxObject

	Global CREATOR:FlxClassCreator = new FlxSpriteCreator()

	Method New(x:Float = 0, y:Float = 0)
		Super.New(x, y)
	End Method
	
End Class

Private	
Class FlxSpriteCreator Implements FlxClassCreator

	Method CreateInstance:FlxBasic()
		Return New FlxSprite()
	End Method
	
	Method InstanceOf:Bool(object:FlxBasic)			
		Return (FlxSprite(object) <> Null)
	End Method	
	
End Class