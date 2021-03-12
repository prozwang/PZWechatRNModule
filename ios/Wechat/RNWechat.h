#import <React/RCTBridgeModule.h>

@interface RNWechat : NSObject <RCTBridgeModule>

+ (BOOL)handleOpenURL:(NSURL *)url;

+ (BOOL)handleOpenUniversalLink:(NSUserActivity *)userActivity;

@end
