//
//  MQTTConfig.m
//  Matafy
//
//  Created by Fussa on 2019/5/7.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MQTTConfig.h"
#import "MQTTConst.h"
#import <UIKit/UIKit.h>

@implementation MQTTConfig

+(NSString *)host {
    return MQTT_HOST;
}

+ (UInt32)port {
    return MQTT_PORT;
}

+ (NSString *)getClientID {
    /*
     格式: /应用代号/业务线代号/客户端类型代号/客户端版本/客户端ID/业务用户id
     ios: /mtfy/default/ios/v5.2.3/ejfoewurer3fewref
     */
    
    // 应用代号
    NSString *code = @"mtfy";
    // 业务线代码
    NSString *businessCode = @"default";
    // 客户端类型
    NSString *client = @"ios";
    // APP版本号
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    // 客户端唯一标识
    NSString *udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    // 用户ID
//    NSString *userId = @"";

//    if (!NULLString([User sharedInstance].userId)) {
//        userId = [User sharedInstance].userId;
//    }

//    NSString *uuid = [NSString uuidString];

    NSString *clientId = [NSString stringWithFormat:@"/%@/%@/%@/v%@/%@", code, businessCode, client, appVersion, udid];

    // 用户ID(可选)
//    if (!NULLString(userId)) {
//        clientId = [clientId stringByAppendingFormat:@"/%@", userId];
//    }
    return clientId;
}

+ (NSString *)getUserName:(BOOL)isPublic {
    /*
     public: 用于不需要登陆的场景。
     token: 用户需要登陆后的场景
     */
    return isPublic ? @"public" : @"token";
}

+ (NSString *)getPassword:(BOOL)isPublic {
    /*
     当Username为public时，为public账户的密码，当前密码也是: public
     当Username为token时，统一填写JWT规范的token值
     */
    return isPublic ? @"public" : @"token";
}

+ (NSTimeInterval)subcribeTimeout {
    return 3;
}

- (BOOL)isEqualToConfig:(MQTTConfig *)config {
    return [self.host isEqualToString:config.host]
    && self.port == config.port
    && [self.clientId isEqualToString:config.clientId]
    && [self.userName isEqualToString:config.userName]
    && [self.passWord isEqualToString:config.passWord]
    && self.timeout == config.timeout;
}

@end
