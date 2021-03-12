//
//  RNWechatHelper.m
//  RNWechat
//
//  Created by Proz on 2019/12/5.
//

#import "RNWechatHelper.h"
#import <WechatOpenSDK/WXApi.h>
#import <React/RCTLog.h>
#import <RNPromise/RNPromise.h>

@interface RNWechatHelper () <WXApiDelegate>

@property(nonatomic, strong, readonly) NSMutableDictionary *promises;

@end

@implementation RNWechatHelper

+ (instancetype)sharedHelper {
    static dispatch_once_t onceToken;
    static RNWechatHelper *helper;
    dispatch_once(&onceToken, ^{
        helper = [[RNWechatHelper alloc] init];
    });
    return helper;
}

- (instancetype)init {
    if (self = [super init]) {
        _promises = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)handleReload {
    [self.promises removeAllObjects];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)handleOpenUniversalLink:(NSUserActivity *)userActivity {
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}

- (void)sendAuthRequestWithPromise:(RNPromise *)promise {
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    [self.promises setObject:promise forKey:req.state];
    [WXApi sendReq:req completion:^(BOOL success) {
        if (!success) {
            RNPromise *promise = [self.promises objectForKey:req.state];
            if (promise) {
                promise.reject(@"-1", @"请求微信登录失败", nil);
                [self.promises removeObjectForKey:req.state];
            }
        }
        RCTLogInfo(@"请求微信登录结果：%d", success);
    }];
}

- (void)payWithData:(NSDictionary *)data promise:(RNPromise *)promise {
    PayReq* req             = [PayReq new];
    req.partnerId           = data[@"partnerId"];
    req.prepayId            = data[@"prepayId"];
    req.nonceStr            = data[@"nonceStr"];
    req.timeStamp           = [data[@"timeStamp"] unsignedIntValue];
    req.package             = data[@"package"];
    req.sign                = data[@"sign"];
    [self.promises setObject:promise forKey:@"pay"];
    [WXApi sendReq:req completion:^(BOOL success) {
        // RNPromise *promise = [self.promises objectForKey:@"pay"];
        // if (promise) {
        //     promise.reject(@"-1", @"微信支付失败", nil);
        //     [self.promises removeObjectForKey:@"pay"];
        // }
        RCTLogInfo(@"请求微信支付结果：%d", success);
    }];
}

- (void)onReq:(BaseReq *)req {
     
}

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        [self handleAuthResp:(SendAuthResp *)resp];
    } else if ([resp isKindOfClass:[PayResp class]]) {
        [self handlePayResp:(PayResp *)resp];
    }
}
         
- (void)handlePayResp:(PayResp *)resp {
    RNPromise *promise = [self.promises objectForKey: @"pay"];
    if (promise) {
        if (resp.errCode == WXSuccess) {
            promise.resolve(resp.returnKey ?: NSNull.null);
        } else {
            if (resp.errCode == -2 && !resp.errStr) {
                promise.reject([NSString stringWithFormat:@"%d", resp.errCode], @"取消支付", nil);
            } else{
                promise.reject([NSString stringWithFormat:@"%d", resp.errCode], resp.errStr, nil);
            }
        }
    }
}

- (void)handleAuthResp:(SendAuthResp *)resp {
    RNPromise *promise = [self.promises objectForKey: resp.state];
    if (promise) {
        if (resp.errCode == WXSuccess) {
            promise.resolve(resp.code);
        } else {
            promise.reject([NSString stringWithFormat:@"%d", resp.errCode], resp.errStr, nil);
        }
    }
}


@end
