//
//  WeexCloteeAlipay.h
//  WeexDemo
//
//  Created by star diao on 2018/4/27.
//  Copyright © 2018年 taobao. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <WeexSDK/WeexSDK.h>

@protocol AlipayCallback <WXModuleProtocol>
- (void)pay:(NSDictionary *)params :(WXModuleKeepAliveCallback)callback;
- (void)auth:(NSDictionary *)params :(WXModuleKeepAliveCallback)callback;

@end

typedef void(^CloteeCallback)(NSDictionary *resultDic);

@interface WeexCloteeAlipay :NSObject <WXModuleProtocol>
@property (nonatomic,copy)CloteeCallback cl_callback;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger i;
@property (nonatomic, weak) id<NSObject> observer;


typedef void (^AlipayCallback)(id error, id result);
+ (WeexCloteeAlipay *)singletonManger;
/**
 *  @author star diao
 *
 *  支付宝授权支付-AppDelegate中实现
 */

- (void)cl_alipayWithUrl:(NSURL *)url;

/**
 *  @author star diao
 *
 *  发起支付，任意地方
 */
- (void)cl_alipayWithOrderStr:(NSString *)orderStr appScheme:(NSString *)appScheme;

/**
 *  @author star diao
 *
 *  发起支付，带支付后回调
 */
- (void)cl_alipayWithOrderStr:(NSString *)orderStr appScheme:(NSString *)appScheme callBack:(CloteeCallback)callBack;
@end
