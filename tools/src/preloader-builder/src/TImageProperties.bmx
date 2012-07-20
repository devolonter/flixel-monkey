
Type TImageProperties Extends TMovableProperties
	
	Field fromAlpha:TGadget, toAlpha:TGadget
	
	Field blendMode:TGadget

	Method OnInit()
		fromAlpha = AddTextField("Alpha From", 100, 35)
		toAlpha = AddTextField("To", 100, 35)
		blendMode = AddStringCombo("Blend", ["AlphaBlend", "AdditiveBlend"], 100)
	End Method
	
	Method Show()
		fromAlpha.SetText(TPreloaderImage(context.solution.preloader.selectedObject).fromAlpha)
		toAlpha.SetText(TPreloaderImage(context.solution.preloader.selectedObject).toAlpha)
		blendMode.SelectItem(TPreloaderImage(context.solution.preloader.selectedObject).blendMode - ALPHABLEND)
		
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
						
					Case blendMode
						TPreloaderImage(context.solution.preloader.selectedObject).blendMode = src.SelectedItem() + ALPHABLEND
						
				End Select
		End Select
	End Method 	
	
End Type
