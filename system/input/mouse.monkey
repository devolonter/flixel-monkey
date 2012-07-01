Strict

Import mojo

Import xydevice
Import flixel.flxpoint
Import flixel.flxcamera
Import flixel.flxg
Import flixel.system.flxresourcesmanager
Import flixel.system.flxassetsmanager

Import "../../data/cursor_flx.png"

Class Mouse Extends XYDevice

Private
	Global _CursorsManager:FlxResourcesManager<Image> = New FlxResourcesManager<Image>()
	
	Global _CursorLoader:FlxCursorLoader = New FlxCursorLoader()	
	
	Field _cursor:FlxCursor
	
Public
	Method New()
		Super.New(KEY_LMB, KEY_MMB)
		
		_cursor = New FlxCursor()
	End Method
	
	Method Destroy:Void()		
		For Local cur:Image = EachIn _CursorsManager.Resources.Values()
			cur.Discard()
		Next
		
		_CursorsManager.Clear()
		
		If (_cursor <> Null) _cursor.Destroy()
		_cursor = Null
		
		Super.Destroy()
	End Method
	
	Method Left:Bool() Property
		Return Pressed(KEY_LMB)	
	End Method
	
	Method Right:Bool() Property
		Return Pressed(KEY_RMB)	
	End Method
	
	Method Middle:Bool() Property
		Return Pressed(KEY_MMB)	
	End Method
	
	Method Pressed:Bool()
		Return Super.Pressed(KEY_LMB)
	End Method
	
	Method JustPressed:Bool()
		Return Super.JustPressed(KEY_LMB)
	End Method
	
	Method JustReleased:Bool()
		Return Super.JustReleased(KEY_LMB)
	End Method
	
	Method Pressed:Bool(button:Int)
		Return Super.Pressed(KEY_LMB + button)
	End Method
	
	Method JustPressed:Bool(button:Int)
		Return Super.JustPressed(KEY_LMB + button)
	End Method
	
	Method JustReleased:Bool(button:Int)
		Return Super.JustReleased(KEY_LMB + button)
	End Method
	
	Method Show:Void(cursor:String = "", scale:Float = 1, xOffset:Int = 0, yOffset:Int = 0)
		If (FlxG.Mobile) Return
		If (_cursor = Null) _cursor = New FlxCursor()
		
		HideMouse()
		_cursor.visible = True
		
		If (cursor.Length() > 0) Then
			Load(cursor, scale, xOffset, yOffset)
		Else
			Load()
		End If
	End Method
	
	Method Hide:Void()
		_cursor.visible = False
	End Method
	
	Method Visible:Bool() Property
		Return _cursor.visible
	End Method
	
	Method Load:Void(cursor:String = "", scale:Float = 1, xOffset:Int = 0, yOffset:Int = 0)		
		If (cursor.Length() = 0) cursor = "cursor" + FlxG.DATA_SUFFIX
		
		_cursor.pixels = _CursorsManager.GetResource(cursor, _CursorLoader)
		_cursor.pixels.SetHandle(xOffset, yOffset)
	End Method
	
	Method Unload:Void(cursor:String = "")
		If (_cursor <> Null) Then		
			If (cursor.Length() = 0) Then	
				For Local cur:Image = EachIn _CursorsManager.Resources.Values()
					cur.Discard()
				Next
				
				_CursorsManager.Clear()
			Else
				_CursorsManager.GetResource(cursor, _CursorLoader).Discard()
				_CursorsManager.RemoveResource(cursor)
			End If
			
			_cursor = Null
		End If
	End Method	
	
	Method Draw:Void()
		If (Not _cursor.visible) Return
		
		If (FlxG._LastDrawingBlend <> AlphaBlend) Then
			SetBlend(AlphaBlend)
			FlxG._LastDrawingBlend = AlphaBlend
		End If
		
		If (FlxG._LastDrawingColor <> FlxG.WHITE) Then
			SetColor(255, 255, 255)
			FlxG._LastDrawingColor = FlxG.WHITE
		End If
		
		If (FlxG._LastDrawingAlpha <> 1) Then
			SetAlpha(1)
			FlxG._LastDrawingAlpha = 1
		End If
		
		Translate(_cursor.x, _cursor.y)
		
		PushMatrix()
			Scale(_cursor.scale * FlxG.Camera.Zoom, _cursor.scale * FlxG.Camera.Zoom)
			DrawImage(_cursor.pixels, 0, 0)
		PopMatrix()
	End Method
	
	Method _UpdateXY:Void()	
		_cursor.x = _globalScreenPosition.x / FlxG._DeviceScaleFactorX
		_cursor.y = _globalScreenPosition.y / FlxG._DeviceScaleFactorY
		
		Super._UpdateXY()
	End Method
End Class

Private
Class FlxCursor Extends FlxPoint
	
	Field pixels:Image
	
	Field scale:Float
	
	Field visible:Bool

	Method New()
		Super.New()
		
		pixels = Null
		scale = 1
		visible = False
	End Method
	
	Method Destroy:Void()
		pixels = Null
	End Method

End Class

Class FlxCursorLoader Extends FlxResourceLoader<Image>

	Method Load:Image(name:String)
		Return LoadImage(FlxAssetsManager.GetCursorPath(name))	
	End Method

End Class