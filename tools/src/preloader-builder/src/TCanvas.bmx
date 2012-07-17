
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
				preloaderImage.filename = path
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
	
	Method Save()
		Local filePath:String = RequestFile("Save As...", "Preloader Files:flxp", True)
		If (Not filePath) Return
		
		Local flxp:ZipWriter = New ZipWriter
		flxp.OpenZip(filePath, APPEND_STATUS_CREATE)
		
		Local info:String
		
		info:+z_blide_bgd3e99f15_f89d_4905_b08a_e0aed2f388bc.MajorVersion + ":"
		info:+z_blide_bgd3e99f15_f89d_4905_b08a_e0aed2f388bc.MinorVersion + ":"
		info:+z_blide_bgd3e99f15_f89d_4905_b08a_e0aed2f388bc.Revision + ";"
		
		info:+preloader.width + ":"
		info:+preloader.height + ":"
		info:+preloader.color.ToString() + ";"
		
		Local images:TMap = New TMap
		
		For Local obj:TPreloaderObject = EachIn preloader.objects
			If (TPreloaderImage(obj)) Then
				info:+"image:"
				
			ElseIf(TPreloaderProgBar(obj)) Then
				info:+"progbar:"
				
			ElseIf(TPreloaderText(obj))
				info:+"text:"
			End If
		
			info:+obj.x + ":"
			info:+obj.y + ":"
			info:+obj.width + ":"
			info:+obj.height + ":"
			
			If (TPreloaderImage(obj)) Then
				Local filename:String = "images/" + StripDir(TPreloaderImage(obj).filename)
			
				If (Not images.Contains(TPreloaderImage(obj).filename)) Then
					flxp.AddStream(ReadStream(TPreloaderImage(obj).filename), filename)
					
				End If
			
				info:+filename + ":"
				info:+TPreloaderImage(obj).fromAlpha + ":"
				info:+TPreloaderImage(obj).toAlpha + ":"
				info:+TPreloaderImage(obj).blendMode
				
			ElseIf(TPreloaderProgBar(obj)) Then
				info:+TPreloaderProgBar(obj).color.ToString()
				
			ElseIf(TPreloaderText(obj))
				info:+TPreloaderText(obj).size + ":"
				info:+TPreloaderText(obj).text + ":"
				info:+TPreloaderText(obj).color.ToString()
			End If
			
			info:+","
		Next
		
		info = info[..(info.Length - 1)]
		
		Local infoStream:TStream = CreateBankStream(CreateBank(info.Length))
		infoStream.WriteString(info)
		
		flxp.AddStream(infoStream, "info")
		
		flxp.CloseZip()
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
