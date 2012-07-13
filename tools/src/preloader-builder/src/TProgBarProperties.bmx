
Type TProgBarProperties Extends TMovableProperties

	Field color:TGadget
	
	Method OnInit()
		color = AddImageButton("Set Color", "color")
	End Method

End Type
