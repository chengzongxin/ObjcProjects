//
//  MQTTUtilModel.h
//  Matafy
//
//  Created by Fussa on 2019/5/7.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MQTTClient/MQTTClient.h>
#import "MQTTConfig.h"


@class MQTTBaseModel;
@class MQTTUtilTopicModel;

@protocol MQTTSessionUtilDelegate <NSObject>
@optional
- (void)session:(MQTTSession *)session handleEvent:(MQTTSessionEvent)eventCode error:(NSError *)error;
- (void)session:(MQTTSession *)session newMessage:(MQTTBaseModel *)data onTopic:(NSString *)topic;
- (void)sessionConnected:(MQTTSession*)session;
- (void)sessionConnectionClosed:(MQTTSession*)session;
- (void)session:(MQTTSession *)session connectionError:(NSError *)error;

@end

@interface MQTTUtilModel : NSObject
/// 主题数组
@property (nonatomic, strong) NSArray<MQTTUtilTopicModel *> *topics;
/// session配置
@property (nonatomic, strong) MQTTConfig *config;
/// 连接session
@property (nonatomic, strong) MQTTSession *session;
/// 连接标识
@property (nonatomic, copy) NSString *identify;
/// 代理对象
@property (nonatomic, weak) id<MQTTSessionUtilDelegate> delegate;


+ (instancetype)modelWithTopic:(NSString *)topic
                      identify:(NSString *)identify
                         level:(MQTTQosLevel)level
                       session:(MQTTSession *)session
                        config:(MQTTConfig *)config
                        handle: (MTFYMQTTHandle)handle;

+ (instancetype)modelWithTopics:(NSArray<NSString *> *)topics
                       identify:(NSString *)identify
                         level:(MQTTQosLevel)level
                        session:(MQTTSession *)session
                         config:(MQTTConfig *)config
                        handle: (MTFYMQTTHandle)handle;


+ (instancetype)modelWithIdentify:(NSString *)identify;

- (void)addTopic:(NSString *)topic level:(MQTTQosLevel)level handle:(MTFYMQTTHandle)handle;
- (void)removeTopic:(NSString *)topic;

@end

@interface MQTTUtilTopicModel : NSObject
/// 话题内容
@property (nonatomic, copy) NSString *topic;
/// 服务质量(qos)
@property (nonatomic, assign) MQTTQosLevel level;
/// 消息回调
@property (nonatomic, copy) MTFYMQTTHandle handle;

+ (instancetype)modelWithTopic:(NSString *)topic qosLevel:(MQTTQosLevel)level handle:(MTFYMQTTHandle)handle;
@end

