
Type TPreloaderProperties Extends TProperties

	Method Create:TListener(context:TApplication)
		Super.Create(context)
		
		AddTextField("Width", 40, 70)
		AddTextField("Height", 45, 70)
		
		Return Self
	End Method
	
	Method OnEvent(event:Int, src:TGadget)
		
	End Method

End Type