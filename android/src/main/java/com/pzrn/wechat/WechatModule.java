package com.pzrn.wechat;

import android.content.Intent;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.UiThreadUtil;
import com.facebook.react.module.annotations.ReactModule;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

@ReactModule(name = "RNWechat")
public class WechatModule extends ReactContextBaseJavaModule {

    private final WechatHelper wechatHelper;

    public WechatModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.wechatHelper = new WechatHelper(reactContext.getApplicationContext());
    }

    @Override
    public void onCatalystInstanceDestroy() {
        super.onCatalystInstanceDestroy();
        this.wechatHelper.handleReload();
    }

    @Override
    public String getName() {
        return "RNWechat";
    }

    @ReactMethod
    public void registerApp(@Nonnull String appId, @Nonnull String universalLink, Promise promise) {
        UiThreadUtil.runOnUiThread(() -> wechatHelper.registerToWx(appId, promise));
    }

    @ReactMethod
    public void isWXAppInstalled(Promise promise) {
        UiThreadUtil.runOnUiThread(() -> wechatHelper.isWXAppInstalled(promise));
    }

    @ReactMethod
    public void sendAuthRequest(Promise promise) {
        UiThreadUtil.runOnUiThread(() -> wechatHelper.sendAuthRequest(promise));
    }

    @ReactMethod
    public void pay(@Nonnull ReadableMap data, Promise promise) {
        UiThreadUtil.runOnUiThread(() -> wechatHelper.pay(data, promise));
    }

    public void handleIntent(Intent intent) {
        wechatHelper.handleIntent(intent);
    }

    public static void handleIntent(@Nullable ReactContext reactContext, Intent intent) {
        if (reactContext != null) {
            WechatModule wechatModule = reactContext.getNativeModule(WechatModule.class);
            if (wechatModule != null) {
                wechatModule.handleIntent(intent);
            }
        }
    }
}
