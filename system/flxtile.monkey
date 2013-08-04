Strict

Import reflection

Import flixel.flxextern
Import flixel.flxobject
Import flixel.flxtilemap

Class FlxTile Extends FlxObject

	Global __CLASS__:Object
	
	Field callback:FlxTileHitListener
	
	Field filter:ClassInfo
	
	Field tilemap:FlxTilemap
	
	Field index:Int
	
	Field mapIndex:Int
	
	Method New(tilemap:FlxTilemap, index:Int, width:Float, height:Float, visible:Bool, allowCollisions:Int)
		Super.New(0, 0, width, height)
		immovable = True
		moves = False
		callback = Null
		filter = Null
		
		Self.tilemap = tilemap
		Self.index = index
		Self.visible = visible
		Self.allowCollisions = allowCollisions
		
		mapIndex = 0
	End Method
	
	Method Destroy:Void()		
		callback = Null
		tilemap = Null
		filter = Null
		
		Super.Destroy()
	End Method

End Class

Interface FlxTileHitListener

	Method OnTileHit:Void(tile:FlxTile, object:FlxObject)	

End Interface

Interface FlxTileOverlapChecker
	
	Method IsTileOverlap:Bool(object1:FlxObject, object2:FlxObject)

End Interface