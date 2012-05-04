Strict

Import flixel
Import flixel.flxtext.driver.angelfont

Function Main:Int()
	New CameraFX()
	Return 0
End Function

Class CameraFX Extends FlxGame
	
	Method New()
		Super.New(640, 480, CameraFXState.ClassObject)	
	End Method
	
	Method OnContentInit:Void()
		Local minSize:Int = FlxAssetsManager.GetFont(FlxText.SYSTEM_FONT).MinSize
		Local maxSize:Int = FlxAssetsManager.GetFont(FlxText.SYSTEM_FONT).MaxSize
		
		FlxTextAngelFontDriver.Init()
		FlxText.SetDefaultDriver(AngelfontTextDriver)
	End Method

End Class

Class CameraFXStateClass Implements FlxClass

	Method CreateInstance:Object()
		Return New CameraFXState()
	End Method
	
	Method InstanceOf:Bool(object:Object)
		Return (CameraFXState(object) <> Null)
	End Method

End Class

Class CameraFXState Extends FlxState

	Global ClassObject:FlxClass = new CameraFXStateClass()
	
	Method Create:Void()		
		Local manual:FlxText = New FlxText(10, 10, 620, "- Press S to shake")
		manual.SetFormat(FlxText.SYSTEM_FONT, 16, FlxG.WHITE, FlxText.ALIGN_LEFT)	
		Add(manual)		
		
		manual = New FlxText(10, 40, 620, "- Press L to flash")	
		manual.SetFormat(FlxText.SYSTEM_FONT, 16, FlxG.WHITE, FlxText.ALIGN_LEFT)	
		Add(manual)
		
		manual = New FlxText(10, 70, 620, "- Press F to fade")	
		manual.SetFormat(FlxText.SYSTEM_FONT, 16, FlxG.WHITE, FlxText.ALIGN_LEFT)	
		Add(manual)
		
		manual = New FlxText(10, 100, 620, "- Press SPACE to stopFX")	
		manual.SetFormat(FlxText.SYSTEM_FONT, 16, FlxG.WHITE, FlxText.ALIGN_LEFT)	
		Add(manual)
	End Method
	
	Method Update:Void()
		If (FlxG.Keys.JustPressed(KEY_S)) Then
			FlxG.Shake()
		End If	
		
		If (FlxG.Keys.JustPressed(KEY_L)) Then
			FlxG.Flash()
		End If
		
		If (FlxG.Keys.JustPressed(KEY_F)) Then
			FlxG.Fade()
		End If
		
		If (FlxG.Keys.JustPressed(KEY_SPACE)) Then
			FlxG.Camera.StopFX()
		End If
	
		Super.Update()
	End Method
	
End Class