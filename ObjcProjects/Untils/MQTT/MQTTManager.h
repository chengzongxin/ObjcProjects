//
//  MQTTManager.h
//  Matafy
//
//  Created by Fussa on 2019/5/6.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQTTConfig.h"
#import "MQTTSessionUtil.h"
#import "MQTTBaseModel.h"
#import "MQTTUtilModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MQTTManager : NSObject

/// 单例
+ (MQTTManager *)sharedInstance;


/**
 订阅单个主题

 @param topic 主题
 @param identify 标识实体
 @param type 权限类型
 @param level 服务质量
 @param cleanSession 是否保存主题, 若否, 客户端掉线后,主题将清除
 @param subscribeHandler 订阅回调
 @param handler 消息回调
 */
- (void)subscribeTopic:(NSString *)topic
              identify:(NSString *)identify
                  type:(MQTTAuthType)type
                   qos:(MQTTQosLevel)level
          cleanSession:(BOOL)cleanSession
      subscribeHandler:(nullable MTFYMQTTSubscribeHandler)subscribeHandler
           dataHandler:(nullable MTFYMQTTHandle)handler;

/**
 订阅多个主题
 
 @param topics 主题
 @param identify 标识实体
 @param type 权限类型
 @param level 服务质量
 @param cleanSession 是否保存主题, 若否, 客户端掉线后,主题将清除
 @param subscribeHandler 订阅回调
 @param handler 消息回调
 */
- (void)subscribeTopics:(NSArray <NSString *> *)topics
               identify:(NSString *)identify
                   type:(MQTTAuthType)type
                    qos:(MQTTQosLevel)level
           cleanSession:(BOOL)cleanSession
       subscribeHandler:(nullable MTFYMQTTSubscribeHandler)subscribeHandler
            dataHandler:(nullable MTFYMQTTHandle)handler;

/**
 订阅单个主题(无Block回调)
 
 @param topic 主题
 @param identify 标识实体
 @param type 权限类型
 @param level 服务质量
 @param cleanSession 是否保存主题, 若否, 客户端掉线后,主题将清除
 */
- (void)subscribeTopic:(NSString *)topic
              identify:(NSString *)identify
                  type:(MQTTAuthType)type
                   qos:(MQTTQosLevel)level
          cleanSession:(BOOL)cleanSession;


/**
 判断是否订阅某个主题
 
 @param topic 主题
 @param identify 请求标识
 @return 是否订阅
 */
- (BOOL)hasSubscribeTopic:(NSString *)topic
                 identify:(NSString *)identify;

/**
 取消订阅单个主题
 
 @param topic 主题
 @param identify 标识实体
 @param handle 取消回调
 */
- (void)unSubscribeTopic:(NSString *)topic
                identify:(NSString *)identify
                  handle:(nullable MTFYMQTTUnsubscribeHandler)handle;

/**
 取消订阅多个主题
 
 @param topics 主题
 @param identify 标识实体
 @param handle 取消回调
 */
- (void)unSubscribeTopics:(NSArray<NSString *> *)topics
                 identify:(NSString *)identify
                   handle:(nullable MTFYMQTTUnsubscribeHandler)handle;


/**
 向主题发消息

 @param param 消息内容
 @param topic 主题
 @param identify 标识实体
 @param type 权限类型
 @param level 服务质量
 @param cleanSession 是否保存主题
 @param handle 发送消息回调
 */
- (void)publishData:(NSDictionary *)param
            toTopic:(NSString *)topic
           identify:(NSString *)identify
             retain:(BOOL)retain
               type:(MQTTAuthType)type
                qos:(MQTTQosLevel)level
       cleanSession:(BOOL)cleanSession
      publishHandle:(nullable MTFYMQTTPublishHandler)handle;

/**
 连接服务
 
 @param identify 连接标识
 */
- (void)connectWithIdentify:(NSString *)identify
              connectHandle:(nullable MTFYMQTTConnectHandler)handle;

/**
 关闭连接

 @param identify 连接标识
 */
- (void)closeWithIdentify:(NSString *)identify
              closeHandle:(nullable MTFYMQTTDisconnectHandler)handle;;

/**
 关闭所有连接(谨慎使用, 会断开所有MQTT连接)
 */
- (void)closeAll;

/**
 注册代理对象
 
 @param obj 需要实现代理的对象
 */
-(void)registerDelegate:(NSObject *)obj;


/**
 解除代理对象
 
 @param obj 实现代理的对象
 */
-(void)unregisterDelegate:(NSObject *)obj;

@end

NS_ASSUME_NONNULL_END
