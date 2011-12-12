
SuperStrict

Framework bah.cairo
Import brl.max2d
Import brl.d3d9max2d
Import brl.freetypefont

SetGraphicsDriver(D3D9Max2DDriver())
Graphics(0, 0)

GenerateMojoFont(24, 22)

Function GenerateMojoFont(size:Int, offset:Int)
	SetImageFont(LoadImageFont("nokiafc22.ttf", size))
	Local w:Int = TextWidth(" ") + offset
	Local h:Int = TextHeight(" ")
	
	Local canvas:TCairo = TCairo.Create(TCairoImageSurface.CreateForPixmap(w * 96, h))
	canvas.SelectFontFace("nokiafc22.ttf", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
	canvas.SetFontSize(size)
	canvas.SetAntialias(CAIRO_ANTIALIAS_DEFAULT)
	canvas.SetSourceRGBA(1, 1, 1, 1)
	canvas.Translate(0, Ceil(h *.8))
	
	For Local i:Int = 32 Until 128
		canvas.MoveTo((i - 32) * w, 0)
		canvas.ShowText(Chr(i))
	Next
	
	canvas.GetTarget().WriteToPNG("flx_system_font_" + size + ".png")
	canvas.GetTarget().Finish()
	canvas.Destroy()
End Function