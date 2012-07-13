
Type TMovableProperties Extends TProperties

	Field x:TGadget, y:TGadget
	
	Field moveUp:TGadget, moveDown:TGadget
	
	Method Init()
		x = AddTextField("X", 0, 70)
		y = AddTextField("Y", 0, 70)
		
		Self.OnInit()
		
		moveUp = AddImageButton("Move Up", "up")
		moveDown = AddImageButton("Move Down", "down")
	End Method
	
	Method Show()
		x.SetText(context.solution.preloader.selectedObject.x)
		y.SetText(context.solution.preloader.selectedObject.y)
		Super.Show()
	End Method
	
	Method OnEvent(event:Int, src:TGadget)
		Select event
			Case EVENT_GADGETACTION
				Select src
					Case x
						context.solution.preloader.selectedObject.x = Int(src.GetText())
						
					Case y
						context.solution.preloader.selectedObject.y = Int(src.GetText())
						
					Case moveUp
						context.solution.preloader.MoveSelected()
						
					Case moveDown
						context.solution.preloader.MoveSelected(True)
				End Select
		End Select
	End Method
	
	Method OnInit()
	End Method

End Type
