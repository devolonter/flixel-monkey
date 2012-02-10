
import android.net.Uri;

class flixel {
	
	public static int systemMillisecs() {
		return (int) System.currentTimeMillis();
	}	
	
	public static void showMouse() {
	}
	
	public static void hideMouse() {
	}
	
	public static boolean isMobile() {
		return true;
	}
	
	public static void openURL(String url) {
		Intent i = new Intent(Intent.ACTION_VIEW);
		i.setData(Uri.parse(url));
		MonkeyGame.activity.startActivity(i);
	}
	
}
