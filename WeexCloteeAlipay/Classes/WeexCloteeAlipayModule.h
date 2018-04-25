//
//  WeexCloteeAlipayModule.h
//  WeexPluginTemp
//
//  Created by 齐山 on 17/3/14.
//  Copyright © 2018年 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WeexSDK/WeexSDK.h>

@protocol CloteeAlipayPro <WXModuleProtocol>

- (void)pay:(NSDictionary *)params :(WXModuleKeepAliveCallback)callback;
- (void)auth:(NSDictionary *)params :(WXModuleKeepAliveCallback)callback;

@end
@interface WeexCloteeAlipayModule :NSObject <WXModuleProtocol>
typedef void (^CloteeCallback)(id error, id result);

+ (WeexCloteeAlipayModule *)singletonManger;

- (void)doPay:(NSDictionary *)options :(CloteeCallback)callBack;
- (void)processPayResult:(NSURL *)url :(CloteeCallback)callBack;

- (void)doAuth:(NSDictionary *)options :(CloteeCallback)callBack;
- (void)processAuthResult:(NSURL *)url :(CloteeCallback)callBack;
@end
