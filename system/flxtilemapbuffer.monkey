Strict

Import flixel.flxcamera

Class FlxTilemapBuffer
	
	Field x:Float
	
	Field y:Float
	
	Field width:Float
	
	Field height:Float
	
	Field rows:Int
	
	Field columns:Int
	
	Method New(tileWidth:Float, tileHeight:Float, widthInTiles:Int, heightInTiles:Int, camera:FlxCamera = Null)
		If (camera = Null) camera = FlxG.camera
		
		columns = Ceil(camera.Width / tileWidth) + 1
		If (columns > widthInTiles) columns = widthInTiles
		
		rows = Ceil(camera.Height / tileHeight) + 1
		If (rows > heightInTiles) rows = heightInTiles
		
		width = columns * tileWidth		
		height = rows * tileHeight
	End Method

End Class