Strict

Import reflection

Import flxextern
Import flxpoint
Import flxg
Import flixel.system.flxcolor
Import flixel.plugin.debugpathdisplay


Class FlxPath

	Field nodes:Stack<FlxPoint>
	
	Field debugColor:Int
	
	Field debugScrollFactor:FlxPoint
	
	Field ignoreDrawDebug:Bool
	
Private
	Field _point:FlxPoint
	
	Field _debugNodeColor:FlxColor
	
Public
	Method New(nodes:Stack<FlxPoint> = Null)
		If (nodes = Null) Then
			Self.nodes = New Stack<FlxPoint>()
		Else
			Self.nodes = nodes	
		End if
		
		_point = New FlxPoint()
		debugScrollFactor = New FlxPoint(1.0, 1.0)
		debugColor = FlxG.WHITE
		ignoreDrawDebug = False
		
	#If FLX_DEBUG_ENABLED = "1"
		Local debugPathDisplay:DebugPathDisplay = Manager()
		If (debugPathDisplay <> Null) debugPathDisplay.Add(Self)
	#End			
	End Method

	Method Destroy:Void()
	#If FLX_DEBUG_ENABLED = "1"
		Local debugPathDisplay:DebugPathDisplay = Manager()
		If (debugPathDisplay <> Null) debugPathDisplay.Remove(Self)
	#End
		
		debugScrollFactor = Null
		_point = Null
		nodes = Null
		_debugNodeColor = Null
	End Method
	
	Method Add:Void(x:Float, y:Float)
		nodes.Push(New FlxPoint(x, y))
	End Method
	
	Method AddAt:Void(x:Float, y:Float, index:Int)
		If (index > nodes.Length()) index = nodes.Length()
		nodes.Insert(index, New FlxPoint(x, y))	
	End Method
	
	Method AddPoint:Void(node:FlxPoint, asReference:Bool = False)
		If (asReference) Then
			nodes.Push(node)
		Else
			nodes.Push(New FlxPoint(node.x, node.y))
		End If
	End Method
	
	Method AddPointAt:Void(node:FlxPoint, index:Int, asReference:Bool = False)
		If (index > nodes.Length()) index = nodes.Length()
		
		If (asReference) Then
			nodes.Insert(index, node)
		Else
			nodes.Insert(index, New FlxPoint(node.x, node.y))	
		End If
	End Method
	
	Method Remove:FlxPoint(node:FlxPoint)		
		Local i:Int = 0
		Local l:Int = nodes.Length()
		Local point:FlxPoint
		
		While (i < l)
			point = nodes.Get(i)
			If (point = node) Exit
			i += 1	
		Wend
		
		nodes.Remove(i)
		Return point
	End Method
	
	Method RemoveAt:FlxPoint(index:Int)
		If (nodes.Length() <= 0) Return Null
		If (index >= nodes.Length()) index = nodes.Length() - 1
		
		Local point:FlxPoint = nodes.Get(index)
		nodes.Remove(index)
		Return point
	End Method
	
	Method Head:FlxPoint()
		If (nodes.Length() > 0) Return nodes.Get(0)
		Return Null
	End Method
	
	Method Tail:FlxPoint()
		If (nodes.Length() > 0) Return nodes.Top()
		Return Null	
	End Method
	
	Method DrawDebug:Void(camera:FlxCamera = Null)
		If (nodes.Length() <= 0) Return
		If (camera = Null) camera = FlxG.Camera
	
		Local node:FlxPoint
		Local nextNode:FlxPoint
		Local i:Int = 0
		Local l:Int = nodes.Length()
		
		Local fromX:Float
		Local fromY:Float		
		
		While(i < l)
			node = nodes.Get(i)
			
			_point.x = node.x - Int(camera.scroll.x * debugScrollFactor.x)
			_point.y = node.y - Int(camera.scroll.y * debugScrollFactor.y)
			
			If (_point.x > 0) Then
				_point.x = Int(_point.x + 0.0000001)
			Else
				_point.x = Int(_point.x - 0.0000001)			
			End If
			
			If (_point.y > 0) Then
				_point.y = Int(_point.y + 0.0000001)
			Else
				_point.y = Int(_point.y - 0.0000001)			
			End If
			
			Local nodeSize:Int = 2
			If (i = 0 Or i = l - 1) nodeSize *= 2
			
			If (_debugNodeColor = Null) _debugNodeColor = New FlxColor()
			_debugNodeColor.SetARGB(FlxG.WHITE)
			
			If (l > 1) Then
				If (i = 0) Then
					_debugNodeColor.SetARGB(FlxG.GREEN)
					
				ElseIf (i = l -1) Then
					_debugNodeColor.SetARGB(FlxG.RED)
				End If
			End If
			
			SetAlpha(.5)		
			
			If (FlxG._LastDrawingColor <> _debugNodeColor.argb) Then
				SetColor(_debugNodeColor.r, _debugNodeColor.g, _debugNodeColor.b)
				FlxG._LastDrawingColor = _debugNodeColor.argb
			End If
			
			DrawRect(_point.x - nodeSize * 0.5, _point.y - nodeSize * 0.5, nodeSize, nodeSize)
			
			If (i = l - 1) Exit
			
			Local linealpha:Float = .3
			
			nextNode = nodes.Get(i + 1)
			
			_debugNodeColor.SetARGB(debugColor)
			
			SetAlpha(linealpha)
			
			If (FlxG._LastDrawingColor <> _debugNodeColor.argb) Then
				SetColor(_debugNodeColor.r, _debugNodeColor.g, _debugNodeColor.b)
				FlxG._LastDrawingColor = _debugNodeColor.argb
			End If
			
			fromX = _point.x
			fromY = _point.y		
			
			_point.x = nextNode.x - Int(camera.scroll.x * debugScrollFactor.x)
			_point.y = nextNode.y - Int(camera.scroll.y * debugScrollFactor.y)
			
			If (_point.x > 0) Then
				_point.x = Int(_point.x + 0.0000001)
			Else
				_point.x = Int(_point.x - 0.0000001)			
			End If
			
			If (_point.y > 0) Then
				_point.y = Int(_point.y + 0.0000001)
			Else
				_point.y = Int(_point.y - 0.0000001)			
			End If		
			
			DrawLine(fromX, fromY, _point.x, _point.y)
			
			i += 1
		Wend
		
		SetAlpha(1)		
	End Method
	
	Function Manager:DebugPathDisplay()
		Return DebugPathDisplay(FlxG.GetPlugin(DebugPathDisplay.__CLASS__))
	End Function

End Class