//
//  WeexCloteeAlipayModule.m
//  WeexPluginTemp
//
//  Created by  on 17/3/14.
//  Copyright © 2018年 . All rights reserved.
//

#import "WeexCloteeAlipayModule.h"
#import <WeexPluginLoader/WeexPluginLoader.h>
#import <AlipaySDK/AlipaySDK.h>

@interface WeexCloteeAlipayModule ()
@end

@implementation WeexCloteeAlipayModule
@synthesize weexInstance;

WX_PlUGIN_EXPORT_MODULE(Alipay, WeexCloteeAlipayModule)
WX_EXPORT_METHOD(@selector(pay::))
WX_EXPORT_METHOD(@selector(auth::))

+ (WeexCloteeAlipayModule *)singletonManger{
    static id manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}


// Pay

- (void)handlePay:(NSDictionary *)resultDic :(CloteeCallback)callback {
    NSLog(@"[nat] [alipay] [pay] reslut = %@", resultDic);
    
    NSString *status = resultDic[@"resultStatus"];
    NSString *memo = resultDic[@"memo"];
    NSString *result = resultDic[@"result"];
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSASCIIStringEncoding] options:kNilOptions error:nil];
    
    if ([status isEqual:@"9000"]) {
        callback(nil, data);
    } else {
        callback(@{@"error":@{@"msg":memo, @"code":status}}, nil);
    }
}

- (void)doPay:(NSDictionary *)options :(CloteeCallback)callback {
    NSString *info = options[@"info"];
    NSString *scheme = options[@"scheme"];
    
    [[AlipaySDK defaultService] payOrder:info fromScheme:scheme callback:^(NSDictionary *resultDic) {
        [self handlePay :resultDic :callback];
    }];
}

- (void)processPayResult:(NSURL *)url :(CloteeCallback)callback{
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [self handlePay :resultDic :callback];
        }];
    }
}


// Auth

- (void)handleAuth:(NSDictionary *)resultDic :(CloteeCallback)callback {
    NSLog(@"[nat] [alipay] [auth] result = %@", resultDic);
    
    NSString *status = resultDic[@"resultStatus"];
    NSString *memo = resultDic[@"memo"];
    NSString *result = resultDic[@"result"];
    NSString *authCode = nil;
    
    if ([status isEqual:@"9000"] && result.length > 0) {
        NSArray *resultArr = [result componentsSeparatedByString:@"&"];
        for (NSString *subResult in resultArr) {
            if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                authCode = [subResult substringFromIndex:10];
                break;
            }
        }
        callback(nil, @{@"authCode":authCode});
    } else {
        callback(@{@"error":@{@"msg":memo, @"code":status}}, nil);
    }
}

- (void)doAuth:(NSDictionary *)options :(CloteeCallback)callback{
    NSString *info = options[@"info"];
    NSString *scheme = options[@"scheme"];
    
    [[AlipaySDK defaultService] auth_V2WithInfo:info fromScheme:scheme callback:^(NSDictionary *resultDic) {
        [self handleAuth :resultDic :callback];
    }];
}

- (void)processAuthResult:(NSURL *)url :(CloteeCallback)callback{
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            [self handleAuth :resultDic :callback];
        }];
    }
}


- (void)pay:(NSDictionary *)params :(WXModuleKeepAliveCallback)callback{
    [[WeexCloteeAlipayModule singletonManger] doPay:params :^(id error,id result) {
        if (error) {
            if (callback) {
                callback(error, result);
            }
        } else {
            if (callback) {
                callback(error, result);
            }
        }
        
    }];
}

- (void)auth:(NSDictionary *)params :(WXModuleKeepAliveCallback)callback{
    [[WeexCloteeAlipayModule singletonManger] doAuth:params :^(id error,id result) {
        if (error) {
            if (callback) {
                callback(error,result);
            }
        } else {
            if (callback) {
                callback(error,result);
            }
        }
        
    }];
}

@end
