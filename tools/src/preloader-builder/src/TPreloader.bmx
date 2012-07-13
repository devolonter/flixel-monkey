
Type TPreloader Extends TPreloaderObject

	Field properties:TPreloaderProperties
	
	Field imageProperties:TImageProperties
	
	Field objects:TList
	
	Field selectedObject:TPreloaderObject

	Method New()
		width = 640
		height = 480
	End Method
	
	Method Create:TPreloaderObject(context:TCanvas)
		Super.Create(context)
		
		properties = TPreloaderProperties(New TPreloaderProperties.Create(GetApplication()))
		imageProperties = TImageProperties(New TImageProperties.Create(GetApplication()))
		
		objects = New TList
		
		Return Self
	End Method
	
	Method Init()
		properties.Init()
		imageProperties.Init()
		properties.Show()
	End Method
	
	Method AddImage(image:TPreloaderImage)
		objects.AddLast(image)
		selectedObject = image
		ShowImageProperties()
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
		selectedObject = Null
	End Method
	
	Method MoveSelected(down:Int = False)
		If (selectedObject = Null) Return
		If (Not down) objects.Reverse()
		
		Local prev:TPreloaderObject
		For Local cur:TPreloaderObject = EachIn objects
			If (cur = selectedObject And prev <> Null) Then
				cur.weight = prev.weight + cur.weight
				prev.weight = cur.weight - prev.weight
				cur.weight = cur.weight - prev.weight
			End If
		
			prev = cur
		Next
		
		objects.Sort(True, CompareObjects)
	End Method
	
	Method Click(x:Int, y:Int)
		x:-Self.x
		y:-Self.y
	
		selectedObject = Null
		For Local img:TPreloaderImage = EachIn objects
			If (x >= img.x And ..
				y >= img.y And ..
				x <= img.x + img.width And ..
				y <= img.y + img.height)
				
				selectedObject = img
			End If
		Next
		
		If (selectedObject <> Null) Then
			If (TPreloaderImage(selectedObject) <> Null) Then
				ShowImageProperties()
			End If
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
		SetViewport(x, y, width, height)
		SetOrigin(x, y)
		
		For Local obj:TPreloaderObject = EachIn objects
			obj.Draw()
		Next

		SetColor(126, 186, 207)
		SetViewport(0, 0, context.canvas.width, context.canvas.height)
		SetOrigin(0, 0)
		
		If (selectedObject <> Null) Then
			DrawLine(0, y + selectedObject.y, context.canvas.width, y + selectedObject.y)
			
			DrawLine(0, y + selectedObject.y + selectedObject.height, context.canvas.width,  ..
					y + selectedObject.y + selectedObject.height)
					
			DrawLine(x + selectedObject.x, 0, x + selectedObject.x, context.canvas.height)
			
			DrawLine(x + selectedObject.x + selectedObject.width, 0,  ..
					x + selectedObject.x + selectedObject.width, context.canvas.height)
		End If
	End Method

End Type

Private

Function CompareObjects:Int(o1:Object, o2:Object)
	Return TPreloaderObject(o1).weight - TPreloaderObject(o2).weight
End Function
