//
//  MQTTSessionUtil.m
//  Matafy
//
//  Created by Fussa on 2019/5/6.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MQTTSessionUtil.h"
#import "MQTTBaseModel.h"
#import "MQTTUtilModel.h"
#import <MJExtension.h>

@interface MQTTSessionUtil()<MQTTSessionDelegate>

/**
 注:
 
 数组中
 1. identify与config都相同, 则session使用同一个
 2. 每个session唯一, 不重复
 */
@property (nonatomic, strong) NSMutableArray<MQTTUtilModel *> *modelArray;
/// 上一个网络连通状态
@property (nonatomic, assign) BOOL preNetworkingReachable;

@end
@implementation MQTTSessionUtil

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initVector];
    }
    return self;
}
- (void)initVector {
    // 设置日志级别
    [MQTTLog setLogLevel:DDLogLevelWarning];
    self.modelArray = [NSMutableArray array];
    self.preNetworkingReachable = YES;
    [self addNetworkingChangeObserver];
}

- (MQTTSession *)createSession:(MQTTConfig *)config {
    MQTTCFSocketTransport *transport = [[MQTTCFSocketTransport alloc] init];
    transport.host = config.host;
    transport.port = config.port;
    //transport.tls = YES; //  根据需要配置  YES 开起 SSL 验证 此处为单向验证 双向验证 根据SDK 提供方法直接添加
    
    MQTTSession *session = [[MQTTSession alloc] init];
    session.cleanSessionFlag = NO;
    session.transport = transport;
    session.clientId = config.clientId;
    session.delegate = self;
    session.userName = config.userName;
    session.password = config.passWord;

    // 链接并设置超时时间
//    [session connectAndWaitTimeout:config.timeout];
    return session;
}

#pragma mark - Public
/// 订阅主题
- (void)subscribeTopic:(NSString *)topic identify:(NSString *)identify qos:(MQTTQosLevel)level config:(MQTTConfig *)config subscribeHandler:(MTFYMQTTSubscribeHandler)subscribeHandler dataHandler:(MTFYMQTTHandle)handler {
    
    MQTTUtilModel *model = [self fetchModelWithIdentify:identify config:config];
    if (!model) {
        // 创建新订阅
        MQTTSession *session = [self createSession:config];
        model = [MQTTUtilModel modelWithTopic:topic identify:identify level:level session:session config:config handle:handler];
        [self.modelArray addObject:model];
        [session connectWithConnectHandler:^(NSError *error) {
            if (error) {
                NSLog(@"链接失败, error: %@", error.description);
            } else {
                NSLog(@"连接成功!");
                [self subscribeToTopic:topic session:model.session atLevel:level subscribeHandler:subscribeHandler];
            }
        }];
    } else {
        [model addTopic:topic level:level handle:handler];
        [self subscribeToTopic:topic session:model.session atLevel:level subscribeHandler:subscribeHandler];
    }
}

/// 订阅多个主题
- (void)subscribeTopics:(NSArray <NSString *> *)topics identify:(NSString *)identify qos:(MQTTQosLevel)level config:(MQTTConfig *)config subscribeHandler:(MTFYMQTTSubscribeHandler)subscribeHandler dataHandler:(MTFYMQTTHandle)handler{
    NSLog(@"\n************订阅主题************:\n topic: %@\n qosLevel: %d\n host: %@\n port: %d\n cliendId: %@\n username: %@\n password:%@\n timeout: %f\n", topics, level, config.host, config.port, config.clientId, config.userName, config.passWord, config.timeout);

    MQTTUtilModel *model = [self fetchModelWithIdentify:identify config:config];
    if (!model) {
        // 创建新订阅
        MQTTSession *session = [self createSession:config];
        model = [MQTTUtilModel modelWithTopics:topics identify:identify level:level session:session config:config handle:handler];
        [self.modelArray addObject:model];
        [session connectWithConnectHandler:^(NSError *error) {
            if (error) {
                NSLog(@"链接失败, error: %@", error.description);
            } else {
                NSLog(@"连接成功!");
                for (NSString *topic in topics) {
                    [self subscribeToTopic:topic session:model.session atLevel:level subscribeHandler:subscribeHandler];
                }
            }
        }];
    } else {
        for (NSString *topic in topics) {
            [model addTopic:topic level:level handle:handler];
            [self subscribeToTopic:topic session:model.session atLevel:level subscribeHandler:subscribeHandler];
        }
    }
}

/// 判断是否订阅
- (BOOL)hasSubscribeTopic:(NSString *)topic identify:(NSString *)identify {
    return [self fetchSessionWithTopic:topic identify:identify];
}

