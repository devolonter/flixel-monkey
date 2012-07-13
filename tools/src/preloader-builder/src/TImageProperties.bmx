
Type TImageProperties Extends TMovableProperties
	
	Field fromAlpha:TGadget, toAlpha:TGadget

	Method OnInit()
		fromAlpha = AddTextField("Alpha From", 100, 70, 35)
		toAlpha = AddTextField("To", 100, 25, 35)
	End Method
	
	Method Show()
		fromAlpha.SetText(TPreloaderImage(context.solution.preloader.selectedObject).fromAlpha)
		fromAlpha.SetText(TPreloaderImage(context.solution.preloader.selectedObject).toAlpha)
		Super.Show()
	End Method
	
	Method OnEvent(event:Int, src:TGadget)
		Super.OnEvent(event, src)
	
		Select event
			Case EVENT_GADGETACTION
				Select src
					Case fromAlpha
						TPreloaderImage(context.solution.preloader.selectedObject).fromAlpha = Int(src.GetText())
						
					Case toAlpha
						TPreloaderImage(context.solution.preloader.selectedObject).toAlpha = Int(src.GetText())
				End Select
		End Select
	End Method 	
	
End Type
