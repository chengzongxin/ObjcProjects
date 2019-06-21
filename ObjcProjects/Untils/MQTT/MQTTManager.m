//
//  MQTTManager.m
//  Matafy
//
//  Created by Fussa on 2019/5/6.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MQTTManager.h"
#import <MQTTClient/MQTTClient.h>
#import "MQTTSessionUtil.h"

@interface MQTTManager()
@property (nonatomic, assign) BOOL isPublic;
@property (nonatomic, strong) MQTTSessionUtil *mqttUtil;


@end
@implementation MQTTManager

// GCD单例
+ (MQTTManager *)sharedInstance {
    static MQTTManager *__singletion = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __singletion = [[self alloc] init];
    });
    return __singletion;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initVector];
    }
    return self;
}

- (void)initVector {
    self.mqttUtil = [[MQTTSessionUtil alloc] init];
}


/**
 session配置数据
 */
- (MQTTConfig *)creatMQTTConfig:(MQTTAuthType)type cleanSession:(BOOL)cleanSession {
    MQTTConfig *config = [[MQTTConfig alloc] init];
    config.host = [MQTTConfig host];
    config.port = [MQTTConfig port];
    config.clientId = [MQTTConfig getClientID];
    BOOL isPublic = type == MQTTAuthTypePublic;
    config.userName = [MQTTConfig getUserName:isPublic];
    config.passWord = [MQTTConfig getPassword:isPublic];
    config.timeout = [MQTTConfig subcribeTimeout];
    return config;
}

#pragma mark - Pirvate

#pragma mark - Public
/// 订阅主题
- (void)subscribeTopic:(NSString *)topic identify:(NSString *)identify type:(MQTTAuthType)type qos:(MQTTQosLevel)level cleanSession:(BOOL)cleanSession subscribeHandler:(MTFYMQTTSubscribeHandler)subscribeHandler dataHandler:(MTFYMQTTHandle)handler {
    MQTTConfig *config = [self creatMQTTConfig:type cleanSession:cleanSession];
    [self.mqttUtil subscribeTopic:topic identify:identify qos:level config:config subscribeHandler:subscribeHandler dataHandler:handler];
}

/// 订阅多个主题
- (void)subscribeTopics:(NSArray <NSString *> *)topics identify:(NSString *)identify type:(MQTTAuthType)type qos:(MQTTQosLevel)level cleanSession:(BOOL)cleanSession subscribeHandler:(MTFYMQTTSubscribeHandler)subscribeHandler dataHandler:(MTFYMQTTHandle)handler{
    MQTTConfig *config = [self creatMQTTConfig:type cleanSession:cleanSession];
    [self.mqttUtil subscribeTopics:topics identify:identify qos:level config:config subscribeHandler:subscribeHandler dataHandler:handler];
}

/// 订阅主题
- (void)subscribeTopic:(NSString *)topic identify:(NSString *)identify type:(MQTTAuthType)type qos:(MQTTQosLevel)level cleanSession:(BOOL)cleanSession {
    [self subscribeTopic:topic identify:identify type:type qos:level cleanSession:cleanSession subscribeHandler:nil dataHandler:nil];
}

/// 检查是否判断
- (BOOL)hasSubscribeTopic:(NSString *)topic identify:(NSString *)identify {
    return [self.mqttUtil hasSubscribeTopic:topic identify:identify];
}

/// 取消订阅
- (void)unSubscribeTopic:(NSString *)topic identify:(NSString *)identify handle:(MTFYMQTTUnsubscribeHandler)handle {
    [self.mqttUtil unSubscribeTopic:topic identify:identify handle:handle];
}

/// 取消多个订阅
- (void)unSubscribeTopics:(NSArray<NSString *> *)topics identify:(NSString *)identify handle:(MTFYMQTTUnsubscribeHandler)handle {
    [self.mqttUtil unSubscribeTopics:topics identify:identify handle:handle];
}

/// 发送消息
- (void)publishData:(NSDictionary *)param toTopic:(NSString *)topic identify:(NSString *)identify retain:(BOOL)retain type:(MQTTAuthType)type qos:(MQTTQosLevel)level cleanSession:(BOOL)cleanSession publishHandle:(MTFYMQTTPublishHandler)handle {
    MQTTConfig *config = [self creatMQTTConfig:type cleanSession:cleanSession];
    [self.mqttUtil publishData:param toTopic:topic identify:identify config:config retain:retain qos:level publishHandle:handle];
}

/// 连接服务
- (void)connectWithIdentify:(NSString *)identify connectHandle:(MTFYMQTTConnectHandler)handle {
    [self.mqttUtil connectWithIdentify:identify connectHandle:handle];
}

/// 关闭连接
- (void)closeWithIdentify:(NSString *)identify closeHandle:(nullable MTFYMQTTDisconnectHandler)handle {
    [self.mqttUtil closeWithIdentify:identify closeHandle:handle];
}

/// 关闭所有连接
- (void)closeAll {
    [self.mqttUtil closeAll];
}

/// 注册代理
- (void)registerDelegate:(NSObject *)obj {
    [self.mqttUtil registerDelegate:obj identify:NSStringFromClass([obj class])];
}

/// 解除代理
- (void)unregisterDelegate:(NSObject *)obj {
    [self.mqttUtil unregisterWithIdentify:NSStringFromClass([obj class])];
    
}

@end