/// 发送消息
- (void)publishData:(id)payload toTopic:(NSString *)topic identify:(NSString *)identify config:(MQTTConfig *)config retain:(BOOL)retain qos:(MQTTQosLevel)level publishHandle:(MTFYMQTTPublishHandler)handle {
    NSData *data = [NSJSONSerialization dataWithJSONObject:payload options:0 error:nil];
    MQTTSession *session = [self fetchSessionWithTopic:topic identify:identify config:config];
    // 未订阅, 返回错误
    if (!session) {
        if (handle) {
            NSError *error = [NSError errorWithDomain:MQTTSessionErrorDomain code:MQTTSessionEventConnectionError userInfo:@{NSLocalizedDescriptionKey:@"topic未订阅"}];
            handle(topic, error);
        }
        return;
    };
    [session publishData:data onTopic:topic retain:retain qos:level publishHandler:^(NSError *error) {
        if (handle) {
            handle(topic, error);
        }
    }];
}


/// 取消订阅
- (void)unSubscribeTopic:(NSString *)topic identify:(NSString *)identify handle:(MTFYMQTTUnsubscribeHandler)handle {
    MQTTSession *session = [self fetchSessionWithTopic:topic identify:identify];
    if (!session) {
        return;
    }
    MQTTUtilModel *model = [self fetchModelWithSession:session];
    [session unsubscribeTopic:topic unsubscribeHandler:^(NSError *error) {
        if (error) {
            NSLog(@"取消订阅错误, error: %@", error.description);
            if (handle) {
                handle(topic, error);
            }
        } else {
            if (handle) {
                handle(topic, nil);
            }
            NSLog(@"取消订阅成功, topic: %@", topic);
            // 移除当前主题
            [model removeTopic:topic];
            // 若该model下主题为空, 则断开连接并移除
            if (!model.topics.count) {
                [session closeWithDisconnectHandler:^(NSError *error) {
                    if (error) {
                        NSLog(@"断开连接错误, error: %@", error.description);
                    } else {
                        [self.modelArray removeObject:model];
                    }
                }];
            } else {
                if (handle) {
                    handle(topic, nil);
                }
            }
        }
    }];
}

/// 取消多个订阅主题
- (void)unSubscribeTopics:(NSArray<NSString *> *)topics identify:(NSString *)identify handle:(MTFYMQTTUnsubscribeHandler)handle {
    for (NSString *topic in topics) {
        BOOL hasSub = [self hasSubscribeTopic:topic identify:identify];
        if (hasSub) {
            [self unSubscribeTopic:topic identify:identify handle:handle];
        }
    }
}

/// 连接服务
- (void)connectWithIdentify:(NSString *)identify connectHandle:(MTFYMQTTConnectHandler)handle {
    NSArray *array = [self fetchSessionsWithIdentify:identify];
    for (MQTTSession *session in array) {
        [session connectWithConnectHandler:^(NSError *error) {
            if (handle) {
                handle(error);
            }
        }];
    }
}

/// 关闭连接
- (void)closeWithIdentify:(NSString *)identify closeHandle:(MTFYMQTTDisconnectHandler)handle {
    NSLog(@"MQTT连接关闭, identify:%@", identify);
    NSArray *sessions = [self fetchSessionsWithIdentify:identify];
    for (MQTTSession *session in sessions) {
        [session closeWithDisconnectHandler:^(NSError *error) {
            if (error) {
                NSLog(@"关闭失败,identify:%@, error: %@", identify ,error.description);
            }
            if (handle) {
                handle(error);
            }
        }];
    }
    
    NSArray<MQTTUtilModel *> *modelArray = [self fetchModelsWithIdentify:identify];
    [self.modelArray removeObjectsInArray:modelArray];
}

/// 关闭全部连接
- (void)closeAll {
    NSLog(@"MQTT连接全部关闭");
    for (MQTTUtilModel *model in self.modelArray) {
        [model.session closeWithDisconnectHandler:^(NSError *error) {
            if (error) {
                NSLog(@"关闭失败, error: %@", error.description);
            }
        }];
    }
    [self.modelArray removeAllObjects];
}

/// 注册代理对象
- (void)registerDelegate:(id)obj identify:(NSString *)identify {
    NSArray<MQTTUtilModel *> *array = [self fetchModelsAtLeastOneWithIdentify:identify];
    for (MQTTUtilModel *model in array) {
        model.delegate = obj;
    }
}

/// 解除代理对象
- (void)unregisterWithIdentify:(NSString *)identify {
    NSArray<MQTTUtilModel *> *array = [self fetchModelsWithIdentify:identify];
    for (MQTTUtilModel *model in array) {
        model.delegate = nil;
    }
}

#pragma mark - Private
/// 根据标识和config配置在数组中查找session对象;
- (MQTTUtilModel *)fetchModelWithIdentify:(NSString *)identify config:(MQTTConfig *)config {
    for (MQTTUtilModel *model in self.modelArray) {
        if ([model.identify isEqualToString:identify] && [model.config isEqualToConfig:config]) {
            if (!model.session) {
                model.session = [self createSession:config];
            }
            return model;
        }
    }
    return nil;
}

