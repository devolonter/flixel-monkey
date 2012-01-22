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
	
	Method LEFT:Bool() Property
		Return Pressed(MOUSE_LEFT)	
	End Method
	
	Method RIGHT:Bool() Property
		Return Pressed(MOUSE_RIGHT)	
	End Method
	
	Method MIDDLE:Bool() Property
		Return Pressed(MOUSE_MIDDLE)	
	End Method
	
	Method Show:Void(cursor:String = "", scale:Float = 1, xOffset:Int = 0, yOffset:Int = 0)
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

Class FlxCursorLoader Extends FlxResourceLoader<Image>

	Method Load:Image(name:String)
		Return LoadImage(FlxAssetsManager.GetCursorPath(name))	
	End Method

End Class