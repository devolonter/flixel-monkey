
Type TProperties Extends TListener Abstract
	
	Field panel:TGadget
	
	Field lastX:Int
	
	Method Create:TListener(context:TApplication)
		Super.Create(context)
		
		panel = CreatePanel(0, 0, context.propertiesBar.width,  ..
							context.propertiesBar.height, context.propertiesBar)
		panel.SetLayout(EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_CENTERED)
		HideGadget(panel)
		
		lastX = 6
		
		Return Self
	End Method
	
	Method Show()
		ShowGadget(panel)
		context.AddListener(Self)
		PollSystem()
	End Method
	
	Method Hide()
		HideGadget(panel)
		context.RemoveListener(Self)
	End Method
	
	Method AddTextField:TGadget(name:String, value:String, labelWidth:Int = 100, fieldWidth:Int = 0)
		Local labelHeight:Int = panel.height *.5
	
		Local label:TGadget = CreateLabel(name + ":", lastX, (panel.height - labelHeight) *.35, labelWidth, labelHeight, panel)
		label.SetLayout(EDGE_ALIGNED, EDGE_CENTERED, EDGE_RELATIVE, EDGE_CENTERED)
		
		lastX:+label.width
		If (fieldWidth = 0) fieldWidth = labelWidth
		Local fieldHeight:Int = panel.height *.75
		
		Local textField:TGadget = CreateTextField(lastX, (panel.height - fieldHeight) *.25, fieldWidth, fieldHeight, panel)
		textField.SetText(value)
		textField.SetLayout(EDGE_ALIGNED, EDGE_CENTERED, EDGE_RELATIVE, EDGE_CENTERED)
		
		lastX:+textField.width + 10
		
		Return textField
	End Method
	
	Method AddImageButton:TGadget(name:String, imagePath:String)
		Local size:Int = panel.height *.75
		
		Local button:TGadget = CreateButton(name, lastX, (panel.height - size) *.25, size, size, panel)
		button.SetPixmap(LoadPixmap("incbin::res\icons\" + imagePath + ".png"), GADGETPIXMAP_ICON | GADGETPIXMAP_NOTEXT)
		button.SetTooltip(name)
		
		Return button
	End Method
	
	Method Init() Abstract

End Type