/// 根据标识和主题在数组中查找session对象;
- (MQTTSession *)fetchSessionWithTopic:(NSString *)topic identify:(NSString *)identify {
    for (MQTTUtilModel *model in self.modelArray) {
        if (![model.identify isEqualToString:identify]) {
            continue;
        }
        for (MQTTUtilTopicModel *topicModel in model.topics) {
            if ([topicModel.topic isEqualToString:topic]) {
                return model.session;
            }
        }
    }
    return nil;
}

/// 根据标识,主题和session配置在数组中查找session对象;
- (MQTTSession *)fetchSessionWithTopic:(NSString *)topic identify:(NSString *)identify config:(MQTTConfig *)config {
    for (MQTTUtilModel *model in self.modelArray) {
        if (![model.identify isEqualToString:identify] || ![model.config isEqualToConfig:config]) {
            continue;
        }
        for (MQTTUtilTopicModel *topicModel in model.topics) {
            if ([topicModel.topic isEqualToString:topic]) {
                return model.session;
            }
        }
    }
    return nil;
}

/// 根据标识在数组中查找session对象数组;
- (NSArray<MQTTSession *> *)fetchSessionsWithIdentify:(NSString *)identify {
    NSMutableArray *array = [NSMutableArray array];
    for (MQTTUtilModel *model in self.modelArray) {
        if ([model.identify isEqualToString:identify] && model.session) {
            [array addObject:model.session];
        }
    }
    return array;
}

/// 根据标识在数组中查找MQTTUtilModel对象数组;
- (NSArray<MQTTUtilModel *> *)fetchModelsWithIdentify:(NSString *)identify {
    NSMutableArray *array = [NSMutableArray array];
    for (MQTTUtilModel *model in self.modelArray) {
        if ([model.identify isEqualToString:identify]) {
            [array addObject:model];
        }
    }
    return array;
}

- (NSArray<MQTTUtilModel *> *)fetchModelsAtLeastOneWithIdentify:(NSString *)identify {
    NSMutableArray *array = [[self fetchModelsWithIdentify:identify] mutableCopy];
    if (!array.count) {
        MQTTUtilModel *model = [MQTTUtilModel modelWithIdentify:identify];
        [array addObject:model];
        [self.modelArray addObject:model];
    }
    return array;
}

- (MQTTUtilModel *)fetchModelWithSession:(MQTTSession *)session {
    if (!session) {
        return nil;
    }
    
    for (MQTTUtilModel *model in self.modelArray) {
        if ([session isEqual:model.session]) {
            return model;
        }
    }
    
    return nil;
}

/// 订阅主题
- (void)subscribeToTopic:(NSString *)topic session:(MQTTSession *)session atLevel:(MQTTQosLevel)level subscribeHandler:(MTFYMQTTSubscribeHandler)handle {
    if (!session) return;
    NSLog(@"******订阅主题******\ntopic:%@\nsession:%@",topic,session);
    [session subscribeToTopic:topic atLevel:level subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss) {
        if (handle) {
            handle(topic, error, gQoss);
        }
    }];
}


#pragma mark - MQTTSessionDelegate
- (void)newMessage:(MQTTSession *)session data:(NSData *)data onTopic:(NSString *)topic qos:(MQTTQosLevel)qos retained:(BOOL)retained mid:(unsigned int)mid {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//    if (![topic isEqualToString:HOST_RECOMMEND_PANEL_TOPIC_METRICS]) {
//        NSLog(@"MQTT数据:%@",dict.mj_JSONString);
//    }

    MQTTBaseModel *baseModel = [MQTTBaseModel mj_objectWithKeyValues:dict];
    if ((!baseModel.data) && (!baseModel.command) && dict) {
        baseModel = [MQTTBaseModel new];
        baseModel.data = dict;
    }
    MQTTUtilModel *model = [self fetchModelWithSession:session];
    if (model && model.topics.count) {
        for (MQTTUtilTopicModel *topicModel in model.topics) {
            if (topicModel.handle && [topicModel.topic isEqualToString:topic]) {
                topicModel.handle(baseModel, topic);
                break;
            }
        }
    } else {
        NSLog(@"没有找到匹配的Session model");
    }
//    NSLog(@"****************收到订阅消息**************\n:,topic:%@\n, dict: %@", topic ,dict);
    [self handleDelegate:session model:baseModel topic:topic];
}

