Strict

Import mojo.graphics
Import flixel.flxpoint
Import flixel.flxrect
Import flixel.system.flxcolor

Class FlxBitmapData

Private
	Field _width:Int
	
	Field _height:Int

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
		_storePixels = storePixels
		
		If (_storePixels) _pixels = New Int[_width * _height]
		
		If (_color.a > 0) Then
			If ( Not _storePixels) _pixels = New Int[_width * _height]
			_FillPixels(0, 0, _width, _height, fillColor)
			
			_image.WritePixels(_pixels, 0, 0, _width, _height)
		End If
	End Method
	
	Method Destroy:Void()
		_pixels = Null
		_color = Null
		_rect = Null
		_image.Discard()
	End Method
	
	Method CopyPixels:Void()
		'TODO!
	End Method
	
	Method Dispose:Void()
		_pixels = New Int[0]
		_storePixels = False
	End Method
	
	Method FillRect:Void(rect:FlxRect, color:Int)
		If ( Not _storePixels) Then
			_FillPixels(0, 0, rect.width, rect.height, color)
			_image.WritePixels(_pixels, rect.x, rect.y, rect.width, rect.height)
		Else
			_FillPixels(rect.x, rect.y, rect.width, rect.height, color)
			_image.WritePixels(_pixels, rect.x, rect.y, rect.width, rect.height, rect.x + rect.y * rect.width, _width)
		End If
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
			Local i:Int, j:Int, m:Int, k:Int = rect.x + rect.y * rect.width
		
			For i = 0 Until rect.height
				For j = 0 Until rect.width
					result[m] = _pixels[k]					
					k += 1
					m += 1
				Next
				k += _width - rect.width
			Next
		End If
		
		Return result
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
	
	Method _FillPixels:Void(x:Int, y:Int, width:Int, height:Int, color:Int)
		Local offset:Int = x + y * width
	
		If ( Not _storePixels) Then
			Local i:Int = offset, l:Int = offset + width * height
			_CheckPixelsArray(width, height)
			
			While (i < l)
				_pixels[i] = color
				i += 1
			Wend
		Else
			Local i:Int, j:Int, k:Int = offset
		
			For i = 0 Until height
				For j = 0 Until width
					_pixels[k] = color
					k += 1
				Next
				k += _width - width
			Next
		End If
	End Method

End Class