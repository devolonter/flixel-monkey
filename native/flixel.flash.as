
import flash.system.Capabilities;

class flixel {
	
	static public function isMobile():Boolean {
		var os:String = Capabilities.version.substr(0, 3);
		var isMobile:Boolean = false;
		
		if (os == "AND") {
			isMobile = true;		
		} else {
			var mobileSystems:Array = new Array("Windows SmartPhone", "Windows PocketPC", "Windows Mobile", "Window CE");				
			isMobile = (mobileSystems.indexOf(Capabilities.os) != -1);
		}
		
		return isMobile;
	}

}
