package com.pzrn.wechat;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReadableMap;
import com.tencent.mm.opensdk.constants.ConstantsAPI;
import com.tencent.mm.opensdk.modelbase.BaseReq;
import com.tencent.mm.opensdk.modelbase.BaseResp;
import com.tencent.mm.opensdk.modelmsg.SendAuth;
import com.tencent.mm.opensdk.modelpay.PayReq;
import com.tencent.mm.opensdk.modelpay.PayResp;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Nonnull;

public class WechatHelper implements IWXAPIEventHandler {

    private final Context context;
    private final Map<String, Promise> promises = new HashMap<>();
    private IWXAPI api;
    private BroadcastReceiver broadcastReceiver;
    private String appId;

    public WechatHelper(@Nonnull Context applicationContext) {
        this.context = applicationContext;
    }

    public void registerToWx(@Nonnull String appId, Promise promise) {
        this.appId = appId;
        // 通过WXAPIFactory工厂，获取IWXAPI的实例
        api = WXAPIFactory.createWXAPI(context, appId, true);

        // 将应用的appId注册到微信
        promise.resolve(api.registerApp(appId));

        //建议动态监听微信启动广播进行注册到微信
        broadcastReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                // 将该app注册到微信
                api.registerApp(appId);
            }
        };
        context.registerReceiver(broadcastReceiver, new IntentFilter(ConstantsAPI.ACTION_REFRESH_WXAPP));
    }

    public void handleReload() {
        if (broadcastReceiver != null) {
            context.unregisterReceiver(broadcastReceiver);
        }
    }

    public void isWXAppInstalled(Promise promise) {
        if (api != null) {
            promise.resolve(api.isWXAppInstalled());
        } else {
            promise.reject(new IllegalStateException("还没注册 App 到微信，不能调用此 API"));
        }
    }

    public void sendAuthRequest(Promise promise) {
        SendAuth.Req req = new SendAuth.Req();
        req.state = System.currentTimeMillis() + "";
        req.scope = "snsapi_userinfo";
        if (api.sendReq(req)) {
            promises.put(req.state, promise);
        } else {
            promise.reject(new RuntimeException("请求微信登录失败"));
        }
    }

    public void pay(@Nonnull ReadableMap data, Promise promise) {
        PayReq payReq = new PayReq();
        payReq.partnerId = data.getString("partnerId");
        payReq.prepayId = data.getString("prepayId");
        payReq.nonceStr = data.getString("nonceStr");
        payReq.timeStamp = String.valueOf(data.getInt("timeStamp"));
        payReq.sign = data.getString("sign");
        payReq.packageValue = data.getString("package");
        payReq.appId = appId;
        if (api.sendReq(payReq)) {
            promises.put(payReq.prepayId, promise);
        } else {
            promise.reject(new RuntimeException("微信支付失败"));
        }
    }

    public void handleIntent(Intent intent) {
        if (api != null) {
            api.handleIntent(intent, this);
        }
    }

    @Override
    public void onReq(BaseReq baseReq) {

    }

    @Override
    public void onResp(BaseResp baseResp) {
        // 登录
        if (baseResp instanceof SendAuth.Resp) {
            SendAuth.Resp resp = (SendAuth.Resp) baseResp;
            Promise promise = promises.get(resp.state);
            if (promise != null) {
                promises.remove(resp.state);
                if (resp.errCode == 0) {
                    promise.resolve(resp.code);
                } else {
                    promise.reject(new RuntimeException(resp.errStr));
                }
            }
        } else if (baseResp instanceof PayResp) {
            PayResp resp = (PayResp) baseResp;
            Promise promise = promises.get(resp.prepayId);
            if (promise != null) {
                promises.remove(resp.prepayId);
                if (resp.errCode == 0) {
                    promise.resolve(resp.returnKey);
                } else {
                    promise.reject(new RuntimeException(resp.errStr));
                }
            }
        }
    }
}
