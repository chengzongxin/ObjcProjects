//
//  MQTTSessionUtil.h
//  Matafy
//
//  Created by Fussa on 2019/5/6.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MQTTClient/MQTTClient.h>
#import "MQTTConfig.h"

@class MQTTUtilTopicModel;
@interface MQTTSessionUtil : NSObject

/**
 订阅单个主题

 @param topic 主题
 @param identify 请求的标识id
 @param level 服务质量
 @param config 配置信息
 @param subscribeHandler 订阅回调
 @param handler 订阅的消息回调
 */
- (void)subscribeTopic:(NSString *)topic
             identify:(NSString *)identify
                   qos:(MQTTQosLevel)level
                config:(MQTTConfig *)config
      subscribeHandler:(MTFYMQTTSubscribeHandler)subscribeHandler
           dataHandler:(MTFYMQTTHandle)handler;

/**
 订阅多个主题
 
 @param topics 主题
 @param identify 请求的标识id
 @param level 服务质量
 @param config 配置信息
 @param subscribeHandler 订阅回调
 @param handler 订阅的消息回调
 */
- (void)subscribeTopics:(NSArray <NSString *> *)topics
               identify:(NSString *)identify
                    qos:(MQTTQosLevel)level
                 config:(MQTTConfig *)config
       subscribeHandler:(MTFYMQTTSubscribeHandler)subscribeHandler
            dataHandler:(MTFYMQTTHandle)handler;


/**
 判断是否订阅某个主题

 @param topic 主题
 @param identify 请求标识
 @return 是否订阅
 */
- (BOOL)hasSubscribeTopic:(NSString *)topic
                 identify:(NSString *)identify;

/**
 向主题发送消息

 @param payload 消息内容
 @param identify 请求的标识id
 @param topic 主题
 @param level 服务质量
 @param handle 发送回调
 */
- (void)publishData:(id)payload
            toTopic:(NSString *)topic
          identify:(NSString *)identify
             config:(MQTTConfig *)config
             retain:(BOOL)retain
                qos: (MQTTQosLevel)level
      publishHandle:(MTFYMQTTPublishHandler)handle;

/**
 取消订阅单个主题

 @param topic 主题
 @param identify 请求的标识id
 @param handle 取消回调
 */
- (void)unSubscribeTopic:(NSString *)topic
                identify:(NSString *)identify
                  handle:(MTFYMQTTUnsubscribeHandler)handle;

/**
 取消订阅多个主题
 
 @param topics 主题
 @param identify 请求的标识id
 @param handle 取消回调
 */
- (void)unSubscribeTopics:(NSArray<NSString *> *)topics
                 identify:(NSString *)identify
                   handle:(MTFYMQTTUnsubscribeHandler)handle;


/**
 连接服务

 @param identify 连接标识
 */
- (void)connectWithIdentify:(NSString *)identify
              connectHandle:(MTFYMQTTConnectHandler)handle;

/**
 关闭连接
 
 @param identify 连接标识
 */
- (void)closeWithIdentify:(NSString *)identify
              closeHandle:(MTFYMQTTDisconnectHandler)handle;

/**
 关闭所有连接(谨慎使用, 会断开所有MQTT连接)
 */
- (void)closeAll;


/**
 注册代理对象

 @param obj 需要实现代理的对象
 @param identify 连接标识
 */
-(void)registerDelegate:(id)obj
               identify:(NSString *)identify;


/**
 接触代理对象

 @param identify 连接标识
 */
-(void)unregisterWithIdentify:(NSString *)identify;


@end
