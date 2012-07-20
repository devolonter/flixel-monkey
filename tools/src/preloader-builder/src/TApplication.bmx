
'Icons by http://www.fatcow.com/free-icons (Farm-fresh)
Type TApplication

	Const DEFAULT_WIDTH:Float = 900
	
	Const DEFAULT_HEIGHT:Float = 700
	
	Const TB_NEW:Int = 0
	
	Const TB_SAVE:Int = 1
	
	Const TB_PREF:Int = 3
	
	Const TB_IMAGE:Int = 5
	
	Const TB_PROGBAR:Int = 6
	
	Const TB_TEXT:Int = 7
	
	Const MENU_OPEN:Int = 10
	
	Const EXT:String = "flxp"
	
	Const DEFAULT_FLXP:String = "default." + EXT

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
		window = CreateWindow(z_blide_bgd3e99f15_f89d_4905_b08a_e0aed2f388bc.Name + " v" + ..
							z_blide_bgd3e99f15_f89d_4905_b08a_e0aed2f388bc.MajorVersion + "." + ..
							z_blide_bgd3e99f15_f89d_4905_b08a_e0aed2f388bc.MinorVersion + ..
							z_blide_bgd3e99f15_f89d_4905_b08a_e0aed2f388bc.Revision,  ..
							0, 0, DEFAULT_WIDTH, DEFAULT_HEIGHT, Null,  ..
							WINDOW_TITLEBAR | WINDOW_MENU | WINDOW_CENTER | WINDOW_RESIZABLE)
		
		Local file:TGadget, build:TGadget, help:TGadget
		
		file = CreateMenu("&File", 0, window)
		
		CreateMenu("&Open", MENU_OPEN, file)
		
		build = CreateMenu("&Build", 0, window)
		help = CreateMenu("&Help", 0, window)
		
		window.UpdateMenu()

		toolbar = CreateToolbar("incbin::res\toolbar.png", 0, 0, 0, 0, window)
		SetToolbarTips(toolbar, ["New", "Save", "", "Properties", "", "Add Image", "Add Progressbar", "Add Text"])
		
		propertiesBar = CreatePanel(0, 0, window.ClientWidth(), 30, window)
		propertiesBar.SetLayout(EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_CENTERED)
		
		solution = TCanvas(New TCanvas.Create(Self))
		solution.Init()
		
		If (Not FileType(GetTempDirectory() + DEFAULT_FLXP)) Then
			Local defaultFlxp:TStream = WriteStream(GetTempDirectory() + DEFAULT_FLXP)
			CopyStream(ReadStream("incbin::res\system\" + DEFAULT_FLXP), defaultFlxp, 10 * 1024)
			defaultFlxp.Close()
		End If
		
		SetGraphics (CanvasGraphics(solution.canvas))
		solution.Load(GetTempDirectory() + DEFAULT_FLXP)
		
		running = True
		
		Return Self
	End Method
	
	Method DeselectAll()
		solution.preloader.DeselectAll()
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
			Case EVENT_GADGETACTION
				If (src = toolbar) Then
					Select EventData()
						Case TB_NEW
							solution.Reset()
					
						Case TB_SAVE
							solution.Save()
					
						Case TB_PREF
							DeselectAll()
					
						Case TB_IMAGE
							solution.AddImage()
							
						Case TB_PROGBAR
							solution.AddProgBar()
							
						Case TB_TEXT
							solution.AddText()
							
					End Select
				End If
				
			Case EVENT_MENUACTION
				Select EventData()
					Case MENU_OPEN
						solution.Open()
				End Select
		
			Case EVENT_APPTERMINATE
				Quit()
				
			Case EVENT_WINDOWCLOSE
				If (src = window) Quit()
		End Select
	End Method

End Type