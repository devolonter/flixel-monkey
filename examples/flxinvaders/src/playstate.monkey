Strict

Import flixel

Import playership
Import alien

Class PlayState Extends FlxState

	Global _CLASS:FlxClass = New PlayStateClass()
	
	Field player:PlayerShip
	Field aliens:FlxGroup
	Field aliensBullets:FlxGroup
	
	Method Create:Void()
		player = New PlayerShip()
		Add(player)
		
		Local sprite:FlxSprite
		
		Local numAlienBullets:Int = 32
		aliensBullets = New FlxGroup(numAlienBullets)
		
		For Local i:Int = 0 Until numAlienBullets
			sprite = New FlxSprite(-100, -100)
			sprite.MakeGraphic(2, 8)
			sprite.exists = False
			aliensBullets.Add(sprite)
		Next
		Add(aliensBullets)		
		
		Local numAliens:Int = 50
		aliens = New FlxGroup(numAliens)		
		Local a:Alien
		Local colors:Int[] = [FlxG.BLUE, FlxG.BLUE | FlxG.GREEN, FlxG.GREEN, FlxG.GREEN | FlxG.RED, FlxG.RED]		
				
		For Local i:Int = 0 Until numAliens
			a = New Alien(8 + (i Mod 10) * 32, 24 + Int(i / 10) * 32, colors[Int(i / 10)], aliensBullets)
			aliens.Add(a)
		Next
		Add(aliens)
	End Method
	
	Method Update:Void()
		If (KeyHit(KEY_ESCAPE)) Error ""
		
		Local alien:Alien = Alien(aliens.Members[0])
		
		If (alien.x < 0 Or alien.x > 16) Then
			aliens.CallAll(Alien.ReverseVelocity)	
		End If
		
		Super.Update()
	End Method

End Class

Class PlayStateClass Implements FlxClass
	
	Method CreateInstance:FlxBasic()
		Return New PlayState()
	End Method
	
	Method InstanceOf:Bool(object:FlxBasic)
		Return (PlayState(object) <> Null)
	End Method

End Class