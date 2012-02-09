Strict

Import mojo

Import flxextern
Import flxpoint
Import flxobject
Import flxcamera
Import flxg

Import system.flxanim
Import system.flxcolor

Import "data/flx_default.png"

Class FlxSprite Extends FlxObject

	Global ClassObject:FlxClass = new FlxSpriteClass()
	
	Field origin:FlxPoint
	
	Field offset:FlxPoint
	
	Field scale:FlxPoint
	
	Field blend:Int
	
	Field finished:Bool
	
	Field frameWidth:Int
	
	Field frameHeight:Int
	
	Field frames:Int
	
	Field dirty:Bool
	
	Field _color:FlxColor
	
	Field _mixedColor:FlxColor
	
	Field _camera:FlxCamera
	
Private
	Global _GraphicLoader:FlxGraphicLoader = New FlxGraphicLoader()

	Field _animations:StringMap<FlxAnim>
	
	Field _flipped:Bool
	
	Field _flipNeeded:Bool
	
	Field _curAnim:FlxAnim
	
	Field _curFrame:Int
	
	Field _curIndex:Int
	
	Field _frameTimer:Float
	
	Field _callback:FlxAnimationListener
	
	Field _facing:Int
	
	Field _alpha:Float	
	
	Field _bakedRotation:Float
	
	Field _pixels:Image
	
	Field _matrix:Float[6]
	
	Field _surfaceColor:FlxColor	
	
	Field _halfWidth:Float
	
	Field _halfHeight:Float

