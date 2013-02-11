
import android.net.Uri;

class flixel {

	public static boolean isMobile() {
		return true;
	}
	
	public static void openURL(String url) {
		Intent i = new Intent(Intent.ACTION_VIEW);
		i.setData(Uri.parse(url));
		MonkeyGame.activity.startActivity(i);
	}
	
}
