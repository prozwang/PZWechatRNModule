#import "RNWechat.h"
#import "RNWechatHelper.h"
#import <WechatOpenSDK/WXApi.h>
#import "RNPromise.h"

@implementation RNWechat

+ (BOOL)handleOpenURL:(NSURL *)url {
    return [[RNWechatHelper sharedHelper] handleOpenURL:url];
}

+ (BOOL)handleOpenUniversalLink:(NSUserActivity *)userActivity {
    return [[RNWechatHelper sharedHelper] handleOpenUniversalLink:userActivity];
}

+ (BOOL)requiresMainQueueSetup {
    return YES;
}

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

// 注册
RCT_EXPORT_METHOD(registerApp:(NSString *)appId universalLink:(NSString *)link resolver: (RCTPromiseResolveBlock)resolve rejector: (RCTPromiseRejectBlock)reject) {
    //wxe53bb10022a9f0c7
    //https://h5.shundaojia.com/app/passenger/wechat/
    resolve(@([WXApi registerApp:appId universalLink:link]));
}

// 检查是否已经安装微信
RCT_EXPORT_METHOD(isWXAppInstalled:(RCTPromiseResolveBlock)resolve rejector: (RCTPromiseRejectBlock)reject) {
    resolve(@([WXApi isWXAppInstalled]));
}

// 请求登录 code
RCT_EXPORT_METHOD(sendAuthRequest:(RCTPromiseResolveBlock)resolve rejector: (RCTPromiseRejectBlock)reject) {
    [[RNWechatHelper sharedHelper] sendAuthRequestWithPromise:[RNPromise promiseWithResolveBlock:resolve rejectBlock:reject]];
}

// 支付
RCT_EXPORT_METHOD(pay:(NSDictionary *)data resolver:(RCTPromiseResolveBlock)resolve rejector: (RCTPromiseRejectBlock)reject) {
    [[RNWechatHelper sharedHelper] payWithData:data promise:[RNPromise promiseWithResolveBlock:resolve rejectBlock:reject]];
}

@end
