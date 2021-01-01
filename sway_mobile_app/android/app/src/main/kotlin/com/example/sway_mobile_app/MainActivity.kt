package app.infsandbox

import io.flutter.embedding.android.FlutterActivity

import com.microsoft.appcenter.AppCenter
import com.microsoft.appcenter.analytics.Analytics
import com.microsoft.appcenter.crashes.Crashes

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
		AppCenter.start(getApplication(), "17c4d591-44f7-40f0-aabd-d36a1e4929cf", Analytics.class.java, Crashes.class.java);
    }
}
