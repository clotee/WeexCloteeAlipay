//
//  WeexCloteeAlipayModule.h
//  Pods-WeexCloteeAlipay_Example
//
//  Created by star diao on 2018/4/24.
//


#import <Foundation/Foundation.h>
#import <WeexSDK/WeexSDK.h>

@protocol NatAlipayPro <WXModuleProtocol>

- (void)pay:(NSDictionary *)params :(WXModuleCallback)callback;
- (void)auth:(NSDictionary *)params :(WXModuleCallback)callback;

@end
@interface WeexCloteeAlipayModule :NSObject <WXModuleProtocol>

@end

