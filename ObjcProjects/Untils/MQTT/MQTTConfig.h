//
//  MQTTConfig.h
//  Matafy
//
//  Created by Fussa on 2019/5/7.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MQTTBaseModel;

/// 权限级别
typedef NS_ENUM(NSUInteger, MQTTAuthType) {
    MQTTAuthTypePublic    = 0, ///< 公开
    MQTTAuthTypeProtect   = 1, ///< 保护级别，只有认证用户才能访问。
    MQTTAuthTypePrivate   = 2, ///< 用于用户数据权限的主题保护，用户只能订单自身ID下面的主题(暂时不支持)
};

typedef void (^MTFYMQTTSubscribeHandler)(NSString *topic, NSError *error, NSArray<NSNumber *> *gQoss);
typedef void (^MTFYMQTTUnsubscribeHandler)(NSString *topic, NSError *error);
typedef void (^MTFYMQTTPublishHandler)(NSString *topic, NSError *error);
typedef void (^MTFYMQTTConnectHandler)(NSError *error);
typedef void (^MTFYMQTTDisconnectHandler)(NSError *error);
typedef void (^MTFYMQTTHandle)(MQTTBaseModel *data, NSString *topic);

@interface MQTTConfig : NSObject
@property (nonatomic, copy) NSString *host;
@property (nonatomic, assign) UInt32 port;
@property (nonatomic, copy) NSString *clientId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *passWord;
@property (nonatomic, assign) NSTimeInterval timeout;


/********* 默认值 **********/
+ (NSString *)host;
+ (UInt32)port;
+ (NSString *)getClientID;
+ (NSString *)getUserName:(BOOL)isPublic;
+ (NSString *)getPassword:(BOOL)isPublic;
+ (NSTimeInterval)subcribeTimeout;

/// 判断是否相等
- (BOOL)isEqualToConfig:(MQTTConfig *)config;
@end


