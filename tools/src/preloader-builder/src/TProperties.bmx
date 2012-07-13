
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
	
	Method AddLabel(name:String)
		Local labelHeight:Int = panel.height *.5
	
		Local label:TGadget = CreateLabel(name + ":", lastX, (panel.height - labelHeight) *.35, 0, labelHeight, panel)
		label.SetLayout(EDGE_ALIGNED, EDGE_CENTERED, EDGE_RELATIVE, EDGE_CENTERED)

		Local result:Int[] = GadgetSizeForString(label, label.GetText())
		label.SetShape(label.xpos, label.ypos, result[0] + 7, label.height)
		
		lastX:+label.width
	End Method
	
	Method AddTextField:TGadget(name:String, value:String, fieldWidth:Int)
		AddLabel(name)
		Local fieldHeight:Int = panel.height *.75
				
		Local textField:TGadget = CreateTextField(lastX, (panel.height - fieldHeight) *.25, fieldWidth, fieldHeight, panel)
		textField.SetText(value)
		textField.SetLayout(EDGE_ALIGNED, EDGE_CENTERED, EDGE_RELATIVE, EDGE_CENTERED)
		
		lastX:+textField.width + 10
		
		Return textField
	End Method
	
	Method AddImageButton:TGadget(name:String, icon:String)
		Local size:Int = panel.height *.9
		
		Local button:TGadget = CreateButton(name, lastX, (panel.height - size) *.1, size, size, panel)
		button.SetPixmap(LoadPixmap("incbin::res\icons\" + icon + ".png"), GADGETPIXMAP_ICON | GADGETPIXMAP_NOTEXT)
		button.SetTooltip(name)
		button.SetLayout(EDGE_ALIGNED, EDGE_CENTERED, EDGE_RELATIVE, EDGE_CENTERED)
		
		lastX:+size + 10
		
		Return button
	End Method
	
	Method AddComboBox:TGadget(name:String, fieldWidth:Int)
		AddLabel(name)
		Local fieldHeight:Int = panel.height *.75
		
		Local combo:TGadget = CreateComboBox(lastX, (panel.height - fieldHeight) *.2, fieldWidth, fieldHeight, panel)
		combo.SetLayout(EDGE_ALIGNED, EDGE_CENTERED, EDGE_RELATIVE, EDGE_CENTERED)
		
		lastX:+combo.width + 10
		
		Return combo
	End Method
	
	Method AddNumericComboBox:TGadget(name:String, fromValue:Int, toValue:Int, fieldWidth:Int)
		Local combo:TGadget = AddComboBox(name, fieldWidth)
		
		For Local i:Int = fromValue to toValue
			AddGadgetItem(combo, i)
		Next
		
		combo.SelectItem(0)
		
		Return combo
	End Method
	
	Method AddImageComboBox:TGadget(name:String, icons:String, noValue:Int = False)
		Local combo:TGadget = AddComboBox(name, panel.height * 1.4)
		Local strip:TIconStrip = LoadIconStrip("incbin::res\icons\" + icons + ".png")
		combo.SetIconStrip(strip)
		
		Local from:Int = 0
		If (noValue) from = -1
		
		For Local i:Int = from To strip.count - 1
			AddGadgetItem(combo, "",, i)
		Next
		
		combo.SelectItem(0)
		
		Return combo
	End Method
	
	Method Init() Abstract

End Type
