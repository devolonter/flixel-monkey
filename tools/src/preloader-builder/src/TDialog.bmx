
Type TDialog Extends TListener Abstract

	Const OK:Int = 1, CANCEL:Int = 2
	
	Field window:TGadget, okButton:TGadget, cancelButton:TGadget
	
	Method Build(title:String, actionText:String = "OK", width:Int = 260, height:Int = 60, buttons:Int = TDialog.OK | TDialog.CANCEL)
		If (buttons & (TDialog.OK | TDialog.CANCEL)) Then
			height:+44
		End If
		
		window = CreateWindow(title, 0, 0, width, height, context.window, WINDOW_TITLEBAR | WINDOW_HIDDEN | WINDOW_CLIENTCOORDS)
				
		If (buttons & TDialog.OK) Then
			okButton = CreateButton(actionText, window.ClientWidth() - 101, window.ClientHeight() - 32, 95, 26, window, BUTTON_OK)
			okButton.SetLayout(EDGE_CENTERED, EDGE_ALIGNED, EDGE_CENTERED, EDGE_ALIGNED)
			
			If (buttons & TDialog.CANCEL) Then
				cancelButton = CreateButton("Cancel", 6, window.ClientHeight() - 32, 95, 26, window, BUTTON_CANCEL)
				cancelButton.SetLayout(EDGE_ALIGNED, EDGE_CENTERED, EDGE_CENTERED, EDGE_ALIGNED)
			EndIf
			
		Else
			If (buttons & TDialog.CANCEL) Then
				cancelButton = CreateButton("Close", window.ClientWidth() - 101, window.ClientHeight() - 32, 95, 26, window, BUTTON_CANCEL)
				cancelButton.SetLayout(EDGE_CENTERED, EDGE_ALIGNED, EDGE_CENTERED, EDGE_ALIGNED)
			EndIf
		EndIf
		
		If (buttons & (TDialog.OK | TDialog.CANCEL)) Then
			Local separator:TGadget = CreateLabel("", 6, window.ClientHeight() - 42, window.ClientWidth() - 12, 4, window, LABEL_SEPARATOR)
			separator.SetLayout(EDGE_ALIGNED, EDGE_ALIGNED, EDGE_CENTERED, EDGE_ALIGNED)
		End If
	End Method
	
	Method Show()
		window.SetShape((context.window.width - window.width) *.5,  ..
						(context.window.height - window.height) *.5,  ..
						window.width, window.height)
		
		ShowGadget(window)
		ActivateGadget(window)
		
		DisableGadget(context.window)
		context.AddListener(Self)
		PollSystem()
	End Method
	
	Method Hide()
		HideGadget(window)
		
		context.RemoveListener(Self)
		
		EnableGadget(context.window)
		ActivateGadget(context.window)
	End Method
	
	Method OnEvent(event:Int, src:TGadget)
		Select event
			Case EVENT_WINDOWCLOSE
				If (src = window) Hide()
				
			Case EVENT_GADGETACTION
				If (src = okButton) Then
					If (OnConfirm()) Then
						Hide()
					End If					
				ElseIf (src = cancelButton)
					Hide()
				EndIf
		End Select
	End Method
	
	Method OnConfirm:Int() Abstract

End Type
