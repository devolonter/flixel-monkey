
Type TTextProperties Extends TMovableProperties

	Field size:TGadget, text:TGadget
	
	Field color:TGadget

	Method OnInit()
		text = AddTextField("Text", "", 150)
		size = AddNumericComboBox("Size", TPreloaderText.MIN_SIZE, TPreloaderText.MAX_SIZE, 50)
		color = AddImageButton("Set Color", "color")
	End Method
	
	Method Show()
		text.SetText(TPreloaderText(context.solution.preloader.selectedObject).text)
		size.SelectItem(TPreloaderText(context.solution.preloader.selectedObject).size - TPreloaderText.MIN_SIZE)
		Super.Show()
	End Method
	
	Method OnEvent(event:Int, src:TGadget)
		Super.OnEvent(event, src)
	
		Select event
			Case EVENT_GADGETACTION
				Select src
					Case text
						TPreloaderText(context.solution.preloader.selectedObject).SetText(src.GetText())
						
					Case size
						TPreloaderText(context.solution.preloader.selectedObject).SetSize(Int(src.ItemText(src.SelectedItem())))
				
					Case color
						context.solution.preloader.selectedObject.color.Request()
				End Select
		End Select
	End Method

End Type
