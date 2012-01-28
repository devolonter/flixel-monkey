Strict

Import flxsprite

Class FlxParticle Extends FlxSprite

	Global ClassObject:FlxClass = New FlxParticleClass()
	
	Field lifespan:Float
	
	Field friction:Float
	
	Method New()
		Super.New()
		lifespan = 0
		friction = 0
	End Method
	
	Method Update:Void()
		If (lifespan <= 0) Return
		
		lifespan -= FlxG.elapsed
		
		If (lifespan <=0) Then
			Kill() 		
		End If
		
		If (touching) Then
			If (angularVelocity <> 0) Then
				angularVelocity = -angularVelocity
			End If
		End If
		
		If (acceleration.y > 0) Then
			If (touching & FLOOR) Then
				drag.x = friction
				
				If (Not (wasTouching & FLOOR)) Then
					If (velocity.y < -elasticity * 10) Then
						If (angularVelocity <> 0) Then
							angularVelocity *= -elasticity
						End If
					Else
						velocity.y = 0
						angularVelocity = 0
					End If
				End If
			Else
				drag.x = 0				
			End If
		End If
	End Method
	
	Method OnEmit:Void()		
	End Method

End Class

Private
Class FlxParticleClass Implements FlxClass

	Method CreateInstance:Object()
		Return New FlxParticle()
	End Method
	
	Method InstanceOf:Bool(object:Object)			
		Return (FlxParticle(object) <> Null)
	End Method	
	
End Class