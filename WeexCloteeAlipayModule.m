//
//  WeexCloteeAlipayModule.m
//  WeexPluginTemp
//
//  Created by  on 17/3/14.
//  Copyright © 2017年 . All rights reserved.
//

#import "WeexCloteeAlipayModule.h"
#import <WeexPluginLoader/WeexPluginLoader.h>
#import <NatAlipay/NatAlipay.h>

@implementation WeexCloteeAlipayModule
@synthesize weexInstance;

WX_PlUGIN_EXPORT_MODULE(weexCloteeAlipay, WeexCloteeAlipayModule)
WX_EXPORT_METHOD(@selector(pay::))
WX_EXPORT_METHOD(@selector(auth::))

- (void)pay:(NSDictionary *)params :(WXModuleCallback)callback{
    [[NatAlipay singletonManger] pay:params :^(id error,id result) {
        if (error) {
            if (callback) {
                callback(error);
            }
        } else {
            if (callback) {
                callback(result);
            }
        }
        
    }];
}

- (void)auth:(NSDictionary *)params :(WXModuleCallback)callback{
    [[NatAlipay singletonManger] auth:params :^(id error,id result) {
        if (error) {
            if (callback) {
                callback(error);
            }
        } else {
            if (callback) {
                callback(result);
            }
        }
        
    }];
}

@end