Public
	Method New(x:Float = 0, y:Float = 0, simpleGraphic:String = "")
		Super.New(x, y)
		
		offset = New FlxPoint()
		origin = New FlxPoint()
		
		scale = New FlxPoint(1.0, 1.0)
		_alpha = 1
		_color = New FlxColor(FlxG.WHITE)
		blend = AlphaBlend
		
		finished = False
		_facing = RIGHT
		_animations = New StringMap<FlxAnim>
		_flipped = False
		_curAnim = Null
		_curFrame = 0
		_curIndex = 0
		_frameTimer = 0
		
		_callback = Null
		
		_surfaceColor = New FlxColor(FlxG.WHITE)
		_mixedColor = New FlxColor(FlxG.WHITE)
		
		If (simpleGraphic.Length() = 0)
			simpleGraphic = FlxG.DATA_PREFIX + "default"
		End If
		
		LoadGraphic(simpleGraphic)
	End Method
	
	Method Destroy:Void()
		If (_animations <> Null) Then
			_animations.Clear()
			_animations = Null
		End If
		
		offset = Null
		origin = Null
		scale = Null
		_curAnim = Null
		_callback = Null
		_color = Null
		_surfaceColor = Null
		_mixedColor = Null
		_camera = Null
	End Method
	
	Method LoadGraphic:FlxSprite(graphic:String, animated:Bool = False, reverse:Bool = False, width:Int = 0, height:Int = 0, unique:Bool = False)
		_bakedRotation = 0
		
		_GraphicLoader.name = graphic
		_GraphicLoader.animated = animated
		_GraphicLoader.width = width
		_GraphicLoader.height = height
		
		_pixels = FlxG.AddBitmap(graphic, _GraphicLoader, unique)
		
		If (reverse) Then
			_flipped = True
		Else
			_flipped = True
		End if
		
		Self.width = _pixels.Width()
		frameWidth = Self.width
		
		Self.height = _pixels.Height()
		frameHeight = Self.height
		
		_ResetHelpers()
	
		Return Self
	End Method
	
	Method LoadRotatedGraphic:FlxSprite(graphic:String, rotations:Int = 16, frame:Int = -1)
		'TODO
		Return Null
	End Method
	
	Method MakeGraphic:FlxSprite(width:Int, height:Int, color:Int = FlxG.WHITE)
		_pixels = Null
		_bakedRotation = 0
		_surfaceColor.SetARGB(color)
		
		Self.width = width
		frameWidth = width
		Self.height = height
		frameHeight = height
		
		_ResetHelpers()
		
		Return Self
	End Method
	
	Method PostUpdate:Void()
		Super.PostUpdate()
		_UpdateAnimation()
	End Method
		
	Method Draw:Void()
		If (_flickerTimer <> 0) Then
			_flicker = Not _flicker
			If (_flicker) Return
		End If
		
		If (Not OnScreen(FlxG._CurrentCamera)) Return
		
		If (dirty) _CalcFrame()
		
		_camera = FlxG._CurrentCamera		
		
		If (FlxG._LastDrawingBlend <> blend) Then
			SetBlend(blend)
			FlxG._LastDrawingBlend = blend
		End If
		
		_point.x = x - int(_camera.scroll.x * scrollFactor.x) - offset.x
		_point.y = y - int(_camera.scroll.y * scrollFactor.y) - offset.y
		
		If (_point.x > 0) Then
			_point.x += 0.0000001
		Else
			_point.x -= 0.0000001			
		End If
		
		If (_point.y > 0) Then
			_point.y += 0.0000001
		Else
			_point.y -= 0.0000001			
		End If
	
		If (_pixels <> Null) Then
			If (_camera.Color <> FlxG.WHITE) Then
				_mixedColor.MixRGB(_color, _camera._color)
				
				If (FlxG._LastDrawingColor <> _mixedColor.argb) Then
					SetColor(_mixedColor.r, _mixedColor.g, _mixedColor.b)
					FlxG._LastDrawingColor = _mixedColor.argb
				End If				
			Else
				If (FlxG._LastDrawingColor <> _color.argb) Then
					SetColor(_color.r, _color.g, _color.b)
					FlxG._LastDrawingColor = _color.argb
				End If		
			End If
			
			If (_camera.Alpha < 1) Then
				Local _mixedAlpha:Float = _camera.Alpha * _alpha
				
				If (FlxG._LastDrawingAlpha <> _mixedAlpha) Then
					SetAlpha(_mixedAlpha)
					FlxG._LastDrawingAlpha = _mixedAlpha					
				End If
			Else
				If (FlxG._LastDrawingAlpha <> _alpha) Then
					SetAlpha(_alpha)
					FlxG._LastDrawingAlpha = _alpha					
				End If
			End If
			
			If ((angle = 0 Or _bakedRotation > 0) And scale.x = 1 And scale.y = 1) Then
				If (Not _flipNeeded) Then
					DrawImage(_pixels, _point.x, _point.y, _curIndex)					
				Else
					PushMatrix()						
						Transform(-1, 0, 0, 1, _point.x + _halfWidth, _point.y + _halfHeight)						
						DrawImage(_pixels, -_halfWidth, -_halfHeight, _curIndex)
					PopMatrix()									
				End If		
			Else							
				PushMatrix()
					'Translate
					_matrix[4] = _point.x + origin.x
					_matrix[5] = _point.y + origin.y
					
					'Scale
					_matrix[0] = scale.x
					_matrix[3] = scale.y
					
					'Rotate
					If (angle <> 0 And _bakedRotation = 0) Then						
						Local sin:Float = -Sin(angle)
						Local cos:Float = Cos(angle)
					
						_matrix[1] = -sin * _matrix[3]
						_matrix[2] = _matrix[0] * sin										
						_matrix[0] *= cos						
						_matrix[3] = cos * _matrix[3]
					End If	
									
					Transform(_matrix[0], _matrix[1], _matrix[2], _matrix[3], _matrix[4], _matrix[5])
					
					If (_flipNeeded) Then						
						Transform(-1, 0, 0, 1, _halfWidth - origin.x, _halfHeight - origin.y)
					End If
											
					DrawImage(_pixels, -origin.x, -origin.y, _curIndex)
				PopMatrix()				
			End If
		Else		
			If (_camera.Color <> FlxG.WHITE) Then
				_mixedColor.MixRGB(_surfaceColor, _camera._color)
				
				If (_color.argb <> FlxG.WHITE) Then
					_mixedColor.MixRGB(_color)					
				End If
				
				If (FlxG._LastDrawingColor <> _mixedColor.argb) Then
					SetColor(_mixedColor.r, _mixedColor.g, _mixedColor.b)
					FlxG._LastDrawingColor = _mixedColor.argb
				End If
			Else
				If (_color.argb <> FlxG.WHITE) Then
					_mixedColor.MixRGB(_surfaceColor, _color)
					
					If (FlxG._LastDrawingColor <> _mixedColor.argb) Then
						SetColor(_mixedColor.r, _mixedColor.g, _mixedColor.b)
						FlxG._LastDrawingColor = _mixedColor.argb
					End If
				Else
					If (FlxG._LastDrawingColor <> _surfaceColor.argb) Then
						SetColor(_surfaceColor.r, _surfaceColor.g, _surfaceColor.b)
						FlxG._LastDrawingColor = _surfaceColor.argb
					End If						
				End If			
			End If
			
			If (_camera.Alpha < 1) Then
				Local _mixedAlpha:Float = _camera.Alpha * _alpha
				
				If (_surfaceColor.a < 1) Then
					_mixedAlpha *= _surfaceColor.a				
				End If
				
				If (FlxG._LastDrawingAlpha <> _mixedAlpha) Then
					SetAlpha(_mixedAlpha)
					FlxG._LastDrawingAlpha = _mixedAlpha					
				End If
			Else
				If (_surfaceColor.a < 1) Then
					Local _mixedAlpha:Float = _surfaceColor.a * _alpha
					
					If (FlxG._LastDrawingAlpha <> _mixedAlpha) Then
						SetAlpha(_mixedAlpha)
						FlxG._LastDrawingAlpha = _mixedAlpha	
					End If
				Else
					If (FlxG._LastDrawingAlpha <> _alpha) Then
						SetAlpha(_alpha)
						FlxG._LastDrawingAlpha = _alpha		
					End If	
				End If				
			End If
		
			If ((angle = 0 Or _bakedRotation > 0) And scale.x = 1 And scale.y = 1) Then
				_DrawSurface(_point.x, _point.y)
			Else
				PushMatrix()
					'Translate
					_matrix[4] = _point.x + origin.x
					_matrix[5] = _point.y + origin.y
					
					'Scale
					_matrix[0] = scale.x
					_matrix[3] = scale.y
					
					'Rotate
					If (angle <> 0 And _bakedRotation = 0) Then						
						Local sin:Float = -Sin(angle)
						Local cos:Float = Cos(angle)
					
						_matrix[1] = -sin * _matrix[3]
						_matrix[2] = _matrix[0] * sin										
						_matrix[0] *= cos						
						_matrix[3] = cos * _matrix[3]
					End If			
									
					Transform(_matrix[0], _matrix[1], _matrix[2], _matrix[3], _matrix[4], _matrix[5])					
					_DrawSurface(-origin.x, -origin.y)
				PopMatrix()
			End If		
		End If
		
		_VisibleCount += 1;
		If(FlxG.VisualDebug And Not ignoreDrawDebug) DrawDebug(_camera);
	End Method
	
	Method DrawFrame:Void(force:Bool = False)
		If (force Or dirty) _CalcFrame()
	End Method
	
	Method AddAnimation:Void(name:String, frames:Int[], frameRate:Float = 0, looped:Bool = True)
		_animations.Set(name, New FlxAnim(name, frames, frameRate, looped))
	End Method
	
	Method AddAnimationCallback:Void(animationCallback:FlxAnimationCallback)
		_callback = animationCallback
	End Method
	
	Method Play:Void(animName:String, force:Bool = False)
		If (Not force And _curAnim <> Null And animName = _curAnim.name And( _curAnim.looped Or Not finished )) Return
		
		_curFrame = 0
		_curIndex = 0
		_frameTimer = 0
		
		Local anim:FlxAnim = _animations.Get(animName)
		
		If (anim <> Null) Then
			_curAnim = anim
			
			If (_curAnim.delay <= 0) Then
				finished = True
			Else
				finished = False				
			End If
			
			_curIndex = _curAnim.frames[_curFrame]
			dirty = True
			Return
		End If
		
		FlxG.Log("WARNING: No animation called ~q" + animName + "~q")
	End Method
	
	Method RandomFrame:Void()
		_curAnim = Null
		
		If (_pixels <> Null) Then			
			_curIndex = Int(FlxG.Random() * (_pixels.Frames() - 1))
		Else
			_curIndex = 0
		End If
		
		dirty = True		
	End Method
	
	Method SetOriginToCorner:Void()
		origin.x = 0
		origin.y = 0
	End Method
	
	Method CenterOffsets:Void(adjustPosition:Bool = False)
		offset.x = (frameWidth - width) * .5
		offset.y = (frameHeight - height) * .5
		
		If (adjustPosition) Then
			x += offset.x
			y += offset.y
		End If
	End Method
	
	Method Pixels:Image() Property
		Return _pixels
	End Method
	
	Method Pixels:Void(pixels:Image) Property
		_pixels = pixels
		
		If (_pixels <> Null) Then
			width = pixels.Width()
			height = pixels.Height()	
		Else
			width = 0
			height = 0		
		End If
		
		frameWidth = width
		frameHeight = height
		_ResetHelpers()
	End Method
	
	Method Facing:Int() Property
		Return _facing	
	End Method
	
	Method Facing:Void(direction:Int) Property
		If (_facing <> direction) dirty = True
		_facing = direction

		_flipNeeded = (_flipped And _facing = LEFT)
	End Method
	
	Method Alpha:Float() Property
		Return _alpha	
	End Method
	
	Method Alpha:Void(alpha:Float) Property
		If (alpha < 0) alpha = 0		
		_alpha = alpha 
	End Method
	
	Method Color:Int() Property
		Return _color.argb	
	End Method
	
	Method Color:Void(color:Int) Property
		_color.SetRGB(color)
	End Method
	
	Method Frame:Int() Property
		Return _curIndex
	End Method
	
	Method Frame:Void(frame:Int) Property
		_curAnim = Null
		_curIndex = frame
		dirty = True
	End Method	
	
	Method OnScreen:Bool(camera:FlxCamera)
		If (camera = Null) camera = FlxG.Camera	
		GetScreenXY(_point, camera)
		
		_point.x = _point.x - offset.x
		_point.y = _point.y - offset.y
		
		If ((angle = 0 Or _bakedRotation > 0) And scale.x = 1 And scale.y = 1) Then
			Return _point.x + frameWidth > 0 And _point.x < camera.Width And _point.y + frameHeight > 0 And _point.y < camera.Height
		End If
		
		Local radius:Float = Sqrt(_halfWidth * _halfWidth + _halfHeight * _halfHeight) * Max(Abs(scale.x), Abs(scale.y))
		_point.x += _halfWidth
		_point.y += _halfHeight
		
		Return _point.x + radius > 0 And _point.x - radius < camera.Width And _point.y + radius > 0 And _point.y - radius < camera.Height
	End Method
	
	Method _DrawSurface:Void(x:Float, y:Float)
		DrawRect(x, y, frameWidth, frameHeight)
	End Method
	
	Method _ResetHelpers:Void()
		_halfWidth = frameWidth * .5
		_halfHeight = frameHeight * .5
		origin.Make(_halfWidth, _halfHeight)
		
		If (_pixels <> Null) Then
			frames = _pixels.Frames()
		Else
			frames = 1		 
		End If
		
		_curIndex = 0
		_mixedColor.SetARGB(FlxG.WHITE)
	End Method
	
	Method ToString:String()
		Return "FlxSprite"	
	End Method

