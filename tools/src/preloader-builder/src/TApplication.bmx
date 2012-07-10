
Type TApplication

	Const DEFAULT_WIDTH:Float = 800
	
	Const DEFAULT_HEIGHT:Float = 600
	
	Const MENU_NEW:Int = 10
	
	

	Field window:TGadget
	
	Field listeners:TList
	
	Field running:Int
	
	Method New()
		window = CreateWindow(z_blide_bgd3e99f15_f89d_4905_b08a_e0aed2f388bc.Name, 0, 0,  ..
		DEFAULT_WIDTH, DEFAULT_HEIGHT, Null, WINDOW_TITLEBAR | WINDOW_MENU | WINDOW_CENTER)
		InitMenu()
		
		listeners = New TList
		running = True
	End Method
	
	Method Quit()
		running = False
	End Method
	
	Method Center(gadget:TGadget)
		Local parent:TGadget = gadget.parent
		If (parent = Null) parent = window
		If (gadget = parent) parent = Desktop()
		
		gadget.SetShape((parent.width - gadget.width) *.5, (parent.height - gadget.height) *.5,  ..
						gadget.width, gadget.height)
	End Method
	
	Method Poll()
		Local event:Int = WaitEvent()
		Local src:TGadget = TGadget(EventSource())
		
		For Local listener:TListener = EachIn listeners
			listener.OnEvent()
		Next
		
		Select event
			Case EVENT_APPTERMINATE
				Quit()
				
			Case EVENT_WINDOWCLOSE
				If (src = window) Quit()
		End Select
	End Method
	
	Method InitMenu()
		Local menu:TGadget, file:TGadget, presets:TGadget, build:TGadget, help:TGadget
		
		menu = CreateMenu("&File", 0, window)
		menu = CreateMenu("&Presets", 0, window)
		menu = CreateMenu("&Build", 0, window)
		menu = CreateMenu("&Help", 0, window)
		
		window.UpdateMenu()
	End Method

End Type
