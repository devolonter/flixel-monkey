Strict

Import mojo

Import xydevice
Import flixel.flxpoint
Import flixel.flxcamera
Import flixel.flxg
Import flixel.system.flxresourcesmanager
Import flixel.system.flxassetsmanager

Import "../../data/flx_cursor.png"

Class Mouse Extends XYDevice

Private
	Global _cursorsManager:FlxResourcesManager<Image> = New FlxResourcesManager<Image>()
	
	Global _cursorLoader:FlxCursorLoader = New FlxCursorLoader()	
	
	Field _cursor:FlxCursor
	
Public
	Method New()
		Super.New(KEY_LMB, KEY_MMB)
		
		_cursor = New FlxCursor()
	End Method
	
	Method Destroy:Void()
		Super.Destroy()
		
		For Local cur:Image = EachIn _cursorsManager.Resources.Values()
			cur.Discard()
		Next
		
		_cursorsManager.Clear()
		
		If (_cursor <> Null) _cursor.Destroy()
		_cursor = Null
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
		If (FlxG.mobile) Return
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
		If (cursor.Length() = 0) cursor = FlxG.DATA_PREFIX + "cursor"
		
		_cursor.pixels = _cursorsManager.GetResource(cursor, _cursorLoader)
		_cursor.pixels.SetHandle(xOffset, yOffset)
	End Method
	
	Method Unload:Void(cursor:String = "")
		If (_cursor <> Null) Then		
			If (cursor.Length() = 0) Then	
				For Local cur:Image = EachIn _cursorsManager.Resources.Values()
					cur.Discard()
				Next
				
				_cursorsManager.Clear()
			Else
				_cursorsManager.GetResource(cursor, _cursorLoader).Discard()
				_cursorsManager.RemoveResource(cursor)
			End If
			
			_cursor = Null
		End If
	End Method	
	
	Method Draw:Void()
		If (Not _cursor.visible) Return
		
		If (FlxG._lastDrawingBlend <> AlphaBlend) Then
			SetBlend(AlphaBlend)
			FlxG._lastDrawingBlend = AlphaBlend
		End If
		
		If (FlxG._lastDrawingColor <> FlxG.WHITE) Then
			SetColor(255, 255, 255)
			FlxG._lastDrawingColor = FlxG.WHITE
		End If
		
		If (FlxG._lastDrawingAlpha <> 1) Then
			SetAlpha(1)
			FlxG._lastDrawingAlpha = 1
		End If
		
		If (_cursor.scale = 1) Then
			DrawImage(_cursor.pixels, _cursor.x, _cursor.y)
		Else
			PushMatrix()
				Scale(_cursor.scale, _cursor.scale)
				DrawImage(_cursor.pixels, _cursor.x, _cursor.y)
			PopMatrix()
		End If
	End Method
	
	Method _UpdateXY:Void()	
		_cursor.x = _globalScreenPosition.x / FlxG._deviceScaleFactorX
		_cursor.y = _globalScreenPosition.y / FlxG._deviceScaleFactorY
		
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