
Type TCanvas Extends TListener

	Field gadget:TGadget
	
	Field project:TPreloader
	
	Method Create:TListener(context:TApplication)
		Super.Create(context)

	?Win32
		SetGraphicsDriver(D3D9Max2DDriver())
	?MacOs
		SetGraphicsDriver(GLMax2DDriver())
	?
		gadget = CreateCanvas(0, 0, context.window.ClientWidth(), context.window.ClientHeight(), context.window)
		gadget.SetLayout(EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED)
		
		project = TPreloader(New TPreloader.Create(Self))
		
		CreateTimer(15)
		context.AddListener(Self)
		
		Return Self
	End Method
	
	Method OnEvent(event:Int, src:TGadget)
		Select event
			Case EVENT_TIMERTICK
				project.Update()
				RedrawGadget(gadget)
				
			Case EVENT_GADGETPAINT
				SetGraphics (CanvasGraphics(gadget))
				SetClsColor(127, 127, 127)
				SetViewport(0, 0, gadget.ClientWidth(), gadget.ClientHeight())
				SetBlend(ALPHABLEND)
				
				Cls
				project.Draw()
				Flip
		End Select
	End Method

End Type
