//
//  WeexCloteeAlipayModule.h
//  WeexPluginTemp
//
//  Created by 齐山 on 17/3/14.
//  Copyright © 2018年 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WeexSDK/WeexSDK.h>

@protocol NatAlipayPro <WXModuleProtocol>

- (void)pay:(NSDictionary *)params :(WXModuleKeepAliveCallback)callback;
- (void)auth:(NSDictionary *)params :(WXModuleKeepAliveCallback)callback;

@end
@interface WeexCloteeAlipayModule :NSObject <WXModuleProtocol>

@end
