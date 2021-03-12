# 微信登录，微信支付，微信分享

[官方接入指南](https://developers.weixin.qq.com/doc/oplatform/Mobile_App/Access_Guide/iOS.html)

```json
{
  "appID": "RJX3H8KBAF.com.pzrn.wechat.example",
  "paths": ["/app/passenger/*"]
}
```

### 测试配置是否成功

Safari 输入 Universal Links

```
https://h5.shundaojia.com/app/passenger/
```

### iOS

```objc
#import <RNWechat/RNWechat.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [RNWechat handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    return [RNWechat handleOpenUniversalLink:userActivity];
}

@end
```

### Android

```java
public class WXEntryActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        WechatModule.handleIntent(ReactBridgeManager.get().getCurrentReactContext(), getIntent());
        finish();
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        setIntent(intent);
        WechatModule.handleIntent(ReactBridgeManager.get().getCurrentReactContext(), getIntent());
        finish();
    }
}
```
