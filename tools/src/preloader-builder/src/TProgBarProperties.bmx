
Type TProgBarProperties Extends TMovableProperties

	Field width:TGadget, height:TGadget
	
	Field color:TGadget
	
	Method OnInit()
		width = AddTextField("Width", 0, 70)
		height = AddTextField("Height", 0, 70)
		color = AddImageButton("Set Color", "color")
	End Method
	
	Method Show()
		width.SetText(context.solution.preloader.selectedObject.width)
		height.SetText(context.solution.preloader.selectedObject.height)
		Super.Show()
	End Method
	
	Method OnEvent(event:Int, src:TGadget)
		Super.OnEvent(event, src)
	
		Select event
			Case EVENT_GADGETACTION
				Select src
					Case width
						context.solution.preloader.selectedObject.width = Int(src.GetText())
						
					Case height
						context.solution.preloader.selectedObject.height = Int(src.GetText())
						
					Case color
						context.solution.preloader.selectedObject.color.Request()
				End Select
		End Select
	End Method

End Type
