
Type TCanvas Extends TListener

	Field canvas:TGadget
	
	Field preloader:TPreloader
	
	Method Create:TListener(context:TApplication)
		Super.Create(context)

	?Win32
		SetGraphicsDriver(D3D9Max2DDriver())
	?MacOs
		SetGraphicsDriver(GLMax2DDriver())
	?
		canvas = CreateCanvas(0, context.propertiesBar.ClientHeight(), context.window.ClientWidth(), context.window.ClientHeight(), context.window)
		canvas.SetLayout(EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED)
		
		preloader = TPreloader(New TPreloader.Create(Self))
		
		CreateTimer(15)
		context.AddListener(Self)
		
		Return Self
	End Method
	
	Method Init()
		preloader.Init()
	End Method
	
	Method BgColor()
		preloader.color.Request()
	End Method
	
	Method GetWidth:Int()
		Return preloader.width
	End Method
	
	Method SetWidth(width:Int)
		preloader.width = width
	End Method
	
	Method GetHeight:Int()
		Return preloader.height
	End Method
	
	Method SetHeight(height:Int)
		preloader.height = height
	End Method
	
	Method OnEvent(event:Int, src:TGadget)
		Select event
			Case EVENT_TIMERTICK
				preloader.Update()
				RedrawGadget(canvas)
				
			Case EVENT_GADGETPAINT
				SetGraphics (CanvasGraphics(canvas))
				SetClsColor(127, 127, 127)
				SetViewport(0, 0, canvas.ClientWidth(), canvas.ClientHeight())
				SetBlend(ALPHABLEND)
				
				Cls
				preloader.Draw()
				Flip
		End Select
	End Method

End Type
