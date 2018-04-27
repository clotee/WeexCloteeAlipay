//
//  WeexCloteeAlipay.m
//  WeexDemo
//
//  Created by star diao on 2018/4/27.
//  Copyright © 2018年 taobao. All rights reserved.
//

#import "WeexCloteeAlipay.h"
#import <WeexPluginLoader/WeexPluginLoader.h>
#import <AlipaySDK/AlipaySDK.h>

@interface WeexCloteeAlipay ()
@end

@implementation WeexCloteeAlipay
@synthesize weexInstance;

WX_PlUGIN_EXPORT_MODULE(Alipay, WeexCloteeAlipay)
WX_EXPORT_METHOD(@selector(pay::))
WX_EXPORT_METHOD(@selector(auth::))

+ (WeexCloteeAlipay *)singletonManger{
    static id manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)cl_alipayWithOrderStr:(NSString *)orderStr appScheme:(NSString *)appScheme{
    NSAssert(orderStr, @"订单信息不能为空！");
    NSAssert(appScheme, @"scheme 不能为空并且要和info配置中一样！");
    [[AlipaySDK defaultService] payOrder:orderStr fromScheme:appScheme callback:^(NSDictionary *resultDic){
        if ([WeexCloteeAlipay singletonManger].cl_callback) {
            [WeexCloteeAlipay singletonManger].cl_callback(resultDic);
        }
    }];
    
}


- (void)cl_alipayWithOrderStr:(NSString *)orderStr appScheme:(NSString *)appScheme callBack:(CloteeCallback)callBack{
    self.cl_callback = callBack;
    [self cl_alipayWithOrderStr:orderStr appScheme:appScheme];
}


- (void)pay:(NSDictionary *)params :(WXModuleKeepAliveCallback)callback{
    NSString *info = params[@"info"];
    NSString *scheme = params[@"scheme"];
    [[WeexCloteeAlipay singletonManger] cl_alipayWithOrderStr:info appScheme:scheme];
    [WeexCloteeAlipay singletonManger].cl_callback = ^(NSDictionary *result){
        if ([result[@"resultStatus"] isEqualToString:@"9000"]){
            NSLog(@"支付成功 %@", result);
            callback(result, NO);
        }
        else{
            NSLog(@"支付失败 %@",result);
            callback(result, NO);
        }
    };
    
    
    NSLog(@"支付失败");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipaySuccess:) name:@"Notification_AlipaySuccess" object:nil];
    NSLog(@"自己 %@", self);
}


- (void) alipaySuccess: (NSNotification*) aNotification
{
    NSDictionary *userProfile = [aNotification object];
    NSLog(@"回到啦 %@", userProfile);
    [WeexCloteeAlipay singletonManger].cl_callback(userProfile);
}

- (void)cl_alipayWithUrl:(NSURL *)url{
    NSAssert(url, @"url地址不能为空！");
    // 支付跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"回调%@", resultDic);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_AlipaySuccess" object:resultDic];
        // 添加观察者
        
    }];
}

@end
