
namespace flixel {

#if WINDOWS
	using System.Diagnostics;
#elif WINDOWS_PHONE
	using Microsoft.Phone.Tasks;
#endif

	class functions {	
		
		public static bool isMobile() {
	#if WINDOWS_PHONE
			return true;
	#else
			return false;
	#endif
		}
		
		public static void openURL(String url) {
	#if WINDOWS
			Process.Start(url);
	#elif WINDOWS_PHONE
			WebBrowserTask task = new WebBrowserTask();
			task.URL = url;
			task.Show();
	#endif
		}

	}

}
