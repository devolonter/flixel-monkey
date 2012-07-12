
Type TCanvas Extends TListener

	Field canvas:TGadget
	
	Field project:TPreloader
	
	Method Create:TListener(context:TApplication)
		Super.Create(context)

	?Win32
		SetGraphicsDriver(D3D9Max2DDriver())
	?MacOs
		SetGraphicsDriver(GLMax2DDriver())
	?
		canvas = CreateCanvas(0, context.propertiesBar.ClientHeight(), context.window.ClientWidth(), context.window.ClientHeight(), context.window)
		canvas.SetLayout(EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED)
		
		project = TPreloader(New TPreloader.Create(Self))
		
		CreateTimer(15)
		context.AddListener(Self)
		
		Return Self
	End Method
	
	Method OnEvent(event:Int, src:TGadget)
		Select event
			Case EVENT_TIMERTICK
				project.Update()
				RedrawGadget(canvas)
				
			Case EVENT_GADGETPAINT
				SetGraphics (CanvasGraphics(canvas))
				SetClsColor(127, 127, 127)
				SetViewport(0, 0, canvas.ClientWidth(), canvas.ClientHeight())
				SetBlend(ALPHABLEND)
				
				Cls
				project.Draw()
				Flip
		End Select
	End Method

End Type
