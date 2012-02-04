Strict

Import mojo

Import flxextern
Import flxobject
Import flxrect
Import flxg
Import flxcamera
Import flxgroup
Import flxbasic

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
		If (FlxGroup(objectOrGroup) <> Null) Then
			Local results:Bool = False
			Local basic:FlxBasic
			Local i:Int = 0
			Local members:FlxBasic[] = FlxGroup(objectOrGroup).Members
			Local l = members.Length()
			
			While (i < l)
				basic = members[i]
				
				If (FlxObject(basic) <> Null) Then
					If (OverlapsWithCallback(FlxObject(basic))) Then
						results = True
					End If
					
				Else
					If (Overlaps(x, y, basic, inScreenSpace, camera)) Then
						results = True
					End If
				End If
				
				i += 1
			Wend
			
			Return results
			
		ElseIf (FlxObject(objectOrGroup) <> Null) Then			
			Return OverlapsWithCallback(FlxObject(objectOrGroup))
		End If
		
		Return False	
	End Method
	
	Method OverlapsAt:Bool(x:Float, y:Float, objectOrGroup:FlxBasic, inScreenSpace:Bool = False, camera:FlxCamera = Null)
		If (FlxGroup(objectOrGroup) <> Null) Then
			Local results:Bool = False
			Local basic:FlxBasic
			Local i:Int = 0
			Local members:FlxBasic[] = FlxGroup(objectOrGroup).Members
			Local l = members.Length()
			
			While (i < l)
				basic = members[i]
				
				If (FlxObject(basic) <> Null) Then
					_point.x = x
					_point.y = y
					
					If (OverlapsWithCallback(FlxObject(basic), Null, False, _point)) Then
						results = True
					End If
					
				Else
					If (OverlapsAt(x, y, basic, inScreenSpace, camera)) Then
						results = True
					End If
				End If
				
				i += 1
			Wend
			
			Return results
			
		ElseIf (FlxObject(objectOrGroup) <> Null) Then
			_point.x = x
			_point.y = y
			
			Return OverlapsWithCallback(FlxObject(objectOrGroup), Null, False, _point)
		End If
	
		Return False	
	End Method
	
	Method OverlapsWithCallback:Bool(object:FlxObject, callback:FlxTilemapOverlapListener = Null, flipCallbackParams:Bool = False, position:FlxPoint = Null)
		Local results:Bool = False
		
		Local lx:Float = x
		Local ly:Float = y
		
		If (position <> Null) Then
			lx = position.x
			ly = position.y
		End If
		
		Local selectionX:Int = Floor((object.x - lx) / _tileWidth)
		Local selectionY:Int = Floor((object.y - ly) / _tileHeight)
		Local selectionWidth:Int = selectionX + Ceil(object.width / _tileWidth) + 1
		Local selectionHeight:Int = selectionY + Ceil(object.height / _tileHeight) + 1
		
		If (selectionX < 0) selectionX = 0
		If (selectionY < 0) selectionY = 0
		If (selectionWidth > widthInTiles) selectionWidth = widthInTiles
		If (selectionHeight > heightInTiles) selectionHeight = heightInTiles
		
		Local rowStart:Int = selectionY * widthInTiles
		Local row:Int = selectionY
		Local column:Int
		Local tile:FlxTile
		Local overlapFound:Bool
		Local deltaX:Float = lx - last.x
		Local deltaY:Float = ly - last.y
		
		While (row < selectionHeight)
			column = selectionX
			
			While (column < selectionWidth)
				overlapFound = False
				tile = _tileObjects[_data[rowStart + column]]
				
				If (tile.allowCollisions) Then
					tile.x = lx + column * _tileWidth
					tile.y = ly + y + row * _tileHeight
					tile.last.x = tile.x - deltaX
					tile.last.y = tile.y - deltaY
					
					If (callback <> Null) Then
						If (flipCallbackParams) Then
							overlapFound = callback.IsTilemapOverlap(object, tile)
						Else
							overlapFound = callback.IsTilemapOverlap(tile, object)
						End If
					Else
						overlapFound = (object.x + object.width > tile.x And object.x < tile.x + tile.width And object.y + object.height > tile.y And object.y < tile.y + tile.height)
					End If
					
					If (overlapFound) Then
						If (tile.callback <> Null And (tile.filter = Null Or tile.filter.InstanceOf(object)) Then
							tile.mapIndex = rowStart + column
							tile.callback.OnTileHit(tile, object)
						End If
						
						results = True
					End If
					
				ElseIf (tile.callback <> Null And (tile.filter = Null Or tile.filter.InstanceOf(object))
					tile.mapIndex = rowStart + column
					tile.callback.OnTileHit(tile, object)
				End If
				
				column += 1
			Wend
			
			rowStart += widthInTiles
			row += 1
		Wend
		
		Return results	
	End Method
	
	Method OverlapsPoint:Bool(point:FlxPoint, inScreenSpace:Bool = False, camera:FlxCamera = Null)
		If (Not inScreenSpace) Then
			Return _tileObjects[_data[Int(Int((point.y - y) / _tileHeight) * widthInTiles + (point.x - x) / _tileWidth)]].allowCollisions > 0
		End If
		
		If (camera = Null) camera = FlxG.camera
		
		point.x -= camera.scroll.x
		point.y -= camera.scroll.y
		
		GetScreenXY(_point, camera)
		
		Return _tileObjects[_data[Int(Int((point.y - _point.y) / _tileHeight) * widthInTiles + (point.x - _point.x) / _tileWidth)]].allowCollisions > 0
	End Method
	
	Method GetTile:Int(x:Int, y:Int)
		Return _data[y * widthInTiles + x]
	End Method
	
	Method GetTileByIndex:Int(index:Int)
		Return _data[index]
	End Method
	
	Method GetTileInstances:IntStack(index:Int)
		Local array:IntStack = Null
		
		Local i:Int = 0
		Local l:Int = widthInTiles * heightInTiles
		
		While (i < l)
			If (_data[i] = index) Then
				If (array = Null) array = New IntStack()
				array.Push(i)
			End If
			
			i += 1
		Wend
		
		Return array
	End Method
	
	Method GetTileCoords:Stack<FlxPoint>(index:Int, midpoint:Bool = True)
		Local array:Stack<FlxPoint> = Null
		
		Local point:FlxPoint
		Local i:Int = 0
		Local l:Int = widthInTiles * heightInTiles
		
		While (i < l)
			If (_data[i] = index) Then
				point = New FlxPoint(x + Int(i Mod widthInTiles) * _tileWidth, y + Int(i / widthInTiles) * _tileHeight)
				
				If (midpoint) Then
					point.x += _tileWidth * .5
					point.y += _tileHeight * .5
				End If
				
				If (array = Null) array = New Stack<FlxPoint>()				
				array.Push(point)
			End If
			
			i += 1
		Wend
		
		Return array
	End Method
	
	Method SetTile:Bool(x:Int, y:Int, tile:Int, updateGraphics:Bool = True)
		If (x >= widthInTiles Or y >= heightInTiles) Then
			Return False
		End If
		
		Return SetTileByIndex(y * widthInTiles + x, tile, updateGraphics)
	End Method
	
	Method SetTileByIndex:Bool(index:Int, tile:Int, updateGraphics:Bool = True)
		If (index >= _data.Length()) Return False
				
		_data[index] = tile
		
		If (Not updateGraphics) Return True
		
		If (auto = OFF) Then
			_UpdateTile(index)
			Return True
		End If
		
		Local i:Int = 0
		Local row:Int = Int(index / widthInTiles) - 1
		Local rowLength:Int = row + 3
		Local column:Int = index Mod widthInTiles - 1
		Local columnHeight:Int = column + 3
		
		While (row < rowLength)
			column = columnHeight - 3
			
			While (column < columnHeight)
				If (row >= 0 And row < heightInTiles And column >= 0 And column < widthInTiles) Then
					i = row * widthInTiles + column
					_AutoTile(i)
					_UpdateTile(i)
				End If
				
				column += 1
			Wend
			
			row += 1
		Wend
		
		Return True
	End Method
	
	Method SetTileProperties:Void(tile:Int, allowCollisions:Int = $1111, callback:FlxTileHitListener = Null, callbackFilter:FlxClass, range:Int = 1)
		If (range <= 0) range = 1
		
		Local tileObject:FlxTile
		Local i:Int = tile
		Local l:Int = tile + range
		
		While (i < l)
			tileObject = _tileObjects[i]
			
			tileObject.allowCollisions = allowCollisions
			tileObject.callback = callback
			tileObject.filter = callbackFilter
			
			i += 1
		Wend
	End Method
	
	Method Follow:Void(camera:FlxCamera = Null, border:Int = 0, updateWorld:Bool = True)
		If (camera = Null) camera = FlxCamera
		camera.SetBounds(x + border * _tileWidth, y + border * _tileHeight, width - border * _tileWidth * 2, height - border * _tileHeight * 2, updateWorld)
	End Method
	
	Method GetBounds:FlxRect(bounds:FlxRect = Null)
		If (bounds = Null) bounds = New FlxRect()		
		Return bounds.Make(x, y, width, height)
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
	Method _ComputePathDistance:Int[](startIndex:Int, endIndex:Int)
		Local mapSize:Int = widthInTiles * heightInTiles
		Local distances:Int[mapSize]
		Local i:Int = 0
		
		While (i < mapSize)
			If (_tileObjects[_data[i]].allowCollisions) Then
				distances[i] = -2
			Else
				distances[i] = -1
			End If
			
			i += 1
		Wend
		
		distances[startIndex] = 0
		
		Local distance:Int = 1
		Local neighbors:IntStack = New IntStack([startIndex])
		Local current:IntStack
		Local currentIndex:Int
		Local left:Bool
		Local right:Bool
		Local up:Bool
		Local down:Bool
		Local currentLength:Int
		Local foundEnd:Bool = False
		
		While (neighbors.Length() > 0)
			current = neighbors
			neighbors = New IntStack()
			
			i = 0
			currentLength = current.Length()
			
			While (i < currentLength)
				currentIndex = current.Get(i)
			
				If (currentIndex = endIndex) Then
					foundEnd = True
					neighbors.Clear()
					Exit
				End If
				
				left = currentIndex Mod widthInTiles > 0
				right = currentIndex Mod widthInTiles < widthInTiles - 1
				up = currentIndex / widthInTiles > 0
				down = currentIndex / widthInTiles < heightInTiles - 1
				
				Local index:Int
				
				If (up) Then
					index = currentIndex - widthInTiles
					
					If (distances[index] = -1) Then
						distances[index] = distance
						neighbors.Push(index)
					End If
				End If
				
				If (right) Then
					index = currentIndex + 1
					
					If (distances[index] = -1) Then
						distances[index] = distance
						neighbors.Push(index)
					End If
				End If
				
				If (down) Then
					index = currentIndex + widthInTiles
					
					If (distances[index] = -1) Then
						distances[index] = distance
						neighbors.Push(index)
					End If
				End If
				
				If (left) Then
					index = currentIndex - 1
					
					If (distances[index] = -1) Then
						distances[index] = distance
						neighbors.Push(index)
					End If
				End If
				
				If (up And right) Then
					index = currentIndex - widthInTiles + 1
					
					If (distances[index] = -1 And distances[currentIndex - widthInTiles] >= -1 And distances[currentIndex + 1] >= -1) Then
						distances[index] = distance
						neighbors.Push(index)
					End If
				End If
				
				If (right And down) Then
					index = currentIndex + widthInTiles + 1
					
					If (distances[index] = -1 And distances[currentIndex + widthInTiles] >= -1 And distances[currentIndex + 1] >= -1) Then
						distances[index] = distance
						neighbors.Push(index)
					End If
				End If
				
				If (left And down) Then
					index = currentIndex + widthInTiles - 1
					
					If (distances[index] = -1 And distances[currentIndex + widthInTiles] >= -1 And distances[currentIndex - 1] >= -1) Then
						distances[index] = distance
						neighbors.Push(index)
					End If
				End If
				
				If (up And left) Then
					index = currentIndex - widthInTiles - 1
					
					If (distances[index] = -1 And distances[currentIndex - widthInTiles] >= -1 And distances[currentIndex - 1] >= -1) Then
						distances[index] = distance
						neighbors.Push(index)
					End If
				End If
				
				i += 1				
			Wend
			
			distance += 1
		Wend
		
		If (Not foundEnd) distances = []
		
		Return distances
	End Method

	Method _WalkPath:Void(data:Int[], start:Int, points:Stack<FlxPoint>)
		points.Push(New FlxPoint(x + Int(start Mod widthInTiles) * _tileWidth + _tileWidth * .5, y + Int(start Mod widthInTiles) * _tileHeight + _tileHeight * .5))		
		If (data[start] = 0) Return
		
		Local left:Bool = start Mod widthInTiles > 0
		Local right:Bool = start Mod widthInTiles < widthInTiles - 1
		Local up:Bool = start / widthInTiles > 0
		Local down:Bool = start / widthInTiles < heightInTiles - 1
		
		Local current:Int = data[start]
		Local i:Int
		
		If (up) Then
			i = start - widthInTiles
			
			If (data[i] >= 0 And data[i] < current) Then
				_WalkPath(data, i, points)
				Return
			End If
		End If
		
		If (right) Then
			i = start + 1
			
			If (data[i] >= 0 And data[i] < current) Then
				_WalkPath(data, i, points)
				Return
			End If
		End If
		
		If (down) Then
			i = start + widthInTiles
			
			If (data[i] >= 0 And data[i] < current) Then
				_WalkPath(data, i, points)
				Return
			End If
		End If
		
		If (left) Then
			i = start - 1
			
			If (data[i] >= 0 And data[i] < current) Then
				_WalkPath(data, i, points)
				Return
			End If
		End If
		
		If (up And Right) Then
			i = start - widthInTiles + 1
			
			If (data[i] >= 0 And data[i] < current) Then
				_WalkPath(data, i, points)
				Return
			End If
		End If
		
		If (right And down) Then
			i = start + widthInTiles + 1
			
			If (data[i] >= 0 And data[i] < current) Then
				_WalkPath(data, i, points)
				Return
			End If
		End If
		
		If (left And down) Then
			i = start + widthInTiles - 1
			
			If (data[i] >= 0 And data[i] < current) Then
				_WalkPath(data, i, points)
				Return
			End If
		End If
		
		If (up And left) Then
			i = start - widthInTiles - 1
			
			If (data[i] >= 0 And data[i] < current) Then
				_WalkPath(data, i, points)
				Return
			End If
		End If
	End Method

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
	
	Method IsTilemapOverlap:Bool(object1:FlxObject, object2:FlxObject)

End Interface