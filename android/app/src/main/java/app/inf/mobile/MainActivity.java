package app.inf.mobile;

import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.view.Window;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;


public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        registerBuildConfigChannel();
        drawUnderSystemUi();
    }

    @Override
    protected void onPostResume() {
        super.onPostResume();
        drawUnderSystemUi();
    }

    private void drawUnderSystemUi() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            Window window = getWindow();
            //window.setStatusBarColor(0x40000000);
            window.setNavigationBarColor(0x20000000);
            window.getDecorView()
                    .setSystemUiVisibility(
                            View.SYSTEM_UI_FLAG_LAYOUT_STABLE |
                                    View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN |
                                    View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION);
        }
    }

    private void registerBuildConfigChannel() {
		MethodChannel channel = new MethodChannel(getFlutterView(), "build/config");
		channel.setMethodCallHandler((call, result) -> {
			if(call.method.equals("get")){
				String name = call.argument("name");
				try{
					Object value = BuildConfig.class.getField(name).get(null);
					result.success(value.toString());
				}
				catch(NoSuchFieldException e){
					result.error("not_found", "Field '" + name + "' not found.", e);
				}
				catch(IllegalAccessException e){
					result.error("illegal_access", "Field permission '" + name + "' error.", e);
				}
			}
		});
    }
}
