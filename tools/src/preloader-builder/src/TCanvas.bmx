
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
		canvas = CreateCanvas(0, context.propertiesBar.height, context.window.ClientWidth(),  ..
							context.window.ClientHeight() - context.propertiesBar.height, context.window)
		canvas.SetLayout(EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED)
		
		preloader = TPreloader(New TPreloader.Create(Self))
		
		CreateTimer(15)
		context.AddListener(Self)
		
		Return Self
	End Method
	
	Method Init()
		preloader.Init()
	End Method
	
	Method AddImage()
		Local path:String = RequestFile("Select Image", "Image Files:png,jpg")
		
		If (path <> Null) Then
			Local image:TImage = LoadImage(path)
			
			If (image <> Null) Then
				Local preloaderImage:TPreloaderImage = TPreloaderImage(New TPreloaderImage.Create(Self))
				preloaderImage.SetImage(image)
				preloader.AddImage(preloaderImage)
			End If
		End If
	End Method
	
	Method AddProgBar()
		preloader.AddProgBar(TPreloaderProgBar(New TPreloaderProgBar.Create(Self)))
	End Method
	
	Method AddText()
		preloader.AddText(TPreloaderText(New TPreloaderText.Create(Self)))
	End Method
	
	Method OnEvent(event:Int, src:TGadget)
		Select event
			Case EVENT_TIMERTICK
				preloader.Update()
				RedrawGadget(canvas)
				
			Case EVENT_GADGETPAINT
				SetGraphics (CanvasGraphics(canvas))
				SetClsColor(127, 127, 127)
				SetViewport(0, 0, canvas.width, canvas.height)
				SetBlend(ALPHABLEND)
				SetOrigin(0, 0)
				SetAlpha(1)
				SetColor(255, 255, 255)
								
				Cls
				preloader.Draw()
				Flip
				
			Case EVENT_MOUSEDOWN
				If (src = canvas And EventData() = MOUSE_LEFT) Then
					preloader.Click(EventX(), EventY())
				End If
		End Select
	End Method

End Type
