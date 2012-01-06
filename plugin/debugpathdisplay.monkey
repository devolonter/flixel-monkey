Strict

Import flixel.flxbasic
Import flixel.flxpath

Class DebugPathDisplay extends FlxBasic
	
Private
	Field _paths:Stack<FlxPath>
	
Public
	Global CLASS_OBJECT:FlxClass = new DebugPathDisplayClass()

	Method New()
		_paths = New Stack<FlxPath>
		active = False
	End Method
	
	Method Destroy:Void()
		Super.Destroy()
		Clear()
		_paths = Null
	End Method
	
	Method Draw:Void()
		If (Not FlxG.visualDebug Or ignoreDrawDebug) Return
		
		Local i:Int = _paths.Length() - 1
		Local path:FlxPath
		
		While(i >= 0)
			path = _paths.Get(i)
			If (path <> Null And Not path.ignoreDrawDebug) path.DrawDebug()
			i -= 1	
		Wend
	End Method
	
	Method Add:Void(path:FlxPath)
		_paths.Push(path)
	End Method
	
	Method Remove:Void(path:FlxPath)
		_paths.RemoveEach(path)
	End Method
	
	Method Clear:Void()
		Local i:Int = _paths.Length() - 1
		Local path:FlxPath
		
		While(i >= 0)
			path = _paths.Get(i)
			If (path <> Null) path.Destroy()
			i -= 1	
		Wend
		
		_paths.Clear()		
	End Method

End Class

Private
Class DebugPathDisplayClass Implements FlxClass

	Method CreateInstance:FlxBasic()
		Return New DebugPathDisplay()
	End Method
	
	Method InstanceOf:Bool(object:FlxBasic)
		Return (DebugPathDisplay(object) <> Null)
	End Method	
	
End Class