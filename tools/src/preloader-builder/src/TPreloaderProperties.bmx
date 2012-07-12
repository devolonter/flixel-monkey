
Type TPreloaderProperties Extends TProperties

	Field width:TGadget, height:TGadget, color:TGadget

	Method Init()
		width = AddTextField("Width", context.solution.GetWidth(), 40, 70)
		height = AddTextField("Height", context.solution.GetHeight(), 45, 70)
		color = AddImageButton("Background Color", "color")
	End Method
	
	Method OnEvent(event:Int, src:TGadget)
		Select event
			Case EVENT_GADGETACTION
				Select src
					Case color
						context.solution.BgColor()
						
					Case width
						context.solution.SetWidth(Int(src.GetText()))
						
					Case height
						context.solution.SetHeight(Int(src.GetText()))
				End Select
			Case EVENT_KEYUP
				
		End Select
	End Method

End Type