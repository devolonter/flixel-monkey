Strict

Import mojo.graphics
Import flixel.flxpoint
Import flixel.flxrect
Import flixel.system.flxcolor

Class FlxImageData

Private
	Global _ZeroPoint:FlxPoint = New FlxPoint()

	Field _width:Int
	
	Field _height:Int

	Field _scroll:FlxPoint
	
	Field _padding:FlxPoint
	
	Field _withPixelsArray:Bool

	Field _image:Image
	
	Field _sourceImage:Image
	
	Field _destImage:Image
	
	Field _color:FlxColor
	
	Field _rect:FlxRect
	
	Field _pixels:Int[]
	
	Field _dirty:Bool
	
Public
	Method New(width:Int, height:Int, withPixelsArray:Bool = False, fillColor:Int = $00000000)
		_image = CreateImage(width, height)
		_color = New FlxColor(fillColor)
		_rect = New FlxRect()
		
		_width = width
		_height = height
		_scroll = New FlxPoint()
		_padding = New FlxPoint()
		_withPixelsArray = withPixelsArray
		_dirty = False
		
		If (_withPixelsArray) _pixels = New Int[_width * _height]
		
		If (_color.a > 0) Then
			If ( Not _withPixelsArray) _pixels = New Int[_width * _height]
			_WritePixels(0, 0, _width, _height, fillColor)
		End If
	End Method
	
	Method Destroy:Void(discard:Bool = False)
		_pixels =[]
		_color = Null
		_rect = Null
		_scroll = Null
		_padding = Null
		
		If (discard) _image.Discard()
		If (_sourceImage <> Null) _sourceImage.Discard()
		
		_image = Null
		_sourceImage = Null
		_destImage = Null
	End Method
	
	Method CopyPixels:Void(sourceBitmapData:FlxImageData, sourceRect:FlxRect = Null, destPoint:FlxPoint = Null)
		If (sourceRect = Null) sourceRect = New FlxRect(0, 0, Min(_width - Int(_scroll.x), sourceBitmapData._width), Min(_height - Int(_scroll.y), sourceBitmapData._height))
		If (destPoint = Null) destPoint = _ZeroPoint
		
		If (sourceBitmapData._withPixelsArray) Then
			SetPixels(_rect.Make(destPoint.x, destPoint.y, sourceRect.width, sourceRect.height), sourceBitmapData.GetPixels(sourceRect))
		Else
			Cls
			DrawImage(sourceBitmapData._image, 0, 0)
			_GrabPixels(sourceRect.x, sourceRect.y, sourceRect.width, sourceRect.height, destPoint.x, destPoint.y)
			Cls
		End If
	End Method
	
	Method CopyPixels:Void(sourceImage:Image, sourceRect:FlxRect = Null, destPoint:FlxPoint = Null)
		If (sourceRect = Null) Then
			If (sourceImage.Frames() = 1) Then
				sourceRect = _rect.Make(0, 0, Min(_width - Int(_scroll.x), sourceImage.Width()), Min(_height - Int(_scroll.y), sourceImage.Height()))
			Else
				sourceRect = _rect.Make(0, 0, _width - Int(_scroll.x), _height - Int(_scroll.y))
			 End If
		End If
		
		If (destPoint = Null) destPoint = _ZeroPoint
		
		Cls
		_DrawAsSpriteSheet(sourceImage, _padding.x, _padding.y, True)
		_GrabPixels(sourceRect.x, sourceRect.y, sourceRect.width, sourceRect.height, destPoint.x, destPoint.y)
		Cls
	End Method
	
	Method CopyPixels:Void(sourceRect:FlxRect = Null, destPoint:FlxPoint = Null)
		If (sourceRect = Null) sourceRect = _rect.Make(0, 0, Min(_width - Int(_scroll.x), DeviceWidth()), Min(_height - Int(_scroll.y), DeviceHeight()))
		If (destPoint = Null) destPoint = _ZeroPoint
		
		_GrabPixels(sourceRect.x, sourceRect.y, sourceRect.width, sourceRect.height, destPoint.x, destPoint.y)
	End Method
	
	Method ColorReplace:Void(color:Int, byColor:Int)
		If ( Not _withPixelsArray)
			_ReadPixels(0, 0, _width, _height)
		End If
		
		Local i:Int = 0, l:Int = _pixels.Length()
		
		While (i < l)
			If (_pixels[i] = color) _pixels[i] = byColor
			i += 1
		Wend
		
		_WritePixels(0, 0, _width, _height, _pixels)
	End Method
	
	Method Dispose:Void()
		_pixels =[]
		_withPixelsArray = False
		If (_sourceImage <> Null) _sourceImage.Discard()
	End Method
	
	Method FillRect:Void(rect:FlxRect, color:Int)
		_WritePixels(rect.x, rect.y, rect.width, rect.height, color)
	End Method
	
	Method FloodFill:Void(x:Int, y:Int, color:Int)
		FillRect(_rect.Make(x, y, _width - x, _height - y), color)
	End Method

	Method GetPixel:Int(x:Float, y:Float)
		If ( Not _withPixelsArray) Then
			_ReadPixels(x, y, 1, 1)
			Return _pixels[0]
		Else
			Return _pixels[x + y * _width]
		End If
	End Method
	
	Method GetPixels:Int[] (rect:FlxRect)
		Local result:Int[] = New Int[rect.width * rect.height]
		
		If ( Not _withPixelsArray) Then
			Local i:Int = 0, l:Int = result.Length()
			_ReadPixels(rect.x, rect.y, rect.width, rect.height)
			
			While (i < l)
				result[i] = _pixels[i]
				i += 1
			Wend
		Else
			Local i:Int, j:Int, k:Int = rect.x + rect.y * _width, index:Int
		
			For i = 0 Until rect.height
				For j = 0 Until rect.width
					result[index] = _pixels[k]
					k += 1
					index += 1
				Next
				k += _width - rect.width
			Next
		End If
		
		Return result
	End Method
	
	Method Scroll:Void(x:Int, y:Int)
		_scroll.Make(x, y)
	End Method
	
	Method SetPixel:Void(x:Int, y:Float, color:Int)
		FillRect(_rect.Make(x, y, 1, 1), color)
	End Method
	
	Method SetPixels:Void(rect:FlxRect, pixels:Int[])
		_WritePixels(rect.x, rect.y, rect.width, rect.height, pixels)
	End Method
	
	Method Width:Int() Property
		Return _width
	End Method
	
	Method Height:Int() Property
		Return _height
	End Method
	
	Method Image:Image() Property
		If (_sourceImage <> Null) Then
			If ( Not _dirty) Return _destImage
		
			Local flags:Int
			
			If (_padding.x = 1) flags |= graphics.Image.XPadding
			If (_padding.y = 1) flags |= graphics.Image.YPadding
			
			_destImage = _image.GrabImage(0, 0, _sourceImage.Width() +_padding.x * 2, _sourceImage.Height() +_padding.y * 2, _sourceImage.Frames(), flags)
			_destImage.SetHandle(_sourceImage.HandleX(), _sourceImage.HandleY())
			_dirty = False
			
			Return _destImage
		End If
		
		Return _image
	End Method
	
	Function FromImage:FlxImageData(image:Image, withPixelsArray:Bool, paddingX:Int, paddingY:Int)
		Return _FromImage(image, withPixelsArray, paddingX, paddingY)
	End Function
	
	Function FromImage:FlxImageData(image:Image, withPixelsArray:Bool, paddings:Int)
		Local paddingX:Int, paddingY:Int

		If (paddings & graphics.Image.XPadding) paddingX = 1
		If (paddings & graphics.Image.YPadding) paddingY = 1
	
		Return _FromImage(image, withPixelsArray, paddingX, paddingY)
	End Function
	
	Function FromImage:FlxImageData(image:Image, withPixelsArray:Bool = False)
		Local paddingX:Int, paddingY:Int
		
		If (image.Flags() & graphics.Image.XPadding) paddingX = 1
		If (image.Flags() & graphics.Image.YPadding) paddingY = 1
	
		Return _FromImage(image, withPixelsArray, paddingX, paddingY)
	End Function
	
