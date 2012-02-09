Strict

Import mojo
Import flxsprite
Import flxg

Class FlxTileblock Extends FlxSprite

Private
	Field _tilePixels:Image
	
	Field _stamps:Stack<FlxStamp>

Public	
	Method New(x:Int, y:Int, width:Int, height:Int)
		Super.New(x, y)
		MakeGraphic(width, height, 0)
		active = False
		immovable = True
		
		_stamps = New Stack<FlxStamp>()	
	End Method
	
	Method Destroy:Void()
		If (_tilePixels <> Null) Then
			_tilePixels = Null
		End If
		
		If (_stamps.Length() > 0) Then
			Local i:Int = 0
			Local l:Int = _stamps.Length()
			Local stamp:FlxStamp
			
			While (i < l)
				_stamps.Set(i, Null)
				i += 1
			Wend
			
			_stamps.Clear()
		End If
		
		Super.Destroy()
	End Method
	
	Method LoadTiles:FlxTileblock(tileGraphic:String, tileWidth:Int = 0, tileHeight:Int = 0, empties:Int = 0)
		If (tileGraphic.Length() = 0) Return Self
		
		Local sprite:FlxSprite = (New FlxSprite()).LoadGraphic(tileGraphic, True, False, tileWidth, tileHeight)
		Local spriteWidth:Int = sprite.width
		Local spriteHeight:Int = sprite.height
		Local total:Int = sprite.frames + empties
		
		_tilePixels = sprite.Pixels
		
		If (width Mod spriteWidth <> 0) Then
			width = Int(width / spriteWidth + 1) * spriteWidth
		End If
		
		If (height Mod spriteHeight <> 0) Then
			height = Int(height / spriteHeight + 1) * spriteHeight
		End If
		
		If (_tilePixels <> Null) MakeGraphic(width, height, FlxG.WHITE)		
		
		Local row:Int = 0
		Local column:Int
		Local destinationX:Int
		Local destinationY:Int = 0
		Local widthInTiles:Int = width / spriteWidth
		Local heightInTiles:Int = height / spriteHeight
		Local i:Int = 0
		
		_stamps.Clear()
		
		While (row < heightInTiles)
			destinationX = 0
			column = 0
					
			While (column < widthInTiles)			
				If (FlxG.Random() * total > empties) Then
					_stamps.Push(New FlxStamp(destinationX, destinationY, Int(FlxG.Random() * (sprite.frames - 1))))
				End If
				
				destinationX += spriteWidth
				column += 1
			Wend
			
			destinationY += spriteHeight
			row += 1
		Wend
		
		Return Self	
	End Method
	
	Method _DrawSurface:Void(x:Float, y:Float)		
		If (_tilePixels = Null) Return
			
		Local i:Int = 0
		Local l:Int = _stamps.Length()
		Local stamp:FlxStamp		

		While (i < l)
			stamp = _stamps.Get(i)
			DrawImage(_tilePixels, x + stamp.x, y + stamp.y, stamp.frame)
			i += 1
		Wend
	End Method

End Class

Private
Class FlxStamp
	
	Field x:Int
	
	Field y:Int
	
	Field frame:Int
	
	Method New(x:Int, y:Int, frame:Int)
		Self.x = x
		Self.y = y
		Self.frame = frame
	End Method

End Class