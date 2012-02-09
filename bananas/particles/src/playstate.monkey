Strict

Import flixel

Class PlayState Extends FlxState

	Global ClassObject:FlxClass = New PlayStateClass()
	
	Field theEmiter:FlxEmitter
	
	Field whitePixel:FlxParticle
	
	Field collisionButton:FlxButton
	Field gravityButton:FlxButton
	
	Field collisionGroup:FlxGroup
	Field wall:FlxSprite
	Field floor:FlxSprite	
	
	Field isGravityOn:Bool = False
	Field isCollisionOn:Bool = False
	
	Field topText:FlxText
			
	Method Create:Void()
		theEmiter = New FlxEmitter(10, FlxG.Height / 2, 200)
		
		theEmiter.SetXSpeed(100, 200)
		theEmiter.SetYSpeed(-50, 50)
		theEmiter.bounce = .8		
		Add(theEmiter)
		
		For Local i:Int = 0 Until theEmiter.MaxSize / 2
			whitePixel = New FlxParticle()
			whitePixel.MakeGraphic(2, 2, $FFFFFFFF)
			whitePixel.visible = False
			theEmiter.Add(whitePixel)
			
			whitePixel = New FlxParticle()
			whitePixel.MakeGraphic(1, 1, $FFFFFFFF)
			whitePixel.visible = False
			theEmiter.Add(whitePixel)
		Next
		
		collisionButton = New FlxButton(2, FlxG.Height - 22, "Collision", New BtnCollisionClicklListener(Self))
		Add(collisionButton)
		
		gravityButton = New FlxButton(82, FlxG.Height - 22, "Gravity", New BtnGravityClickListener(Self))
		Add(gravityButton)
		
		topText = New FlxText(0, 2, FlxG.Width, "Welcome")
		topText.Alignment = FlxText.ALIGN_CENTER		
		Add(topText)
		
		collisionGroup = New FlxGroup()
		
		wall = New FlxSprite(100, 100)
		wall.MakeGraphic(10, 100, $50FFFFFF)
		wall.visible = False
		wall.Solid = False
		wall.immovable = True
		collisionGroup.Add(wall)
		
		floor = New FlxSprite(10, 267)
		floor.MakeGraphic(FlxG.Width - 20, 10, $50FFFFFF)
		floor.visible = False
		floor.Solid = False
		floor.immovable = True
		collisionGroup.Add(floor)
		
		Add(collisionGroup)
		
		theEmiter.Start(False, 3, .01)
					
		FlxG.Mouse.Show()	
	End Method
	
	Method Update:Void()
		If (topText.Alpha > 0) Then
			topText.Alpha -= 0.01			
		End If		
		
		If (FlxG.Keys.JustPressed(KEY_ESCAPE)) Error ""
		
		Super.Update()
		
		FlxG.Collide(theEmiter, collisionGroup)
	End Method
	
	Method OnCollision:Void()
		isCollisionOn = Not isCollisionOn
		
		If (isCollisionOn) Then
			If (isGravityOn) Then
				floor.Solid = True
				floor.visible = True
				wall.Solid = False
				wall.visible = False
			Else
				floor.Solid = False
				floor.visible = False
				wall.Solid = True
				wall.visible = True
			End If
			
			topText.Text = "Collision: ON"
		Else
			floor.Solid = False
			floor.visible = False
			wall.Solid = False
			wall.visible = False
			
			topText.Text = "Collision: OFF"			
		End If
		
		topText.Alpha = 1
	End Method
	
	Method OnGravity:Void()
		isGravityOn = Not isGravityOn
		
		If (isGravityOn) Then
			theEmiter.gravity = 200
			
			If (isCollisionOn) Then
				floor.Solid = True
				floor.visible = True
				wall.Solid = False
				wall.visible = False
			End If
			
			For Local basic:FlxBasic = EachIn theEmiter
				FlxParticle(basic).acceleration.y = 200
			Next
			
			topText.Text = "Gravity: ON"
		Else
			theEmiter.gravity = 0
			
			If (isCollisionOn) Then
				floor.Solid = False
				floor.visible = False
				wall.Solid = True
				wall.visible = True
			End If
			
			For Local basic:FlxBasic = EachIn theEmiter
				FlxParticle(basic).acceleration.y = 0
			Next
			
			topText.Text = "Gravity: OFF"
		End If
		
		topText.Alpha = 1
	End Method

End Class

Class BtnCollisionClicklListener Extends BtnClickListener

	Method New(state:PlayState)
		Super.New(state)
	End Method
	
	Method OnButtonClick:Void()
		state.OnCollision()
	End Method

End Class

Class BtnGravityClickListener Extends BtnClickListener
	
	Method New(state:PlayState)
		Super.New(state)
	End Method
	
	Method OnButtonClick:Void()
		state.OnGravity()
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