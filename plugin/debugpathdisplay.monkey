Strict

Import flixel.flxextern
Import flixel.flxbasic
Import flixel.flxpath

Class DebugPathDisplay extends FlxBasic

	Global __CLASS__:Object
	
Private
	Field _paths:Stack<FlxPath>
	
Public
	Method New()
		Super.New()
		
		_paths = New Stack<FlxPath>
		active = False
	End Method
	
	Method Destroy:Void()		
		Clear()
		_paths = Null
		
		Super.Destroy()
	End Method
	
	Method Draw:Void()
		If (Not FlxG.VisualDebug Or ignoreDrawDebug) Return
		
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
	
	Method ToString:String()
		Return "DebugPathDisplay"	
	End Method

End Class