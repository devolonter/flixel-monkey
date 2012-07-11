
Type TPreloaderProperties Extends TDialog

	Field bgColorInfo:TGadget, bgColorButton:TGadget

	Method Create:TListener(context:TApplication)
		Super.Create(context)
		
		Build("Preloader Properties")
		
		Local padding:Int = 6
		Local labelWidth:Int = window.ClientWidth() *.4
		Local fieldHeight:Int = 26
		Local fieldX:Int = (window.ClientWidth() - labelWidth) + padding * 2
		Local fieldWidth:Int = (window.ClientWidth() - fieldX) - padding
		Local labelHeight:Int = fieldHeight
		
		
		bgColorInfo = CreateLabel("Background color: ", padding, padding + labelHeight *.25, labelWidth, labelHeight, window)
		bgColorButton = CreateButton("Change", fieldX, padding, fieldWidth, fieldHeight, window)
		
		Return Self
	End Method

	Method OnConfirm:Int()
		Return True
	End Method
	
	Method OnEvent(event:Int, src:TGadget)
		Super.OnEvent(event, src)
		
		Select event
			Case EVENT_GADGETACTION
				If (src = bgColorButton) context.workArea.project.color.Request()
		End Select
	End Method

End Type
