
Type TPreloader Extends TPreloaderObject

	Field properties:TPreloaderProperties
	
	Field imageProperties:TImageProperties
	
	Field images:TList
	
	Field activeImage:TPreloaderImage

	Method New()
		width = 640
		height = 480
	End Method
	
	Method Create:TPreloaderObject(context:TCanvas)
		Super.Create(context)
		
		properties = TPreloaderProperties(New TPreloaderProperties.Create(GetApplication()))
		imageProperties = TImageProperties(New TImageProperties.Create(GetApplication()))
		
		images = New TList
		
		Return Self
	End Method
	
	Method Init()
		properties.Init()
		imageProperties.Init()
		properties.Show()
	End Method
	
	Method AddImage(image:TPreloaderImage)
		images.AddLast(image)
		activeImage = image
		ShowImageProperties()
	End Method
	
	Method GetActiveImage:TPreloaderImage()
		Return activeImage
	End Method
	
	Method ShowPreloaderProperties()
		HideAllProperties()
		properties.Show()
	End Method
	
	Method ShowImageProperties()
		HideAllProperties()
		imageProperties.Show()
	End Method
	
	Method HideAllProperties()
		properties.Hide()
		imageProperties.Hide()
	End Method
	
	Method DeselectAll()
		ShowPreloaderProperties()
		activeImage = Null
	End Method
	
	Method Click(x:Int, y:Int)
		x:-Self.x
		y:-Self.y
	
		activeImage = Null
		For Local img:TPreloaderImage = EachIn images
			If (x >= img.x And ..
				y >= img.y And ..
				x <= img.x + img.width And ..
				y <= img.y + img.height)
				
				activeImage = img
			End If
		Next
		
		If (activeImage <> Null) Then
			ShowImageProperties()
			Return
		End If
		
		DeselectAll()
	End Method
	
	Method Update()
		x = (context.canvas.ClientWidth() - width) *.5
		y = (context.canvas.ClientHeight() - height) *.5
	End Method
	
	Method Draw()
		SetAlpha(.2)
		SetColor(0, 0, 0)
		DrawRect(x + 3, y + 3, width, height)
		
		SetAlpha(1)
		SetColor(color.r, color.g, color.b)
		DrawRect(x, y, width, height)
		
		SetColor(255, 255, 255)
		SetOrigin(x, y)
		
		For Local img:TPreloaderImage = EachIn images
			DrawImage(img.src, img.x, img.y)
		Next

		SetColor(126, 186, 207)
		SetOrigin(0, 0)
		
		If (activeImage <> Null) Then
			DrawLine(0, y + activeImage.y, context.canvas.width, y + activeImage.y)
			
			DrawLine(0, y + activeImage.y + activeImage.height, context.canvas.width,  ..
					y + activeImage.y + activeImage.height)
					
			DrawLine(x + activeImage.x, 0, x + activeImage.x, context.canvas.height)
			
			DrawLine(x + activeImage.x + activeImage.width, 0,  ..
					x + activeImage.x + activeImage.width, context.canvas.height)
		End If
	End Method

End Type
