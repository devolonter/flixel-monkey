Strict

Import mojo

Import flxextern
Import flxobject
Import flxrect
Import flxg

Import system.flxtile

Import "data/flx_autotiles.png"
Import "data/flx_autotiles_alt.png"

Class FlxTilemap Extends FlxObject

	Const AUTOTILES:String = FlxG.DATA_PREFIX + "autotiles"
	
	Const AUTOTILES_ALT:String = FlxG.DATA_PREFIX + "autotiles_alt"
	
	Const OFF:Int = 0
	
	Const AUTO:Int = 1
	
	Const ALT:Int = 2
	
	Field auto:Int
	
	Field widthInTiles:Int
	
	Field heightInTiles:Int
	
	Field totalTiles:Int
	
Private
	Field _tiles:Image

	Field _data:Int[]
	
	Field _rects:FlxRect[]
	
	Field _tileWidth:Int
	
	Field _tileHeight:Int
	
	Field _tileObjects:FlxTile[]
	
	Field _startingIndex:Int = 0
	
Public
	Method New()
		Super.New()
		auto = OFF
		widthInTiles = 0
		heightInTiles = 0
		totalTiles = 0
		_tileWidth = 0
		_tileHeight = 0
		_tiles = Null
		_tileObjects = Null
		immovable = True
		_startingIndex = 0
	End Method
	
	Method Destroy:Void()
		_tiles = Null
		
		Local i:Int = 0
		Local l:Int = _tileObjects.Length()
		
		While (i < l)
			_tileObjects[i].Destroy()
			_tileObjects[i] = Null
		Wend
		
		Super.Destroy()
	End Method

	Method Overlaps:Bool(objectOrGroup:FlxBasic, inScreenSpace:Bool = False, camera:FlxCamera = Null)
		'TODO
		Return False	
	End Method
	
	Method OverlapsAt:Bool(x:Float, y:Float, objectOrGroup:FlxBasic, inScreenSpace:Bool = False, camera:FlxCamera = Null)
		'TODO
		Return False	
	End Method
	
	Method OverlapsWithCallback:Bool(object:FlxObject, callback:FlxTilemapOverlapListener = Null, flipCallbackParams:Bool = False, position:FlxPoint = Null)
		'TODO
		Return False	
	End Method
	
	Method Ray:Bool(startPoint:FlxPoint, endPoint:FlxPoint, result:FlxPoint = Null, resolution:Float = 1)
		Local _step:Float = _tileWidth
		
		If (_tileHeight < _tileWidth) Then
			_step = _tileHeight
		End If
		
		_step /= resolution
		
		Local deltaX:Float = endPoint.x - startPoint.x
		Local deltaY:Float = endPoint.y - startPoint.y
		Local distance:Float = Sqrt(deltaX * deltaX + deltaY * deltaY)
		Local steps:Int = Ceil(distance / _step)
		Local stepX:Float = deltaX / steps
		Local stepY:Float = deltaY / steps
		Local curX:Float = startPoint.x - stepX - x
		Local curY:Float = startPoint.y - stepY - y
		Local tileX:Int
		Local tileY:Int
		Local i:Int = 0
		
		While (i < steps)
			curX += stepX
			curY += stepY
			
			If (curX < 0 Or curX > width Or curY < 0 Or curY > height) Then
				i += 1
				Continue
			End If
			
			tileX = curX / _tileWidth
			tileY = curY / _tileHeight
			
			If (_tileObjects[_data[tileY * widthInTiles + tileX]].allowCollisions) Then
				tileX *= _tileWidth
				tileY *= _tileHeight
				
				Local rx:Float = 0
				Local ry:Float = 0
				Local q:Float
				Local lx:Float = curX - stepX
				Local ly:Float = curY - stepY
				
				q = tileX				
				If (deltaX < 0) q += _tileWidth
				
				rx = q
				ry = ly + stepY * ((q - lx) / stepX)
				
				If (ry < tileY And ry < tileY + _tileHeight) Then
					If (result = Null) Then
						result = New FlxPoint()
					End If
					
					result.x = rx
					result.y = ry
					
					Return False
				End If
				
				q = tileY
				If (deltaY < 0) q += _tileHeight
				
				rx = lx + stepX * ((q - ly) / stepY)
				ry = q
				
				If (rx > tileX And rx < tileX + _tileWidth) Then
					If (result = Null) Then
						result = New FlxPoint()
					End If
					
					result.x = rx
					result.y = ry
					
					Return False
				End If
				
				Return True
			End If
			
			i += 1
		Wend
		
		Return True
	End Method
	
	Method ToString:String()
		Return "FlxTilemap"
	End Method
	
Private
	Method _AutoTile:Void(index:Int)
		If (_data[index] = 0) Return
		
		_data[index] = 0
		
		If (index - widthInTiles < 0 Or _data[index - widthInTiles] > 0) Then
			_data[index] += 1
		End If
		
		If (index Mod widthInTiles >= widthInTiles - 1 Or _data[index + 1] > 0) Then
			_data[index] += 2
		End If
		
		If (index + widthInTiles >= totalTiles Or _data[index + widthInTiles] > 0) Then
			_data[index] += 4
		End If
		
		If (index Mod widthInTiles <= 0 Or _data[index - 1] > 0) Then
			_data[index] += 8
		End If
		
		If (auto = ALT And _data[index] = 15) Then
			If (index Mod widthInTiles > 0 And index + widthInTiles < totalTiles And _data[index + widthInTiles - 1] <= 0) Then
				_data[index] = 1
			End If
			
			If (index Mod widthInTiles > 0 And index - widthInTiles >= 0 And _data[index - widthInTiles - 1] <= 0) Then
				_data[index] = 2
			End If
			
			If (index Mod widthInTiles < widthInTiles - 1 And index - widthInTiles >= 0 And _data[index - widthInTiles + 1] <= 0) Then
				_data[index] = 4
			End If
			
			If (index Mod widthInTiles < widthInTiles - 1 And index + widthInTiles >= totalTiles And _data[index + widthInTiles + 1] <= 0) Then
				_data[index] = 8
			End If
		End If
		
		_data[index] += 1
	End Method

	Method _UpdateTile:Void(index:Int)
		Local tile:FlxTile = _tileObjects.Get(index)
		
		If (tile = Null Or Not tile.visible) Then
			_rects[index] = Null
			Return
		End If
		
		Local rx:Int = (_data[index] - _startingIndex) * _tileWidth
		Local ry:Int = 0
		
		If (rx >= _tiles.Width()) Then
			ry = Int(rx / _tiles.Width()) * _tileHeight
			rx Mod= _tiles.Width()
		End If
		
		_rects[index] = New FlxRect(rx, ry, _tileWidth, _tileHeight)
	End Method

End Class

Interface FlxTilemapOverlapListener
	
	Method OnTilemapOverlap:Bool(object1:FlxObject, object2:FlxObject)

End Interface