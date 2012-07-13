
Type TPreloaderProgBar Extends TPreloaderObject

	Method New()
		width = 200
		height = 15
	End Method

	Method Draw()
		SetColor(color.r, color.g, color.b)
		DrawRect(x, y, width, height)
		SetColor(255, 255, 255)
	End Method

End Type
