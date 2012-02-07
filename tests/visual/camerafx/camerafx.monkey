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
		
		Local angelSystemFont:FlxFont = FlxAssetsManager.AddFont("system", FlxText.DRIVER_ANGELFONT)
		
		For Local i:Int = minSize To maxSize
			angelSystemFont.SetPath(i, "fonts/"+FlxText.SYSTEM_FONT+"/angelfont/"+i+".txt")	
		Next
	End Method

End Class

Class CameraFXStateClass Implements FlxClass

	Method CreateInstance:FlxBasic()
		Return New CameraFXState()
	End Method
	
	Method InstanceOf:Bool(object:FlxBasic)
		Return (CameraFXState(object) <> Null)
	End Method

End Class

Class CameraFXState Extends FlxState

	Global ClassObject:FlxClass = new CameraFXStateClass()
	
	Method Create:Void()		
		Local manual:FlxText = New FlxText(10, 10, 620, "- Press S to shake", New FlxTextAngelFontDriver())	
		manual.SetFormat(FlxText.SYSTEM_FONT, 16, FlxG.WHITE, FlxText.ALIGN_LEFT)	
		Add(manual)		
		
		manual = New FlxText(10, 40, 620, "- Press L to flash", New FlxTextAngelFontDriver())	
		manual.SetFormat(FlxText.SYSTEM_FONT, 16, FlxG.WHITE, FlxText.ALIGN_LEFT)	
		Add(manual)
		
		manual = New FlxText(10, 70, 620, "- Press F to fade", New FlxTextAngelFontDriver())	
		manual.SetFormat(FlxText.SYSTEM_FONT, 16, FlxG.WHITE, FlxText.ALIGN_LEFT)	
		Add(manual)
		
		manual = New FlxText(10, 100, 620, "- Press SPACE to stopFX", New FlxTextAngelFontDriver())	
		manual.SetFormat(FlxText.SYSTEM_FONT, 16, FlxG.WHITE, FlxText.ALIGN_LEFT)	
		Add(manual)
	End Method
	
	Method Update:Void()
		If (KeyHit(KEY_S)) Then
			FlxG.Shake()
		End If	
		
		If (KeyHit(KEY_L)) Then
			FlxG.Flash()
		End If
		
		If (KeyHit(KEY_F)) Then
			FlxG.Fade()
		End If
		
		If (KeyHit(KEY_SPACE)) Then
			FlxG.Camera.StopFX()
		End If
	
		Super.Update()
	End Method
	
End Class