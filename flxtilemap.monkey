Strict

Import mojo

Import flxextern
Import flxobject
Import flxrect
Import flxg
Import flxcamera
Import flxgroup
Import flxbasic
Import flxpath

Import system.flxtile
Import system.flxtilemapbuffer

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
	Global _TileLoader:FlxTileLoader = New FlxTileLoader()

	Field _tiles:Image
	
	Field _buffers:Stack<FlxTilemapBuffer>

	Field _data:Int[]
	
	Field _rects:FlxRect[]
	
	Field _tileWidth:Int
	
	Field _tileHeight:Int
	
	Field _tileObjects:FlxTile[]
	
	Field _startingIndex:Int = 0
	
	Field _camera:FlxCamera
	
	Field _buffer:FlxTilemapBuffer
	
	Field _screenXInTiles:Int
	
	Field _screenYInTiles:Int
	
	Field _screenRows:Int
	
	Field _screenColumns:Int
	
Public
	Method New()
		Super.New()
		auto = OFF
		widthInTiles = 0
		heightInTiles = 0
		totalTiles = 0
		_buffers = New Stack<FlxTilemapBuffer>()
		_tileWidth = 0
		_tileHeight = 0
		_tiles = Null		
		immovable = True
		_startingIndex = 0
		_camera = Null
		_buffer = Null
	End Method
	
	Method Destroy:Void()
		_tiles = Null
		_camera = Null
		_buffer = Null
		
		Local i:Int = 0
		Local l:Int = _tileObjects.Length()
		
		While (i < l)
			If (_tileObjects[i] <> Null) Then
				_tileObjects[i].Destroy()
				_tileObjects[i] = Null
			End If
			
			i += 1
		Wend
		
		_buffers = Null
		
		Super.Destroy()
	End Method
	
	Method LoadMap:FlxTilemap(mapData:String, tileGraphic:String, tileWidth:Int = 0, tileHeight:Int = 0, autoTile:Int = OFF, startIndex:Int = 0, drawIndex:Int = 1, collideIndex:Int = 1)
		auto = autoTile
		_startingIndex = startIndex
		
		Local columns:String[]
		Local rows:String[] = mapData.Split("~n")
		Local row:Int = 0
		Local column:Int 
		Local data:Stack<Int> = New Stack<Int>()
		
		heightInTiles = rows.Length()
		
		While (row < heightInTiles)
			columns = rows[row].Split(",")
			
			If (columns.Length() <= 1) Then
				heightInTiles = heightInTiles - 1
				Continue
			End If
			
			If (widthInTiles = 0) Then
				widthInTiles = columns.Length()
			End If
			
			column = 0
			
			While (column < widthInTiles)
				data.Push(Int(columns[column]))
				column += 1
			Wend
			
			row += 1
		Wend
		
		_data = data.ToArray()
		
		Local i:Int
		
		totalTiles = widthInTiles * heightInTiles
		
		If (auto > OFF) Then
			_startingIndex = 1
			drawIndex = 1
			collideIndex = 1
			i = 0
			
			While (i < totalTiles)
				_AutoTile(i)
				i += 1
			Wend
		End If
		
		_tiles = FlxG.AddBitmap(tileGraphic, _TileLoader)
		
		_tileWidth = tileWidth		
		If (_tileWidth = 0) _tileWidth = _tiles.Height()
		
		_tileHeight = tileHeight
		If (_tileHeight = 0) _tileHeight = _tileWidth
		
		i = 0
		Local l:Int = (_tiles.Width() / _tileWidth) * (_tiles.Height() / _tileHeight)		
		
		If (auto > OFF) l += 1		
		_tileObjects = _tileObjects.Resize(l)
		
		While (i < l)
			If (i >= collideIndex) Then
				_tileObjects[i] = New FlxTile(Self, i, _tileWidth, _tileHeight, (i >= drawIndex), allowCollisions)
			Else
				_tileObjects[i] = New FlxTile(Self, i, _tileWidth, _tileHeight, (i >= drawIndex), NONE)
			End If
			
			i += 1
		Wend
		
		width = widthInTiles * _tileWidth
		height = heightInTiles * _tileHeight
		_rects = _rects.Resize(totalTiles)
		i = 0
		
		While (i < totalTiles)
			_UpdateTile(i)
			i += 1
		Wend
		
		Return Self
	End Method
	
	Method Draw:Void()
		If (_flickerTimer <> 0) Then
			_flicker = Not _flicker
			If (_flicker) Return
		End If
		
		_camera = FlxG._CurrentCamera
		
		If (FlxG._CurrentCameraID >= _buffers.Length()) _buffers.Push(Null)
		_buffer = _buffers.Get(FlxG._CurrentCameraID)
		
		If (_buffer = Null) Then
			_buffer = New FlxTilemapBuffer(_tileWidth, _tileHeight, widthInTiles, heightInTiles, _camera)
			_buffers.Set(FlxG._CurrentCameraID, _buffer)
		End If
		
		_screenRows = _buffer.rows
		_screenColumns = _buffer.columns
		
		If (Not _buffer.dirty) Then
			_point.x = x - Int(_camera.scroll.x * scrollFactor.x) + _buffer.x
			_point.y = y - Int(_camera.scroll.y * scrollFactor.y) + _buffer.y
			
			_buffer.dirty = _point.x > 0 Or _point.y > 0 Or _point.x + _buffer.width < _camera.Width Or _point.y + _buffer.height < _camera.Height
		End If
		
		If (_buffer.dirty) Then		
			_point.x = Int(_camera.scroll.x * scrollFactor.x) - x
			_point.y = Int(_camera.scroll.y * scrollFactor.y) - y
			
			If (_point.x > 0) Then
				_screenXInTiles = (_point.x + 0.0000001) / _tileWidth
			Else
				_screenXInTiles = (_point.x - 0.0000001) / _tileWidth			
			End If
			
			If (_point.y > 0) Then
				_screenYInTiles = (_point.y + 0.0000001) / _tileHeight
			Else
				_screenYInTiles = (_point.y - 0.0000001) / _tileHeight			
			End If					
			
			If (_screenXInTiles < 0) _screenXInTiles = 0
			If (_screenXInTiles > widthInTiles - _screenColumns) _screenXInTiles = widthInTiles - _screenColumns
			If (_screenYInTiles < 0) _screenYInTiles = 0
			If (_screenYInTiles > heightInTiles - _screenRows) _screenYInTiles = heightInTiles - _screenRows
			
			_buffer.x = _screenXInTiles * _tileWidth
			_buffer.y = _screenYInTiles * _tileHeight
		End If		

		_point.x = x - Int(_camera.scroll.x * scrollFactor.x) + _buffer.x
		_point.y = y - Int(_camera.scroll.y * scrollFactor.y) + _buffer.y
		
		If (FlxG._LastDrawingBlend <> AlphaBlend) Then
			SetBlend(AlphaBlend)
			FlxG._LastDrawingBlend = AlphaBlend
		End If
		
		If (FlxG._LastDrawingColor <> _camera.Color) Then
			SetColor(_camera._color.r, _camera._color.g, _camera._color.b)
			FlxG._LastDrawingColor = _camera.Color
		End If
		
		Local alpha:Float = _camera._color.a * _camera.Alpha
		
		If (FlxG._LastDrawingAlpha <> alpha) Then
			SetAlpha(alpha)
			FlxG._LastDrawingAlpha = alpha
		End If
		
		PushMatrix()		
			Translate( _point.x, _point.y)	
			
			Local rowIndex:Int = _screenYInTiles * widthInTiles + _screenXInTiles			
			Local row:Int = 0
			Local column:Int
			Local columnIndex:Int
			Local tile:FlxTile
			
			_point.y = 0
			
			If (_buffer.scaleFixX = 1 Or _buffer.scaleFixY = 1) Then
				While (row < _screenRows)
					columnIndex = rowIndex
					column = 0
					_point.x = 0
					
					While (column < _screenColumns)
						_rect = _rects[columnIndex]
						
						If (_rect <> Null) Then
							DrawImageRect(_tiles, _point.x, _point.y, _rect.x, _rect.y, _rect.width, _rect.height)
							
							If (FlxG.VisualDebug And Not ignoreDrawDebug) Then
								'TODO
							End If
						End If
						
						_point.x += _tileWidth
						column += 1
						columnIndex += 1
					Wend
					
					rowIndex += widthInTiles
					_point.y += _tileHeight
					row += 1
				Wend
			Else
				row = _screenRows - 1
				_point.y = row * _tileHeight
				rowIndex += widthInTiles * row
			
				While (row >= 0)
					column = _screenColumns - 1					
					_point.x = column * _tileWidth
					columnIndex = rowIndex + column
					
					While (column >= 0)
						_rect = _rects[columnIndex]
						
						If (_rect <> Null) Then						
							DrawImageRect(_tiles, _point.x, _point.y, _rect.x, _rect.y, _rect.width, _rect.height, 0, _buffer.scaleFixX, _buffer.scaleFixY)
							
							If (FlxG.VisualDebug And Not ignoreDrawDebug) Then
								'TODO
							End If
						End If
						
						_point.x -= _tileWidth
						column -= 1
						columnIndex -= 1
					Wend
					
					rowIndex -= widthInTiles
					_point.y -= _tileHeight
					row -= 1
				Wend
			End If
		PopMatrix()		
		
		_VisibleCount += 1
	End Method
	
	Method GetData:Int[](simple:Bool = False)
		If (Not simple) Return _data
		
		Local i:Int = 0
		Local l:Int = _data.Length()
		Local data:Int[l]
		
		While (i < l)
			If (_tileObjects[_data[i]].allowCollisions > 0) Then
				data[i] = 1
			Else
				data[i] = 0
			End If
			
			i += 1			
		Wend
		
		Return data
	End Method
	
	Method SetDirty:Void(dirty:Bool = True)
		Local i:Int = 0
		Local l:Int = _buffers.Length()
		
		While (i < l)
			_buffers.Get(i).dirty = dirty
			i += 1
		Wend
	End Method
	
	Method FindPath:FlxPath(start:FlxPoint, endPoint:FlxPoint, simplify:Bool = True, raySimplify:Bool = False)
		Local startIndex:Int = Int((start.y - y) / _tileHeight) * widthInTiles + Int((start.x - x) / _tileWidth)
		Local endIndex:Int = Int((endPoint.y - y) / _tileHeight) * widthInTiles + Int((endPoint.x - x) / _tileWidth)
		
		If (_tileObjects[_data[startIndex]].allowCollisions > 0 Or _tileObjects[_data[endIndex]].allowCollisions > 0) Then
			Return Null
		End If
		
		Local distances:Int[] = _ComputePathDistance(startIndex, endIndex)		
		If (distances.Length() = 0) Return Null
		
		Local points:Stack<FlxPoint> = New Stack<FlxPoint>()
		_WalkPath(distances, endIndex, points)
		
		Local node:FlxPoint
		
		node = points.Top()
		node.x = start.x
		node.y = start.y
		
		node = points.Get(0)
		node.x = endPoint.x
		node.y = endPoint.y
		
		If (simplify) _SimplifyPath(points)
		If (raySimplify) _RaySimplifyPath(points)
		
		Local path:FlxPath = New FlxPath()
		Local i:Int = points.Length() - 1
		
		While (i >= 0)
			node = points.Get(i)
			
			If (node <> Null) Then
				path.AddPoint(node, true)
			End If
			
			i -= 1
		Wend
		
		Return path
	End Method

	Method Overlaps:Bool(objectOrGroup:FlxBasic, inScreenSpace:Bool = False, camera:FlxCamera = Null)
		If (FlxGroup(objectOrGroup) <> Null) Then
			Local results:Bool = False
			Local basic:FlxBasic
			Local i:Int = 0
			Local members:FlxBasic[] = FlxGroup(objectOrGroup).Members
			Local l:Int = members.Length()
			
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
			Local l:Int = members.Length()
			
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
	
	Method OverlapsWithCallback:Bool(object:FlxObject, callback:FlxTileOverlapChecker = Null, flipCallbackParams:Bool = False, position:FlxPoint = Null)
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
					tile.y = ly + row * _tileHeight
					tile.last.x = tile.x - deltaX
					tile.last.y = tile.y - deltaY
					
					If (callback <> Null) Then
						If (flipCallbackParams) Then
							overlapFound = callback.IsTileOverlap(object, tile)
						Else
							overlapFound = callback.IsTileOverlap(tile, object)
						End If
					Else
						overlapFound = (object.x + object.width > tile.x And object.x < tile.x + tile.width And object.y + object.height > tile.y And object.y < tile.y + tile.height)
					End If
					
					If (overlapFound) Then
						If (tile.callback <> Null And (tile.filter = Null Or tile.filter.InstanceOf(object))) Then
							tile.mapIndex = rowStart + column
							tile.callback.OnTileHit(tile, object)
						End If
						
						results = True
					End If
					
				ElseIf (tile.callback <> Null And (tile.filter = Null Or tile.filter.InstanceOf(object))) Then
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
		
		If (camera = Null) camera = FlxG.Camera
		
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
	
	Method GetTileInstances:Stack<Int>(index:Int)
		Local elements:Stack<Int> = Null
		
		Local i:Int = 0
		Local l:Int = widthInTiles * heightInTiles
		
		While (i < l)
			If (_data[i] = index) Then
				If (elements = Null) elements = New Stack<Int>()
				elements.Push(i)
			End If
			
			i += 1
		Wend
		
		Return elements
	End Method
	
	Method GetTileCoords:Stack<FlxPoint>(index:Int, midpoint:Bool = True)
		Local elements:Stack<FlxPoint> = Null
		
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
				
				If (elements = Null) elements = New Stack<FlxPoint>()				
				elements.Push(point)
			End If
			
			i += 1
		Wend
		
		Return elements
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
	
	Function ArrayToCSV:String(data:Int[], width:Int, invert:Bool = False)
		Local row:Int = 0
		Local column:Int
		Local csv:StringStack = New StringStack()
		Local height:Int = data.Length() / width
		Local index:Int
		
		While (row < height)
			column = 0
			
			While (column < width)
				index = data[row * width + column]
				
				If (invert) Then
					If (index = 0) Then
						index = 1
					Else
						index = 0
					End If
				End If
				
				If (column = 0) Then
					If (row = 0) Then
						csv.Push(index)
					Else
						csv.Push("~n" + index)					
					End If
				Else
					csv.Push(", " + index)
				End If
				
				column += 1
			Wend
			
			row += 1
		Wend
		
		Return csv.Join("")
	End Function
	
	Method ToString:String()
		Return "FlxTilemap"
	End Method
	