Private	
	Method _UpdateAnimation:Void()
		If (_bakedRotation > 0) Then
			Local oldIndex:Int = _curIndex
			Local angleHelper:Int = angle Mod 360
			
			If (angleHelper < 0) angleHelper += 360
			_curIndex = angleHelper / _bakedRotation + 0.5
			
			If (oldIndex <> _curIndex) dirty = True
		
		ElseIf (_curAnim <> Null And _curAnim.delay > 0 And (_curAnim.looped Or Not finished))
			_frameTimer += FlxG.Elapsed
			While (_frameTimer > _curAnim.delay)
				_frameTimer -= _curAnim.delay
				
				If (_curFrame = _curAnim.frames.Length() - 1) Then
					If (_curAnim.looped) _curFrame = 0
					finished = True
				Else
					_curFrame += 1
				End If
				
				_curIndex = _curAnim.frames[_curFrame]
				dirty = True
			Wend			
		End If
		
		If (dirty) _CalcFrame()
	End Method
	
	Method _CalcFrame:Void()	
		If (_callback <> Null) Then
			If (_curAnim <> Null) Then
				_callback.OnAnimationFrame(_curAnim.name, _curFrame, _curIndex)
			Else
				_callback.OnAnimationFrame("", _curFrame, _curIndex)
			End If
		End If
		dirty = False
	End Method
	
End Class

Private
Class FlxSpriteClass Implements FlxClass

	Method CreateInstance:Object()
		Return New FlxSprite()
	End Method
	
	Method InstanceOf:Bool(object:Object)			
		Return (FlxSprite(object) <> Null)
	End Method	
	
End Class

Class FlxGraphicLoader Extends FlxResourceLoader<Image>

	Field name:String
	Field animated:Bool
	Field width:Float
	Field height:Float

	Method Load:Image(name:String)
		Local image:Image = LoadImage(FlxAssetsManager.GetImagePath(Self.name))
		
		If (Not animated) Then
			Return image
		Else
			Local frames:Int
			
			If (width = 0 And height = 0) Then
				width = image.Height()			
			ElseIf (width = 0) Then
				width = height			
			ElseIf (height = 0) Then
				height = width
			End If
			
			If (height = 0) Then
				frames = Ceil(image.Width() / width)
				height = width
			Else
				frames = Ceil((image.Width() * image.Height()) / (width * height))
			End If
			
			Return image.GrabImage(0, 0, width, height, frames)
		End If		
	End Method

End Class