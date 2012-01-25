
class flixel {

	static public function systemMillisecs():int {
		return (new Date).getTime();
	}	
	
	static public function showMouse():void {
		flash.ui.Mouse.show();
	}
	
	static public function hideMouse():void {
		flash.ui.Mouse.hide();
	}
	
	static public function isMobile():Boolean {
		var os:String = flash.system.Capabilities.version.substr(0, 3);
		var isMobile:Boolean = false;
		
		if (os == "AND") {
			isMobile = true;		
		} else {
			var mobileSystems:Array = new Array("Windows SmartPhone", "Windows PocketPC", "Windows Mobile");				
			isMobile = (mobileSystems.indexOf(flash.system.Capabilities.os) != -1);
		}
		
		return isMobile;
	}
	
	

}
