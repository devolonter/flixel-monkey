Strict

Import mojo

Import flixel.flxpoint
Import flixel.flxcamera
Import flixel.flxg
Import flixel.system.flxresourcesmanager
Import flixel.system.flxassetsmanager

Import "../../data/flx_cursor.png"

Class Mouse Extends Input

	Field x:Float
	
	Field y:Float
	
	Field screenX:Float
	
	Field screenY:Float

Private
	Global _cursorsManager:FlxResourcesManager<Image> = New FlxResourcesManager<Image>()
	
	Global _cursorLoader:FlxCursorLoader = New FlxCursorLoader()	
	
	Field _cursor:FlxCursor
	
	Field _lastX:Float
	
	Field _lastY:Float
	
	Field _point:FlxPoint
	
	Field _globalScreenPosition:FlxPoint	
	
Public
	Method New()
		Super.New(KEY_LMB, KEY_MMB)
	
		x = 0
		y = 0
		screenX = 0
		screenY = 0
		_lastX = 0
		_lastY = 0
		_point = New FlxPoint()
		_globalScreenPosition = New FlxPoint()	
	End Method
	
	Method Destroy:Void()
		Super.Destroy()
		
		For Local cur:Image = EachIn _cursorsManager.Resources.Values()
			cur.Discard()
		Next
		
		_cursorsManager.Clear()
		
		If (_cursor <> Null) _cursor.Destroy()
		_cursor = Null
		_point = Null
		_globalScreenPosition = Null
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
	
	Method Update:Void(x:Float, y:Float)
		Super.Update()
	
		_globalScreenPosition.x = x
		_globalScreenPosition.y = y
		
		_UpdateCursor()
	End Method
	
	Method GetWorldPosition:FlxPoint(camera:FlxCamera)
		'TODO
		Return Null
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
Private	
	Method _UpdateCursor:Void()
		_cursor.x = _globalScreenPosition.x
		_cursor.y = _globalScreenPosition.y
		
		Local camera:FlxCamera = FlxG.camera
		
		screenX = (_globalScreenPosition.x - camera.X) / (camera.Zoom * FlxG._deviceScaleFactorX)
		screenY = (_globalScreenPosition.y - camera.Y) / (camera.Zoom * FlxG._deviceScaleFactorY)
		x = screenX + camera.scroll.x
		y = screenY + camera.scroll.y		
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