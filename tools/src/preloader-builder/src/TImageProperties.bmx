
Type TImageProperties Extends TMovableProperties
	
	Field fromAlpha:TGadget, toAlpha:TGadget

	Method OnInit()
		fromAlpha = AddTextField("Alpha From", 100, 70, 35)
		toAlpha = AddTextField("To", 100, 25, 35)
	End Method	
	
End Type
