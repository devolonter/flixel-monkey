Strict

Import flixel.flxsprite

Class FlxPrimitiveSpriteRenderer Implements FlxSpriteRenderer Abstract
	
	Method OnSpriteBind:Void(sprite:FlxSprite)
		_sprite = sprite
		_sprite.Pixels = Null
	End Method
	
	Method OnSpriteUnbind:Void()
		_sprite.Pixels = Null
		_sprite = Null
	End Method
	
	Method OnSpriteRender:Void(x:Float, y:Float) Abstract
	
	Private
	
	Field _sprite:FlxSprite

End Class

Class RectSpriteRenderer Extends FlxPrimitiveSpriteRenderer

	Method OnSpriteRender:Void(x:Float, y:Float)
		DrawRect(x, y, _sprite.frameWidth, _sprite.frameHeight)
	End Method

End Class

Class OvalSpriteRenderer Extends FlxPrimitiveSpriteRenderer

	Method OnSpriteRender:Void(x:Float, y:Float)
		DrawOval(x, y, _sprite.frameWidth, _sprite.frameHeight)
	End Method

End Class