Private
	Function _FromImage:FlxImageData(image:Image, withPixelsArray:Bool, paddingX:Int, paddingY:Int)
		Local rows:Int = Sqrt(image.Frames()), cols:Int = image.Frames() / rows
		
		Local bitmapData:FlxImageData = New FlxImageData(cols * (image.Width() +paddingX * 2), rows * (image.Height() +paddingY * 2), withPixelsArray)
		
		bitmapData._padding.x = paddingX
		bitmapData._padding.y = paddingY
		
		bitmapData.CopyPixels(image)
		bitmapData._sourceImage = image

		Return bitmapData
	End Function

	Method _DrawAsSpriteSheet:Void(image:Image, paddingX:Int = 0, paddingY:Int = 0, fillPaddings:Bool = False)
		Local x:Float = paddingX, y:Float = paddingY
		Local w:Int = image.Width(), h:Int = image.Height()
		Local hx:Int = image.HandleX(), hy:Int = image.HandleY()
		Local i:Int = 0, l:Int = image.Frames()
		
		image.SetHandle(0, 0)
		
		While (i < l)
			If (paddingX > 0 And fillPaddings) DrawImageRect(image, x - paddingX, y, 0, 0, paddingX, h, i)
			
			If (paddingY > 0 And fillPaddings) Then
				DrawImageRect(image, x - paddingX, y - paddingY, 0, 0, paddingX, paddingY, i)
				DrawImageRect(image, x, y - paddingY, 0, 0, w, paddingY, i)
				DrawImageRect(image, x + w, y - paddingY, w - paddingX, 0, paddingX, paddingY, i)
			End If
			
			DrawImage(image, x, y, i)
			
			If (paddingX > 0 And fillPaddings) DrawImageRect(image, x + w, y, w - paddingX, 0, paddingX, h, i)
			
			If (paddingY > 0 And fillPaddings) Then
				DrawImageRect(image, x - paddingX, y + h, 0, h - paddingY, paddingX, paddingY, i)
				DrawImageRect(image, x, y + h, 0, h - paddingY, w, paddingY, i)
				DrawImageRect(image, x + w, y + h, w - paddingX, h - paddingY, paddingX, paddingY, i)
			End If
			
			x += w + paddingX * 2
			
			If (x + w + paddingX * 2 > _width + paddingX) Then
				x = paddingX
				y += h + paddingY * 2
				
				If (y + h + paddingY * 2 > _height + paddingY) Then
					Exit
				End If
			End If
			
			i += 1
		Wend
		
		image.SetHandle(hx, hy)
	End Method

	Method _CheckPixelsArray:Void(width:Int, height:Int)
		If (_pixels.Length() < width * height) Then
			_pixels = _pixels.Resize(width * height)
		End If
	End Method
	
	Method _ReadPixels:Void(x:Int, y:Int, width:Int, height:Int)
		x += _scroll.x
		y += _scroll.y
	
		If ( Not _withPixelsArray) Then
			_CheckPixelsArray(width, height)
			ReadPixels(_pixels, x, y, width, height)
		Else
			Local offset:Int = x + y * width
			ReadPixels(_pixels, x, y, width, height, offset, _width)
		End If
	End Method
	
	Method _GrabPixels:Void(x:Int, y:Int, width:Int, height:Int, destX:Int, destY:Int)
		destX += _scroll.x
		destY += _scroll.y
	
		If ( Not _withPixelsArray) Then
			_CheckPixelsArray(width, height)
			ReadPixels(_pixels, x, y, width, height)
			_image.WritePixels(_pixels, destX, destY, width, height)
		Else
			Local offset:Int = destX + destY * width
		
			ReadPixels(_pixels, x, y, width, height, offset, _width)
			_image.WritePixels(_pixels, destX, destY, width, height, offset, _width)
		End If
		
		_Invalidate()
	End Method
	
	Method _WritePixels:Void(x:Int, y:Int, width:Int, height:Int, color:Int)
		x += _scroll.x
		y += _scroll.y
	
		If ( Not _withPixelsArray) Then
			Local i:Int = 0, l:Int = width * height
			_CheckPixelsArray(width, height)
			
			While (i < l)
				_pixels[i] = color
				i += 1
			Wend
			
			_image.WritePixels(_pixels, x, y, width, height)
		Else
			Local i:Int, j:Int, k:Int = x + y * width
		
			For i = 0 Until height
				For j = 0 Until width
					_pixels[k] = color
					k += 1
				Next
				k += _width - width
			Next
			
			_image.WritePixels(_pixels, x, y, width, height, x + y * width, _width)
		End If
		
		_Invalidate()
	End Method
	
	Method _WritePixels:Void(x:Int, y:Int, width:Int, height:Int, pixels:Int[])
		x += _scroll.x
		y += _scroll.y
	
		If ( Not _withPixelsArray) Then
			_image.WritePixels(pixels, x, y, width, height)
		Else
			Local offset:Int = x + y * width
			Local i:Int, j:Int, index:Int, k:Int = offset
			
			For i = 0 Until height
				For j = 0 Until width
					_pixels[k] = pixels[index]
					k += 1
					index += 1
				Next
				k += _width - width
			Next
			
			_image.WritePixels(_pixels, x, y, width, height, offset, _width)
		End If
		
		_Invalidate()
	End Method
	
	Method _Invalidate:Void()
		_destImage = Null
		_dirty = True
	End Method

End Class