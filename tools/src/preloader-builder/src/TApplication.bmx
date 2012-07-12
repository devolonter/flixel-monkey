
'Icons by http://www.fatcow.com/free-icons (Farm-fresh)
Type TApplication

	Const DEFAULT_WIDTH:Float = 900
	
	Const DEFAULT_HEIGHT:Float = 700
	
	Const MENU_NEW:Int = 10

	Field window:TGadget
	
	Field toolbar:TGadget
	
	Field propertiesBar:TGadget
	
	Field solution:TCanvas
	
	Field listeners:TList
	
	Field running:Int
	
	Method New()
		listeners = New TList
		
	End Method
	
	Method Create:TApplication()
		window = CreateWindow(z_blide_bgd3e99f15_f89d_4905_b08a_e0aed2f388bc.Name, 0, 0,  ..
		DEFAULT_WIDTH, DEFAULT_HEIGHT, Null, WINDOW_TITLEBAR | WINDOW_MENU | WINDOW_CENTER | WINDOW_RESIZABLE)
		
		Local menu:TGadget, file:TGadget, build:TGadget, help:TGadget
		
		menu = CreateMenu("&File", 0, window)
		menu = CreateMenu("&Build", 0, window)
		menu = CreateMenu("&Help", 0, window)
		
		window.UpdateMenu()
		
		toolbar = CreateToolbar("incbin::res\toolbar.png", 0, 0, 0, 0, window)
		SetToolbarTips(toolbar, ["New", "Save", "", "Properties", "", "Add Image", "Add Progressbar", "Add Text"])
		
		propertiesBar = CreatePanel(0, 0, window.ClientWidth(), 30, window)
		propertiesBar.SetLayout(EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_CENTERED)
		
		solution = TCanvas(New TCanvas.Create(Self))
		solution.Init()
		
		running = True
		Return Self
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
	
	Method AddListener(listener:TListener)
		listeners.AddLast(listener)
	End Method
	
	Method RemoveListener(listener:TListener)
		listeners.Remove(listener)
	End Method
	
	Method Poll()
		Local event:Int = WaitEvent()
		Local src:TGadget = TGadget(EventSource())
		
		For Local listener:TListener = EachIn listeners
			listener.OnEvent(event, src)
		Next
		
		Select event
			Case EVENT_APPTERMINATE
				Quit()
				
			Case EVENT_WINDOWCLOSE
				If (src = window) Quit()
		End Select
	End Method

End Type
