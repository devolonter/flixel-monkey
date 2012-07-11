
Type TListener Abstract

	Field context:TApplication
	
	Method Create:TListener(context:TApplication)
		Self.context = context
		Return Self
	End Method
	
	Method OnEvent(event:Int, src:TGadget) Abstract

End Type