Private
	Method _SimplifyPath:Void(points:Stack<FlxPoint>)
		Local deltaPrevious:Float
		Local deltaNext:Float
		Local last:FlxPoint = points.Get(0)
		Local node:FlxPoint
		Local nextPoint:FlxPoint
		Local i:Int = 1
		Local l:Int = points.Length() - 1
		
		While (i < l)
			node = points.Get(i)
			nextPoint = points.Get(i + 1)
			
			deltaPrevious = (node.x - last.x) / (node.y - last.y)
			deltaNext = (node.x - nextPoint.x) / (node.y - nextPoint.y)
			
			If (last.x = nextPoint.x Or last.y = nextPoint.y Or deltaPrevious = deltaNext) Then
				points.Set(i, Null)
			Else
				last = node
			End If
			
			i += 1
		Wend
	End Method
	
	Method _RaySimplifyPath:Void(points:Stack<FlxPoint>)
		Local source:FlxPoint = points.Get(0)
		Local lastIndex:Int = -1
		Local node:FlxPoint
		Local i:Int = 1
		Local l:Int = points.Length()
		
		While (i < l)
			node = points.Get(i)
			i += 1
			
			If (node = Null) Continue
			
			If (Ray(source, node, _point)) Then
				If (lastIndex >= 0) points.Set(lastIndex, Null)
			Else
				source = points.Get(lastIndex)		
			End If
			
			lastIndex = i - 1
		Wend
	End Method

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
		Local neighbors:Stack<Int> = New Stack<Int>([startIndex])
		Local current:Stack<Int>
		Local currentIndex:Int
		Local left:Bool
		Local right:Bool
		Local up:Bool
		Local down:Bool
		Local currentLength:Int
		Local foundEnd:Bool = False
		
		While (neighbors.Length() > 0)
			current = neighbors
			neighbors = New Stack<Int>()
			
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
		points.Push(New FlxPoint(x + Int(start Mod widthInTiles) * _tileWidth + _tileWidth * .5, y + Int(start / widthInTiles) * _tileHeight + _tileHeight * .5))		
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
		
		If (up And right) Then
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
		Local tile:FlxTile = _tileObjects[_data[index]]
		
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

Private
Class FlxTileLoader Extends FlxResourceLoader<Image>

	Method Load:Image(name:String)
		Return LoadImage(FlxAssetsManager.GetImagePath(name))	
	End Method

End Class