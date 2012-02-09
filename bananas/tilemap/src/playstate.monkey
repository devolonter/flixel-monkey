Strict

Import flixel
Import assets

Class PlayState Extends FlxState

	Global ClassObject:FlxClass = New PlayStateClass()

	Const TILE_WIDTH:Int = 16
	Const TILE_HEIGHT:Int = 16
	
	Field collisionMap:FlxTilemap
	
	Field highlightBox:FlxObject
	
	Field player:FlxSprite
	
	Field autoAltBtn:FlxButton
	Field resetBtn:FlxButton
	
	Field helperTxt:FlxText
			
	Method Create:Void()
		collisionMap = New FlxTilemap()
		collisionMap.LoadMap(FlxAssetsManager.GetString(Assets.AUTO_MAP), Assets.AUTO_TILES, 
							TILE_WIDTH, TILE_HEIGHT, FlxTilemap.AUTO)
			
		Add(collisionMap)
		
		highlightBox = New FlxObject(0, 0, TILE_WIDTH, TILE_HEIGHT)
		
		_SetupPlayer()
		
		autoAltBtn = New FlxButton(4, FlxG.Height - 24, "AUTO", New BtnAutoAltClicklListener(Self))
		Add(autoAltBtn)
		
		resetBtn = New FlxButton(8 + autoAltBtn.width, FlxG.Height - 24, "Reset", New BtnResetClickListener(Self))
		Add(resetBtn)
		
		helperTxt = New FlxText(24 + autoAltBtn.width * 2, FlxG.Height - 30, 220, "Click to place tiles, Shift-Click to remove tiles, arrow keys to move")	
		Add(helperTxt)
		
		FlxG.Mouse.Show()	
	End Method
	
	Method Update:Void()		
		highlightBox.x = Floor(FlxG.Mouse.x / TILE_WIDTH) * TILE_WIDTH
		highlightBox.y = Floor(FlxG.Mouse.y / TILE_HEIGHT) * TILE_HEIGHT
		
		If (FlxG.Mouse.Pressed()) Then
			collisionMap.SetTile(FlxG.Mouse.x / TILE_WIDTH, FlxG.Mouse.y / TILE_HEIGHT, Not FlxG.Keys.Shift)
		End If
		
		If (FlxG.Keys.JustPressed(KEY_ESCAPE)) Error ""
		_UpdatePlayer()
		
		Super.Update()
		
		FlxG.Collide(player, collisionMap)
	End Method
	
	Method Draw:Void()
		Super.Draw()
		highlightBox.DrawDebug()
	End Method

Private	
	Method _SetupPlayer:Void()
		player = New FlxSprite(64, 220)
		player.LoadGraphic(Assets.PLAYER, True, True, 16)
		
		player.width = 14
		player.height = 14
		player.offset.x = 1
		player.offset.y = 1
		
		player.drag.x = 640
		player.acceleration.y = 420
		player.maxVelocity.x = 80
		player.maxVelocity.y = 200
		
		player.AddAnimation("idle", [0])
		player.AddAnimation("run", [1, 2, 3, 0], 12)
		player.AddAnimation("jump", [4])
		
		Add(player)
	End Method
	
	Method _UpdatePlayer:Void()
		_Wrap(player)
		
		player.acceleration.x = 0
		
		If (FlxG.Keys.Left) Then
			player.Facing = FlxObject.LEFT
			player.acceleration.x -= player.drag.x
			
		ElseIf (FlxG.Keys.Right) Then
			player.Facing = FlxObject.RIGHT
			player.acceleration.x += player.drag.x
		End If
		
		If (FlxG.Keys.JustPressed(KEY_UP) And player.velocity.y = 0) Then
			player.y -= 1
			player.velocity.y = -200
		End If
		
		If (player.velocity.y <> 0) Then
			player.Play("jump")
		
		ElseIf (player.velocity.x = 0) Then
			player.Play("idle")
			
		Else
			player.Play("run")
		End If
	End Method
	
	Method _Wrap:Void(obj:FlxObject)
		obj.x = (obj.x + obj.width / 2 + FlxG.Width) Mod FlxG.Width - obj.width / 2
		obj.y = (obj.y + obj.height / 2) Mod FlxG.Height - obj.height / 2
	End Method

End Class

Class BtnAutoAltClicklListener Extends BtnClickListener

	Method New(state:PlayState)
		Super.New(state)
	End Method
	
	Method OnButtonClick:Void()
		Select (state.collisionMap.auto)
			Case FlxTilemap.AUTO
				state.collisionMap.LoadMap(FlxTilemap.ArrayToCSV(state.collisionMap.GetData(True), 
					state.collisionMap.widthInTiles), Assets.ALT_TILES, 
					PlayState.TILE_WIDTH, PlayState.TILE_HEIGHT, FlxTilemap.ALT)
				
			state.autoAltBtn.label.Text = "ALT"
					
			Case FlxTilemap.ALT
				state.collisionMap.LoadMap(FlxTilemap.ArrayToCSV(state.collisionMap.GetData(True), 
					state.collisionMap.widthInTiles), Assets.EMPTY_TILES, 
					PlayState.TILE_WIDTH, PlayState.TILE_HEIGHT, FlxTilemap.OFF)
					
			state.autoAltBtn.label.Text = "OFF"
					
			Case FlxTilemap.OFF
				state.collisionMap.LoadMap(FlxTilemap.ArrayToCSV(state.collisionMap.GetData(True), 
					state.collisionMap.widthInTiles), Assets.AUTO_TILES, 
					PlayState.TILE_WIDTH, PlayState.TILE_HEIGHT, FlxTilemap.AUTO)
					
			state.autoAltBtn.label.Text = "AUTO"
					
		End Select
	End Method

End Class

Class BtnResetClickListener Extends BtnClickListener
	
	Method New(state:PlayState)
		Super.New(state)
	End Method
	
	Method OnButtonClick:Void()
		Select (state.collisionMap.auto)
			Case FlxTilemap.AUTO
				state.collisionMap.LoadMap(FlxAssetsManager.GetString(Assets.AUTO_MAP), 
					Assets.AUTO_TILES, PlayState.TILE_WIDTH, PlayState.TILE_HEIGHT, FlxTilemap.AUTO)
					
				state.player.x = 64
				state.player.y = 220
					
			Case FlxTilemap.ALT
				state.collisionMap.LoadMap(FlxAssetsManager.GetString(Assets.ALT_MAP), 
					Assets.ALT_TILES, PlayState.TILE_WIDTH, PlayState.TILE_HEIGHT, FlxTilemap.ALT)
					
				state.player.x = 64
				state.player.y = 128
					
			Case FlxTilemap.OFF
				state.collisionMap.LoadMap(FlxAssetsManager.GetString(Assets.EMPTY_MAP), 
					Assets.EMPTY_TILES, PlayState.TILE_WIDTH, PlayState.TILE_HEIGHT, FlxTilemap.OFF)
					
				state.player.x = 64
				state.player.y = 64
					
		End Select
	End Method

End Class

Class BtnClickListener Implements FlxButtonClickListener

	Field state:PlayState

	Method New(state:PlayState)
		Self.state = state
	End Method
	
	Method OnButtonClick:Void()
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