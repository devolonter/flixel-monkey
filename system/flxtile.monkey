Strict

Import flixel.flxextern
Import flixel.flxobject
Import flixel.flxtilemap

Class FlxTile Extends FlxObject
	
	Field callback:FlxTileHitListener
	
	Field filter:FlxClass
	
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
		Super.Destroy()
		callback = Null
		tilemap = Null
		filter = Null
	End Method

End Class

Interface FlxTileHitListener

	Method OnTileHit:Void(tile:FlxTile, object:FlxObject)	

End Interface