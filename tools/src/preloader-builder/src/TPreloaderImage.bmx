
Type TPreloaderImage Extends TPreloaderObject

	Field filename:String

	Field src:TImage
	
	Field fromAlpha:Int, toAlpha:Int
	
	Field blendMode:Int
	
	Method New()
		fromAlpha = 100
		toAlpha = 100
		blendMode = ALPHABLEND
	End Method
	
	Method Destroy()
		Super.Destroy()
		src = Null
	End Method
	
	Method SetImage(image:TImage)
		src = image
		width = src.width
		height = src.height
	End Method
	
	Method Draw()
		If (fromAlpha <> 100) SetAlpha(fromAlpha / 100.0)
		If (blendMode <> ALPHABLEND) SetBlend(blendMode)
		DrawImage(src, x, y)
		If (fromAlpha <> 100) SetAlpha(1)
		If (blendMode <> ALPHABLEND) SetBlend(ALPHABLEND)
	End Method

End Type
