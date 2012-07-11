
Type TPreloader Extends TPreloaderObject

	Method New()
		width = 640
		height = 480
	End Method
	
	Method Update()
		x = (context.gadget.ClientWidth() - width) *.5
		y = (context.gadget.ClientHeight() - height) *.5
	End Method
	
	Method Draw()
		SetAlpha(.2)
		SetColor(0, 0, 0)
		DrawRect(x + width *.005, y + height *.005, width, height)
		
		SetAlpha(1)
		SetColor(color.r, color.g, color.b)
		DrawRect(x, y, width, height)
		
		SetColor(255, 255, 255)		
	End Method

End Type
