Strict

Import flxobject

Import "data/flx_default.png"

Class FlxSprite Extends FlxObject

	Global CLASS_OBJECT:FlxClass = new FlxSpriteClass()

	Method New(x:Float = 0, y:Float = 0)
		Super.New(x, y)
	End Method
	
End Class

Private	
Class FlxSpriteClass Implements FlxClass

	Method CreateInstance:FlxBasic()
		Return New FlxSprite()
	End Method
	
	Method InstanceOf:Bool(object:FlxBasic)			
		Return (FlxSprite(object) <> Null)
	End Method	
	
End Class