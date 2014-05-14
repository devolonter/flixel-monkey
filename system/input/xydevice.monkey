Strict

Import mojo

Import flixel.flxpoint
Import flixel.flxcamera
Import flixel.flxg
Import flixel.system.flxresourcesmanager
Import flixel.system.flxassetsmanager
Import flixel.system.replay.keyrecord
Import flixel.system.replay.xyrecord

Import "../../data/cursor_flx.png"

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
		_lastX = -1
		_lastY = -1
		_point = New FlxPoint()
		_globalScreenPosition = New FlxPoint()	
	End Method
	
	Method Destroy:Void()		
		_point = Null
		_globalScreenPosition = Null
		
		Super.Destroy()
	End Method
	
	Method Update:Void(x:Float, y:Float)
		Super.Update()
		
		_globalScreenPosition.x = Min(Max(0.0, x), Float(FlxG.DeviceWidth))
		_globalScreenPosition.y = Min(Max(0.0, y), Float(FlxG.DeviceHeight))
		
		_UpdateXY()		
	End Method	
	
	Method GetWorldPosition:FlxPoint(camera:FlxCamera, point:FlxPoint)
		If (camera = Null) camera = FlxG.Camera
		If (point = Null) point = New FlxPoint()
		
		GetScreenPosition(camera, _point)
		
		point.x = _point.x + camera.scroll.x
		point.y = _point.y + camera.scroll.y
		
		return point
	End Method
	
	Method GetScreenPosition:FlxPoint(camera:FlxCamera, point:FlxPoint)
		If(camera = Null) camera = FlxG.Camera
		If(point = Null) point = New FlxPoint()
		
		Local zx:Float = 1 / (camera.Zoom * FlxG._DeviceScaleFactorX)
		Local zy:Float = 1 / (camera.Zoom * FlxG._DeviceScaleFactorY)
		
		point.x = (_globalScreenPosition.x - camera.X) * zx - FlxG._DeviceOffsetX * zx
		point.y = (_globalScreenPosition.y - camera.Y) * zy - FlxG._DeviceOffsetY * zy
		
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
		Local camera:FlxCamera = FlxG.Camera
		Local zx:Float = 1 / (camera.Zoom * FlxG._DeviceScaleFactorX)
		Local zy:Float = 1 / (camera.Zoom * FlxG._DeviceScaleFactorY)
		
		screenX = (_globalScreenPosition.x - camera.X) * zx - FlxG._DeviceOffsetX * zx
		screenY = (_globalScreenPosition.y - camera.Y) * zy - FlxG._DeviceOffsetY * zy
		
		Self.x = screenX + camera.scroll.x
		Self.y = screenY + camera.scroll.y
	End Method

End Class