
namespace flixel {

	class functions {	

		public static int systemMillisecs() {		
			return (int) (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond);
		}
		
		public static void showMouse() {
		}
		
		public static void hideMouse() {
		}
		
		public static bool isMobile() {
			return true;
		}
		
		public static void openURL(String url) {
			
		}

	}

}
