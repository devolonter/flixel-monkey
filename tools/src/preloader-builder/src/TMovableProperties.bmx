
Type TMovableProperties Extends TProperties

	Field x:TGadget, y:TGadget
	
	Field hAlign:TGadget, vAlign:TGadget
	
	Field moveUp:TGadget, moveDown:TGadget
	
	Field remove:TGadget
	
	Method Init()
		x = AddTextField("X", 0, 70)
		y = AddTextField("Y", 0, 70)
		
		Self.OnInit()
		
		hAlign = AddImageComboBox("H Align", "h-align", True)
		vAlign = AddImageComboBox("V Align", "v-align", True)
		
		moveUp = AddImageButton("Move Up", "up")
		moveDown = AddImageButton("Move Down", "down")
		
		remove = AddImageButton("Remove", "delete")
	End Method
	
	Method Show()
		x.SetText(context.solution.preloader.selectedObject.x)
		y.SetText(context.solution.preloader.selectedObject.y)
		hAlign.SelectItem(0)
		vAlign.SelectItem(0)
		Super.Show()
	End Method
	
	Method OnEvent(event:Int, src:TGadget)
		Select event
			Case EVENT_GADGETACTION
				Select src
					Case x
						context.solution.preloader.selectedObject.x = Int(src.GetText())
						hAlign.SelectItem(0)
						
					Case y
						context.solution.preloader.selectedObject.y = Int(src.GetText())
						vAlign.SelectItem(0)
						
					Case hAlign
						Select hAlign.SelectedItem()
							Case 1
								context.solution.preloader.selectedObject.x = 0
							Case 2
								context.solution.preloader.selectedObject.x = (context.solution.preloader.width - context.solution.preloader.selectedObject.width) *.5
							Case 3
								context.solution.preloader.selectedObject.x = context.solution.preloader.width - context.solution.preloader.selectedObject.width
						End Select
						
						x.SetText(context.solution.preloader.selectedObject.x)
						
					Case vAlign
						Select vAlign.SelectedItem()
							Case 1
								context.solution.preloader.selectedObject.y = 0
							Case 2
								context.solution.preloader.selectedObject.y = (context.solution.preloader.height - context.solution.preloader.selectedObject.height) *.5
							Case 3
								context.solution.preloader.selectedObject.y = context.solution.preloader.height - context.solution.preloader.selectedObject.height
						End Select
						
						y.SetText(context.solution.preloader.selectedObject.y)
						
					Case moveUp
						context.solution.preloader.MoveSelected()
						
					Case moveDown
						context.solution.preloader.MoveSelected(True)
						
					Case remove
						context.solution.preloader.RemoveSelected()
				End Select
		End Select
	End Method
	
	Method OnInit()
	End Method

End Type
