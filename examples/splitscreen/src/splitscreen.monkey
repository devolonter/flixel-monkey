Strict

Import flixel
Import playstate
Import assets

Class SplitScreen Extends FlxGame

	Method New()
		Super.New(800, 600, PlayState.ClassObject)
	End Method
	
	Method OnContentInit:Void()
		FlxAssetsManager.AddString(Assets.LEVEL_DATA, "level.txt")
	End Method

End Class