-(void)handleEvent:(MQTTSession *)session event:(MQTTSessionEvent)eventCode error:(NSError *)error{
    if (eventCode == MQTTSessionEventConnected) {
//        NSLog(@"MQTT 链接成功");
    }else if (eventCode == MQTTSessionEventConnectionRefused) {
//        NSLog(@"MQTT 拒绝链接");
    }else if (eventCode == MQTTSessionEventConnectionClosed){
//        NSLog(@"MQTT 链接关闭");
    }else if (eventCode == MQTTSessionEventConnectionError){
//        NSLog(@"MQTT 链接错误");
    }else if (eventCode == MQTTSessionEventProtocolError){
//        NSLog(@"MQTT 不可接受的协议");
    }else{//MQTTSessionEventConnectionClosedByBroker
        NSLog(@"MQTT链接 其他错误");
    }
    if (error) {
        NSLog(@"链接报错  -- %@",error);
    }
    [self handleDelegate:session event:eventCode error:error];
    
    // 断开重连
    if (eventCode != MQTTSessionEventConnected) {
        MQTTUtilModel * model = [self fetchModelWithSession:session];
        NSMutableArray *topics = [NSMutableArray array];
        for (MQTTUtilTopicModel *topicModel in model.topics) {
            [topics addObject:topicModel.topic];
        }
        
        [self connectWithIdentify:model.identify connectHandle:^(NSError *error) {
            NSLog(@"connectWithIdentify = %@",error);
        }];
    }
}

- (void)connected:(MQTTSession *)session {
    [self handleDelegateConnected:session];
}
- (void)connectionClosed:(MQTTSession *)session {
    [self handleDelegateConnecteClosed:session];
}

- (void)connectionError:(MQTTSession *)session error:(NSError *)error {
    [self handleDelegate:session connectionError:error];
}


#pragma mark - 代理处理相关
- (void)handleDelegate:(MQTTSession *)session model:(MQTTBaseModel *)model topic:(NSString *)topic {
    MQTTUtilModel *uModel = [self fetchModelWithSession:session];
    if (uModel) {
        if (uModel.delegate && [uModel.delegate respondsToSelector:@selector(session:newMessage:onTopic:)]) {
            [uModel.delegate session:session newMessage:model onTopic:topic];
        }
    }
}

- (void)handleDelegate:(MQTTSession *)session event:(MQTTSessionEvent)eventCode error:(NSError *)error {
    MQTTUtilModel *model = [self fetchModelWithSession:session];
    if (model) {
        if (model.delegate && [model.delegate respondsToSelector:@selector(session:handleEvent:error:)]) {
            [model.delegate session:session handleEvent:eventCode error:error];
        }
    }
}

- (void)handleDelegateConnected:(MQTTSession *)session {
    MQTTUtilModel *model = [self fetchModelWithSession:session];
    if (model) {
        if (model.delegate && [model.delegate respondsToSelector:@selector(sessionConnected:)]) {
            [model.delegate sessionConnected:session];
        }
    }
}

- (void)handleDelegateConnecteClosed:(MQTTSession *)session {
    MQTTUtilModel *model = [self fetchModelWithSession:session];
    if (model) {
        if (model.delegate && [model.delegate respondsToSelector:@selector(sessionConnectionClosed:)]) {
            [model.delegate sessionConnectionClosed:session];
        }
    }
}

- (void)handleDelegate:(MQTTSession *)session connectionError:(NSError *)error {
    MQTTUtilModel *model = [self fetchModelWithSession:session];
    if (model) {
        if (model.delegate && [model.delegate respondsToSelector:@selector(session:connectionError:)]) {
            [model.delegate session:session connectionError:error];
        }
    }
}

#pragma mark - 网络相关
/// 监听网络状态变更
- (void)addNetworkingChangeObserver {
//    @weakify(self);
//    [kMTFYNetworkCenter addNetworkReachabilityStatusObserver:self block:^(NetworkStatus status) {
//        @strongify(self);
//        BOOL unavailable = status <= NotReachable;
//        self.preNetworkingReachable = !unavailable;
//    }];
}

- (void)setPreNetworkingReachable:(BOOL)preNetworkingReachable{
    if (_preNetworkingReachable == NO && preNetworkingReachable == YES) {
        [self reConnect];
    }
    
    _preNetworkingReachable = preNetworkingReachable;
}


- (void)reConnect {
    for (MQTTUtilModel *model in self.modelArray) {
        [model.session connectWithConnectHandler:^(NSError *error) {
            if (error) {
                NSLog(@"链接失败, error: %@", error.description);
            } else {
                NSLog(@"连接成功!");
                for (MQTTUtilTopicModel *topicModel in model.topics) {
                    [model.session subscribeToTopic:topicModel.topic atLevel:topicModel.level subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss) {
                        if(error) {
                            NSLog(@"订阅失败, error: %@", error.description);
                        } else {
                            NSLog(@"订阅成功, topic: %@", topicModel.topic);
                        }
                    }];
                }
            }
        }];
    }
}

@end

