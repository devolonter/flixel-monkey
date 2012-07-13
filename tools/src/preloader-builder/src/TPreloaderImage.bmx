
Type TPreloaderImage Extends TPreloaderObject

	Field src:TImage
	
	Method SetImage(image:TImage)
		src = image
		width = src.width
		height = src.height
	End Method

End Type
