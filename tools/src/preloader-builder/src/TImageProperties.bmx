
Type TImageProperties Extends TProperties

	Field x:TGadget, y:TGadget

	Method Init()
		x = AddTextField("X", 0, 20, 70)
		y = AddTextField("Y", 0, 20, 70)
	End Method
	
	Method Show()
		x.SetText(context.GetSolution().GetActiveImageX())
		y.SetText(context.GetSolution().GetActiveImageY())
		Super.Show()
	End Method
		
	Method OnEvent(event:Int, src:TGadget)
		Select event
			Case EVENT_GADGETACTION
				Select src
					Case x
						context.GetSolution().SetActiveImageX(Int(x.GetText()))
						
					Case y
						context.GetSolution().SetActiveImageY(Int(y.GetText()))
				End Select
		End Select
	End Method

End Type
