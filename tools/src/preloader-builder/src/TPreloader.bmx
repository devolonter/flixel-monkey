
Type TPreloader Extends TPreloaderObject

	Field properties:TPreloaderProperties

	Method New()
		width = 640
		height = 480
	End Method
	
	Method Create:TPreloaderObject(context:TCanvas)
		Super.Create(context)
		
		properties = TPreloaderProperties(New TPreloaderProperties.Create(context.context))
		properties.Build("Preloader Properties")
		
		Return Self
	End Method
	
	Method Update()
		x = (context.canvas.ClientWidth() - width) *.5
		y = (context.canvas.ClientHeight() - height) *.5
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
