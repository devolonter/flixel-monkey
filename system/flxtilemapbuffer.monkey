Strict

Import flixel.flxcamera
Import flixel.flxg
Import flixel.flxu

Class FlxTilemapBuffer
	
	Field x:Float
	
	Field y:Float
	
	Field width:Float
	
	Field height:Float
	
	Field rows:Int
	
	Field columns:Int
	
	Field dirty:Bool
	
	Field scaleFixX:Float
	
	Field scaleFixY:Float
	
	Method New(tileWidth:Float, tileHeight:Float, widthInTiles:Int, heightInTiles:Int, camera:FlxCamera = Null)
		If (camera = Null) camera = FlxG.Camera
		
		columns = Ceil(camera.Width / tileWidth) + 1
		If (columns > widthInTiles) columns = widthInTiles
		
		rows = Ceil(camera.Height / tileHeight) + 1
		If (rows > heightInTiles) rows = heightInTiles
		
		width = columns * tileWidth		
		height = rows * tileHeight
		
		dirty = True
		
		Local scaledTileWidth:Float = tileWidth * camera.Zoom * FlxG._DeviceScaleFactorX
		Local scaledTileHeight:Float = tileHeight * camera.Zoom * FlxG._DeviceScaleFactorY
		Local roundScaledTileWidth:Float = FlxU.Round(scaledTileWidth)
		Local roundScaledTileHeight:Float = FlxU.Round(scaledTileHeight)		
		
		If (Abs(roundScaledTileWidth - scaledTileWidth) > 0) Then
			roundScaledTileWidth += 1
			
			If (roundScaledTileWidth - scaledTileWidth > 0) Then
				scaleFixX = roundScaledTileWidth / scaledTileWidth
			Else
				scaleFixX = scaledTileWidth / roundScaledTileWidth
			End If
		Else
			scaleFixX = 1
		End If
		
		If (Abs(roundScaledTileHeight - scaledTileHeight) > 0) Then
			roundScaledTileHeight += 1
			
			If (roundScaledTileHeight - scaledTileHeight > 0) Then
				scaleFixY = roundScaledTileHeight / scaledTileHeight
			Else
				scaleFixY = scaledTileHeight / roundScaledTileHeight
			End If
		Else
			scaleFixY = 1
		End If
	End Method

End Class