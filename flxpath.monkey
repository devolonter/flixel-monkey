Strict

Import flxpoint
Import flxg
Import flixel.plugin.monkey.flxcolor
Import flixel.plugin.debugpathdisplay


Class FlxPath

	Field nodes:Stack<FlxPoint>
	
	Field debugColor:FlxColor
	
	Field debugScrollFactor:FlxPoint
	
	Field ignoreDrawDebug:Bool
	
Private
	Field _point:FlxPoint
	
Public
	Method New(nodes:Stack<FlxPoint> = Null)
		If (nodes = Null) Then
			Self.nodes = New Stack<FlxPoint>()
		Else
			Self.nodes = nodes	
		End if
		
		_point = New FlxPoint()
		debugScrollFactor = New FlxPoint(1.0, 1.0)
		debugColor = New FlxColor(FlxG.WHITE)
		ignoreDrawDebug = False
		
		Local debugPathDisplay:DebugPathDisplay = Manager()
		If (debugPathDisplay <> Null) debugPathDisplay.Add(Self)			
	End Method

	Method New(nodes:FlxPoint[])
		Super.New(New Stack<FlxPoint>(nodes))		
	End Method

	Method Destroy:Void()
		Local debugPathDisplay:DebugPathDisplay = Manager()
		If (debugPathDisplay <> Null) debugPathDisplay.Remove(Self)
		
		debugScrollFactor = Null
		_point = Null
		nodes = Null
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
			nodes.Insert(i, node)
		Else
			nodes.Insert(i, New FlxPoint(node.x, node.y))	
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
		
		Local point:FlxPoint = nodes.Get(i)
		nodes.Remove(i)
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
	
	Method DrawDebug:Void()
		'TODO		
	End Method
	
	Function Manager:DebugPathDisplay()
		Return DebugPathDisplay(FlxG.GetPlugin(DebugPathDisplay.CLASS_OBJECT))
	End Function

End Class