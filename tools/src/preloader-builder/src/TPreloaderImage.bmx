
Type TPreloaderImage Extends TPreloaderObject

	Field src:TImage
	
	Field fromAlpha:Int, toAlpha:Int
	
	Method New()
		fromAlpha = 100
		toAlpha = 100
	End Method
	
	Method SetImage(image:TImage)
		src = image
		width = src.width
		height = src.height
	End Method
	
	Method Draw()
		If (fromAlpha <> 100) SetAlpha(fromAlpha / 100.0)
		DrawImage(src, x, y)
		If (fromAlpha <> 100) SetAlpha(1)
	End Method

End Type
