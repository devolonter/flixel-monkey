
namespace flixel {
	
	using Sce.PlayStation.Core.Environment;

	class functions {	
		
		public static bool isMobile() {
			return true;
		}
		
		public static void openURL(String url) {
			Shell.Action action = Shell.Action.BrowserAction(url);
			Shell.Execute(ref action);
		}

	}

}
