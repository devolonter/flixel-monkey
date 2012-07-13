
Type TPreloaderProperties Extends TProperties

	Field width:TGadget, height:TGadget, color:TGadget

	Method Init()
		width = AddTextField("Width", context.solution.preloader.width, 70)
		height = AddTextField("Height", context.solution.preloader.height, 70)
		color = AddImageButton("Background Color", "color")
	End Method
	
	Method OnEvent(event:Int, src:TGadget)
		Select event
			Case EVENT_GADGETACTION
				Select src
					Case color
						context.solution.preloader.color.Request()
						
					Case width
						context.solution.preloader.width = Int(src.GetText())
						
					Case height
						context.solution.preloader.height = Int(src.GetText())
				End Select
		End Select
	End Method

End Type