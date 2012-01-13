Strict

Import flxobject

Import "data/flx_default.png"

Class FlxSprite Extends FlxObject

	Global CLASS_OBJECT:FlxClass = new FlxSpriteClass()
	
	Field offset:FlxPoint
	
	Field scale:FlxPoint
	
	Field blend:Int
	
	Field finished:Bool
	
	Field frameWidth:Int
	
	Field frameHeight:Int
	
	Field frames:Int
	
	Field dirty:Bool
	
Private
	Field _origin:FlxPoint
	
	

Public
	Method New(x:Float = 0, y:Float = 0)
		Super.New(x, y)
	End Method
	
	Method ToString:String()
		Return "FlxSprite"	
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