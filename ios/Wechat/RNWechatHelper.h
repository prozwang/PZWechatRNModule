//
//  RNWechatHelper.h
//  RNWechat
//
//  Created by Proz on 2019/12/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RNPromise;

@interface RNWechatHelper : NSObject

+ (instancetype)sharedHelper;

- (BOOL)handleOpenURL:(NSURL *)url;

- (BOOL)handleOpenUniversalLink:(NSUserActivity *)userActivity;

- (void)sendAuthRequestWithPromise:(RNPromise *)promise;

- (void)payWithData:(NSDictionary *)data promise:(RNPromise *)promise;

@end

NS_ASSUME_NONNULL_END
