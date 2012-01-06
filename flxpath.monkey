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
		If (debugPathDisplay != Null) debugPathDisplay.Remove(Self)
		
		debugScrollFactor = Null
		_point = Null
		nodes = Null
	End Method
	
	Method DrawDebug:Void()
		
	End Method
	
	Function Manager:DebugPathDisplay
		Return DebugPathDisplay(FlxG.GetPlugin(DebugPathDisplay.CLASS_OBJECT))
	End Function

End Class