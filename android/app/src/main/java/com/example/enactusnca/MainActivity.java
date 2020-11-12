package com.example.enactusnca;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.android.SplashScreen;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.view.FlutterMain;

public class MainActivity extends FlutterActivity {

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        flutterEngine = new FlutterEngine(getContext());
        flutterEngine.getDartExecutor().executeDartEntrypoint(new DartExecutor.DartEntrypoint(
                FlutterMain.findAppBundlePath(getContext()), "main"));
    }

    @Override
    public SplashScreen provideSplashScreen() {
        return new CustomSplashScreen();
    }

}
