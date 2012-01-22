Strict

Import mojo

Import flixel.flxpoint
Import flixel.flxcamera
Import flixel.flxg
Import flixel.system.flxresourcesmanager
Import flixel.system.flxassetsmanager
Import flixel.system.replay.keyrecord
Import flixel.system.replay.xyrecord

Import "../../data/flx_cursor.png"

Class XYDevice Extends Input Abstract

	Field x:Float
	
	Field y:Float
	
	Field screenX:Float
	
	Field screenY:Float
	
	Field _globalScreenPosition:FlxPoint

Private	
	Field _lastX:Int
	
	Field _lastY:Int
	
	Field _point:FlxPoint	
	
Public
	Method New(fromKey:Int, toKey:Int)
		Super.New(fromKey, toKey)
	
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
		_point = Null
		_globalScreenPosition = Null
	End Method
	
	Method Update:Void(x:Float, y:Float)
		Super.Update()
		
		_globalScreenPosition.x = x
		_globalScreenPosition.y = y
		
		_UpdateXY()		
	End Method	
	
	Method GetWorldPosition:FlxPoint(camera:FlxCamera, point:FlxPoint)
		If (camera = Null) camera = FlxG.camera
		If (point = Null) point = New FlxPoint()
		
		GetScreenPosition(camera, _point)
		
		point.x = _point.x + camera.scroll.x
		point.y = _point.y + camera.scroll.y
		
		return point
	End Method
	
	Method GetScreenPosition:FlxPoint(camera:FlxCamera, point:FlxPoint)
		If (camera = Null) camera = FlxG.camera
		If (point = Null) point = New FlxPoint()
		
		point.x = (_globalScreenPosition.x - camera.X) / (camera.Zoom * FlxG._deviceScaleFactorX)
		point.y = (_globalScreenPosition.y - camera.y) / (camera.Zoom * FlxG._deviceScaleFactorY)
		
		Return point
	End Method
	
	Method RecordXY:XYRecord()
		If (_lastX = _globalScreenPosition.x And _lastY = _globalScreenPosition.y) Then
			Return Null
		End If
		
		_lastX = _globalScreenPosition.x
		_lastY = _globalScreenPosition.y
		
		Return New XYRecord(_lastX, _lastY)		
	End Method
	
	Method PlaybackXY:Void(record:XYRecord)
		_globalScreenPosition.x = record.x
		_globalScreenPosition.y = record.y
		
		_UpdateXY()
	End Method
	
	Method _UpdateXY:Void()
		Local camera:FlxCamera = FlxG.camera
		
		screenX = (x - camera.X) / (camera.Zoom * FlxG._deviceScaleFactorX)
		screenY = (y - camera.Y) / (camera.Zoom * FlxG._deviceScaleFactorY)
		
		Self.x = screenX + camera.scroll.x
		Self.y = screenY + camera.scroll.y
	End Method

End Class