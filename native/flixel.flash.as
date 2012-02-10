
import flash.ui.Mouse;
import flash.system.Capabilities;
import flash.net.URLRequest;
import flash.net.navigateToURL;

class flixel {

	static public function systemMillisecs():int {
		return (new Date).getTime();
	}	
	
	static public function showMouse():void {
		Mouse.show();
	}
	
	static public function hideMouse():void {
		Mouse.hide();
	}
	
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
	
	static public function openURL(URL:String):void {
		navigateToURL(new URLRequest(URL), "_blank");
	}

}
