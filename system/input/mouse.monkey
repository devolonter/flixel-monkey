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
	
	Field _cursor:FlxCursor
	
Public
	Method New()
		Super.New(KEY_LMB, KEY_MMB)
		
		_cursor = New FlxCursor()
	End Method
	
	Method Destroy:Void()
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
		
		If (FlxG._Game.useSystemCursor) Then
			ShowMouse()
			Return
		End If
		
		If (_cursor = Null) Then
			_cursor = New FlxCursor()
			HideMouse()
		End If
		
		_cursor.visible = True
		
		If (cursor.Length() > 0) Then
			Load(cursor, scale, xOffset, yOffset)
		Else
			Load()
		End If
	End Method
	
	Method Hide:Void()
		If (FlxG._Game.useSystemCursor) Then
			HideMouse()
		Else
			_cursor.visible = False
		End If
	End Method
	
	Method Visible:Bool() Property
		Return _cursor.visible
	End Method
	
	Method Load:Void(cursor:String = "", scale:Float = 1, xOffset:Int = 0, yOffset:Int = 0)		
		If (cursor.Length() = 0) cursor = "cursor" + FlxG.DATA_SUFFIX
		
		_cursor.pixels = _CursorsManager.GetResource(cursor, New CursorResource(cursor))
		_cursor.pixels.SetHandle(xOffset, yOffset)
		_cursor.scale = scale
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
		
		Transform(FlxG._DeviceScaleFactorX, 0, 0, FlxG._DeviceScaleFactorY, _cursor.x, _cursor.y)
		
		If(_cursor.scale <> 1) Then
			PushMatrix()
				Scale(_cursor.scale, _cursor.scale)
				DrawImage(_cursor.pixels, 0, 0)
			PopMatrix()
		Else
			DrawImage(_cursor.pixels, 0, 0)
		End If
	End Method
	
	Method _UpdateXY:Void()	
		_cursor.x = _globalScreenPosition.x
		_cursor.y = _globalScreenPosition.y
		
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

Class CursorResource Extends FlxResource<Image>

	Field image:Image
	
	Method New(name:String)
		Super.New(name)
	End Method

	Method Load:Image()
		image = LoadImage(FlxAssetsManager.GetCursorPath(name))
		Return image
	End Method
	
	Method Use:Image()
		Return image
	End Method
	
	Method Discard:Void()
		image.Discard()
		image = Null
	End Method

End Class