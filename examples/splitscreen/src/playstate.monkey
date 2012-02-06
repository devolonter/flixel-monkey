Strict

Import flixel
Import assets

Class PlayState Extends FlxState

	Global ClassObject:FlxClass = New PlayStateClass()
	
	Field level:FlxTilemap
	Field player1:FlxSprite
	Field player2:FlxSprite
	
	Method Create:Void()
		FlxG.mouse.Show()
		
		level = New FlxTilemap()
		level.LoadMap(FlxAssetsManager.GetString(Assets.LEVEL_DATA), FlxTilemap.AUTOTILES, 0, 0, FlxTilemap.AUTO)
		Add(level)
		
		player1 = (New FlxSprite(65, 200)).MakeGraphic(10, 12, $FFFF0000)
		player1.maxVelocity.x = 80
		player1.maxVelocity.y = 200
		player1.acceleration.y = 200
		player1.drag.x = player1.maxVelocity.x * 4
		Add(player1)		
		
		player2 = (New FlxSprite(265, 200)).MakeGraphic(10, 12, $FF0000FF)
		player2.maxVelocity.x = 80
		player2.maxVelocity.y = 200
		player2.acceleration.y = 200
		player2.drag.x = player1.maxVelocity.x * 4
		Add(player2)
		
		Local cam:FlxCamera = New FlxCamera(0, 0, FlxG.width / 2, FlxG.height)
		cam.BgColor = $FFFDCBCB
		cam.Follow(player2)
		cam.SetBounds(0, 0, level.width, level.height)	
		FlxG.AddCamera(cam)
		
		cam= New FlxCamera(FlxG.width / 2, 0, FlxG.width / 2, FlxG.height)
		cam.BgColor = $FFCBCBFD
		cam.Follow(player1)
		cam.SetBounds(0, 0, level.width, level.height)		
		FlxG.AddCamera(cam)
		
		FlxG.camera.active = False
	End Method
	
	Method Update:Void()
		FlxG.Collide()
	
		player1.acceleration.x = 0
		
		If (FlxG.keys.Left) Then
			player1.acceleration.x = -player1.maxVelocity.x * 4
		End If
		
		If (FlxG.keys.Right) Then
			player1.acceleration.x = player1.maxVelocity.x * 4
		End If
		
		If (FlxG.keys.JustPressed(KEY_UP) And player1.IsTouching(FlxObject.FLOOR)) Then
			player1.velocity.y -= player1.maxVelocity.y / 1.5
		End If
		
		player2.acceleration.x = 0
		
		If (FlxG.keys.A) Then
			player2.acceleration.x = -player2.maxVelocity.x * 4
		End If
		
		If (FlxG.keys.D) Then
			player2.acceleration.x = player2.maxVelocity.x * 4
		End If
		
		If (FlxG.keys.JustPressed(KEY_W) And player2.IsTouching(FlxObject.FLOOR)) Then
			player2.velocity.y -= player2.maxVelocity.y / 1.5
		End If
			
		Super.Update()
	End Method

End Class

Class PlayStateClass Implements FlxClass
	
	Method CreateInstance:Object()
		Return New PlayState()
	End Method
	
	Method InstanceOf:Bool(object:Object)
		Return PlayState(object) <> Null
	End Method

End Class