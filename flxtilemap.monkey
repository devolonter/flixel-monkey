Strict

Import flxobject

Class FlxTilemap Extends FlxObject

	Method Overlaps:Bool(objectOrGroup:FlxBasic, inScreenSpace:Bool = False, camera:FlxCamera = Null)
		'TODO
		Return False	
	End Method
	
	Method OverlapsAt:Bool(x:Float, y:Float, objectOrGroup:FlxBasic, inScreenSpace:Bool = False, camera:FlxCamera = Null)
		'TODO
		Return False	
	End Method
	
	Method OverlapsWithCallback:Bool(object:FlxObject, callback:FlxObjectSeparateInvoker = Null, flipCallbackParams:Bool = False, position:FlxPoint = Null)
		'TODO
		Return False	
	End Method
	
	Method ToString:String()
		Return "FlxTileMap"
	End Method

End Class