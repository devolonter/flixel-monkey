Strict

Import flxextern
Import flxgroup
Import flxpoint
Import flxsprite
Import flxparticle
Import flxobject
Import flxg

Class FlxEmitter Extends FlxGroup

	Global ClassObject:FlxClass = New FlxEmitterClass()
	
	Field x:Float
	
	Field y:Float
	
	Field width:Float
	
	Field height:Float
	
	Field minParticleSpeed:FlxPoint
	
	Field maxParticleSpeed:FlxPoint
	
	Field particleDrag:FlxPoint
	
	Field minRotation:Float
	
	Field maxRotation:Float
	
	Field gravity:Float
	
	Field on:Bool
	
	Field frequency:Float
	
	Field lifespan:Float
	
	Field bounce:Float
	
	Field particleClass:FlxClass
	
Private
	Field _quantity:Int
	
	Field _explode:Bool
	
	Field _timer:Float
	
	Field _counter:Int
	
	Field _point:FlxPoint
	
Public
	Method New(x:Float = 0, y:Float = 0, size:Float = 0)
		Super.New(size)		
		Self.x = x
		Self.y = y
		width = 0
		height = 0
		minParticleSpeed = New FlxPoint(-100, -100)
		maxParticleSpeed = New FlxPoint(100, 100)
		minRotation = -360
		maxRotation = 360
		gravity = 0
		particleClass = Null
		particleDrag = New FlxPoint()
		frequency = 0.1
		lifespan = 3
		bounce = 0
		_quantity = 0
		_counter = 0
		_explode = True
		on = False
		_point = New FlxPoint()
	End Method
	
	Method Destroy:Void()
		minParticleSpeed = Null
		maxParticleSpeed = Null
		particleDrag = Null
		particleClass = Null
		_point = Null
		Super.Destroy()
	End Method
	
	Method MakeParticles:FlxEmitter(graphic:String, quantity:Int = 50, backedRotations:Int = 16, multiple:Bool = False, collide:Float = 0)
		MaxSize = quantity
		
		Local totalFrames:Int = 1
		
		If (multiple) Then
			Local sprite:FlxSprite = New FlxSprite()
			sprite.LoadGraphic(graphic, True)
			totalFrames = sprite.frames
			sprite.Destroy()
		End If
		
		Local randomFrame:Int
		Local particle:FlxParticle
		Local i:Int = 0
		
		While (i < quantity)
			If (particleClass = Null) Then
				particle = New FlxParticle()
			Else
				particle = FlxParticle(particleClass.CreateInstance())			
			End If
			
			If (multiple) Then
				randomFrame = FlxG.Random() * totalFrames
				
				If (backedRotations > 0) Then
					particle.LoadRotatedGraphic(graphic, backedRotations, randomFrame)
				Else
					particle.LoadGraphic(graphic, True)
					particle.Frame = randomFrame
				End If
			Else
				If (backedRotations > 0) Then
					particle.LoadRotatedGraphic(graphic, backedRotations)
				Else
					particle.LoadGraphic(graphic)
				End If
			End If
			
			If (collide > 0) Then
				particle.width *= collide
				particle.height *= collide
				particle.CenterOffsets()
			Else
				particle.allowCollisions = FlxObject.NONE
			End If
			
			particle.exists = False
			Add(particle)
			
			i += 1
		Wend
		
		Return Self
	End Method
	
	Method Update:Void()
		If (on) Then
			If (_explode) Then
				on = False
				
				Local i:Int = 0
				Local l:Int = _quantity
				
				If (l <= 0 Or l > Length) Then
					l = Length
				End If
				
				While (i < l)
					EmitParticle()
					i += 1
				Wend
				
				_quantity = 0
			Else
				_timer += FlxG.Elapsed
				
				While (frequency > 0 And _timer > frequency And on)
					_timer -= frequency
					EmitParticle()
					
					_counter += 1
					If (_quantity > 0 And _counter >= _quantity) Then
						on = False
						_quantity = 0
					End If				
				Wend
			End If
		End If
		
		Super.Update()
	End Method
	
	Method Kill:Void()
		on = False
		Super.Kill()
	End Method
	
	Method Start:Void(explode:Bool = True, lifespan:Float = 0, frequency:Float = .1, quantity:Int = 0)
		Revive()
		visible = True
		on = True
		
		_explode = explode
		Self.lifespan = lifespan
		Self.frequency = frequency
		_quantity += quantity
		
		_counter = 0
		_timer = 0
	End Method
	
	Method EmitParticle:Void()
		Local particle:FlxParticle = FlxParticle(Recycle(FlxParticle.ClassObject))
		particle.lifespan = lifespan
		particle.elasticity = bounce
		particle.Reset(x - (particle.width Shr 1) + FlxG.Random() * width, y - (particle.height Shr 1) + FlxG.Random() * height)
		particle.visible = True
		
		If (minParticleSpeed.x <> maxParticleSpeed.x) Then
			particle.velocity.x = minParticleSpeed.x + FlxG.Random() * (maxParticleSpeed.x - minParticleSpeed.x)
		Else
			particle.velocity.x = minParticleSpeed.x
		End If
		
		If (minParticleSpeed.y <> maxParticleSpeed.y) Then
			particle.velocity.y = minParticleSpeed.y + FlxG.Random() * (maxParticleSpeed.y - minParticleSpeed.y)
		Else
			particle.velocity.y = minParticleSpeed.y
		End If
		
		particle.acceleration.y = gravity
		
		If (minRotation <> maxRotation) Then
			particle.angularVelocity = minRotation + FlxG.Random() * (maxRotation - minRotation)
		Else
			particle.angularVelocity = minRotation
		End If
		
		If (particle.angularVelocity <> 0) Then
			particle.angle = FlxG.Random()*360 - 180
		End If
		
		particle.drag.x = particleDrag.x
		particle.drag.y = particleDrag.y
		
		particle.OnEmit()
	End Method
	
	Method SetSize:Void(width:Int, height:Int)
		Self.width = width
		Self.height = height
	End Method
	
	Method SetXSpeed:Void(min:Float = 0, max:Float = 0)
		minParticleSpeed.x = min
		maxParticleSpeed.x = max
	End Method
	
	Method SetYSpeed:Void(min:Float = 0, max:Float = 0)
		minParticleSpeed.y = min
		maxParticleSpeed.y = max
	End Method
	
	Method SetRotation:Void(min:Float = 0, max:Float = 0)
		minRotation = min
		maxRotation = max
	End Method
	
	Method At:Void(object:FlxObject)
		object.GetMidpoint(_point)
		x = _point.x - (width Shr 1)
		y = _point.y - (height Shr 1)
	End Method

End Class

Private
Class FlxEmitterClass Implements FlxClass

	Method CreateInstance:Object()
		Return New FlxEmitter()
	End Method
	
	Method InstanceOf:Bool(object:Object)			
		Return (FlxEmitter(object) <> Null)
	End Method	
	
End Class