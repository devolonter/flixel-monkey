
Type TImageProperties Extends TProperties

	Field x:TGadget, y:TGadget
	
	Field fromAlpha:TGadget, toAlpha:TGadget
	
	Field moveUp:TGadget, moveDown:TGadget

	Method Init()
		x = AddTextField("X", 0, 20, 70)
		y = AddTextField("Y", 0, 20, 70)
		
		fromAlpha = AddTextField("Alpha From", 100, 70, 35)
		toAlpha = AddTextField("To", 100, 25, 35)
		
		moveUp = AddImageButton("Move Up", "up")
		moveDown = AddImageButton("Move Down", "down")
	End Method
	
	Method Show()
		x.SetText(context.solution.preloader.activeImage.x)
		y.SetText(context.solution.preloader.activeImage.y)
		Super.Show()
	End Method
		
	Method OnEvent(event:Int, src:TGadget)
		Select event
			Case EVENT_GADGETACTION
				Select src
					Case x
						context.solution.preloader.activeImage.x = Int(src.GetText())
						
					Case y
						context.solution.preloader.activeImage.y = Int(src.GetText())
						
					Case moveUp
						context.solution.preloader.MoveImageUp()
						
					Case moveDown
						context.solution.preloader.MoveImageDown()
				End Select
		End Select
	End Method

End Type
