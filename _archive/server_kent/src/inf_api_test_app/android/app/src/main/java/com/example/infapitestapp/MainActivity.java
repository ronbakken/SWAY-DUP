package com.example.infapitestapp;

import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;


public class MainActivity extends FlutterActivity
{
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		GeneratedPluginRegistrant.registerWith(this);

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
