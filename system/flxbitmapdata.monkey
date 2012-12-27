Strict

Import mojo.graphics
Import flixel.flxpoint
Import flixel.flxrect
Import flixel.system.flxcolor

Class FlxBitmapData

Private
	Global _ZeroPoint:FlxPoint = New FlxPoint()

	Field _width:Int
	
	Field _height:Int

	Field _scroll:FlxPoint
	
	Field _storePixels:Bool

	Field _image:Image
	
	Field _color:FlxColor
	
	Field _rect:FlxRect
	
	Field _pixels:Int[]
	
Public
	Method New(width:Int, height:Int, storePixels:Bool = False, fillColor:Int = $00000000)
		_image = CreateImage(width, height)
		_color = New FlxColor(fillColor)
		_rect = New FlxRect()
		
		_width = width
		_height = height
		_scroll = New FlxPoint(0, 0)
		_storePixels = storePixels
		
		If (_storePixels) _pixels = New Int[_width * _height]
		
		If (_color.a > 0) Then
			If ( Not _storePixels) _pixels = New Int[_width * _height]
			_WritePixels(0, 0, _width, _height, fillColor)
		End If
	End Method
	
	Method Destroy:Void(discard:Bool = False)
		_pixels =[]
		_color = Null
		_rect = Null
		_scroll = Null
		If (discard) _image.Discard()
	End Method
	
	Method CopyPixels:Void(sourceBitmapData:FlxBitmapData, sourceRect:FlxRect = Null, destPoint:FlxPoint = Null)
		If (sourceRect = Null) sourceRect = New FlxRect(0, 0, Min(_width - Int(_scroll.x), sourceBitmapData._width), Min(_height - Int(_scroll.y), sourceBitmapData._height))
		If (destPoint = Null) destPoint = _ZeroPoint
		
		If (sourceBitmapData._storePixels) Then
			SetPixels(_rect.Make(destPoint.x, destPoint.y, sourceRect.width, sourceRect.height), sourceBitmapData.GetPixels(sourceRect))
		Else
			Cls()
			DrawImage(sourceBitmapData._image, 0, 0)
			_GrabPixels(sourceRect.x, sourceRect.y, sourceRect.width, sourceRect.height, destPoint.x, destPoint.y)
			Cls()
		End If
	End Method
	
	#Rem
	Method CopyPixels:Void(sourceImage:Image, sourceRect:FlxRect = Null, destPoint:FlxPoint = Null)
		If (sourceRect = Null) sourceRect = New FlxRect(0, 0, Min(_width, sourceImage.Width()), Min(_height, sourceImage.Height()))
		If (destPoint = Null) destPoint = _ZeroPoint
		Local result:Int[]
		
		
		If ( Not _storePixels) Then
			_CheckPixelsArray(sourceRect.width, sourceRect.height)
			result = _pixels
		Else
			
		End If
	
		Cls()
			DrawImage(sourceImage, 0, 0)
			SetPixels(_rect.Make(destPoint.x, destPoint.y, sourceRect.width, sourceRect.height), ReadPixels())
		Cls()
		
	End Method
	#End
	
	Method Dispose:Void()
		_pixels =[]
		_storePixels = False
	End Method
	
	Method FillRect:Void(rect:FlxRect, color:Int)
		_WritePixels(rect.x, rect.y, rect.width, rect.height, color)
	End Method
	
	Method FloodFill:Void(x:Int, y:Int, color:Int)
		FillRect(_rect.Make(x, y, _width - x, _height - y), color)
	End Method

	Method GetPixel:Int(x:Float, y:Float)
		If (_storePixels) Then
			Return _pixels[x + y * _width]
		End If
	
		Return 0
	End Method
	
	Method GetPixels:Int[] (rect:FlxRect)
		Local result:Int[] = New Int[rect.width * rect.height]
		
		If (_storePixels) Then
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
		Return _image
	End Method
	
Private
	Method _CheckPixelsArray:Void(width:Int, height:Int)
		If (_pixels.Length() < width * height) Then
			_pixels = _pixels.Resize(width * height)
		End If
	End Method
	
	Method _GrabPixels:Void(x:Int, y:Int, width:Int, height:Int, destX:Int, destY:Int)
		destX += _scroll.x
		destY += _scroll.y
		
		Local offset:Int = destX + destY * width
		
		If ( Not _storePixels) Then
			_CheckPixelsArray(width, height)
			ReadPixels(_pixels, x, y, width, height)
			_image.WritePixels(_pixels, destX, destY, width, height)
		Else
			ReadPixels(_pixels, x, y, width, height, offset, _width)
			_image.WritePixels(_pixels, destX, destY, width, height, offset, _width)
		End If
	End Method
	
	Method _WritePixels:Void(x:Int, y:Int, width:Int, height:Int, color:Int)
		x += _scroll.x
		y += _scroll.y
	
		Local offset:Int = x + y * width
	
		If ( Not _storePixels) Then
			Local i:Int = offset, l:Int = offset + width * height
			_CheckPixelsArray(width, height)
			
			While (i < l)
				_pixels[i] = color
				i += 1
			Wend
			
			_image.WritePixels(_pixels, x, y, width, height)
		Else
			Local i:Int, j:Int, k:Int = offset
		
			For i = 0 Until height
				For j = 0 Until width
					_pixels[k] = color
					k += 1
				Next
				k += _width - width
			Next
			
			_image.WritePixels(_pixels, x, y, width, height, offset, _width)
		End If
	End Method
	
	Method _WritePixels:Void(x:Int, y:Int, width:Int, height:Int, pixels:Int[])
		x += _scroll.x
		y += _scroll.y
	
		If ( Not _storePixels) Then
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
	End Method

End Class