Strict

Import flxsprite
Import flxtext.driver

Class FlxText Extends FlxSprite

	Global CREATOR:FlxClassCreator = new FlxTextCreator()
	
Private
	Field _driver:FlxTextDriver	

Public
	Method New(x:Float, y:Float, width:Float, text:String = Null, EmbeddedFont:Bool = true)
	
	
	End Method
	
End Class

Private	
Class FlxTextCreator Implements FlxClassCreator

	Method CreateInstance:FlxBasic()
		Return New FlxText()
	End Method
	
	Method InstanceOf:Bool(object:FlxBasic)			
		Return (FlxText(object) <> Null)
	End Method	
	
End Class