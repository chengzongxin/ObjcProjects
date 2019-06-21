//
//  MQTTUtilModel.m
//  Matafy
//
//  Created by Fussa on 2019/5/7.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MQTTUtilModel.h"
#import "MQTTConst.h"

@implementation MQTTUtilModel
+ (instancetype)modelWithTopic:(NSString *)topic identify:(NSString *)identify level:(MQTTQosLevel)level session:(MQTTSession *)session config:(MQTTConfig *)config handle:(MTFYMQTTHandle)handle {
    topic = [NSString validStr:topic];
    MQTTUtilTopicModel *topicModel = [MQTTUtilTopicModel modelWithTopic:topic qosLevel:level handle:handle];
    
    MQTTUtilModel *model = [[MQTTUtilModel alloc] init];
    model.session = session;
    model.config = config;
    model.topics = @[topicModel];
    model.identify = [self validateIdentify:identify];
    return model;
}

+ (instancetype)modelWithTopics:(NSArray<NSString *> *)topics identify:(NSString *)identify level:(MQTTQosLevel)level session:(MQTTSession *)session config:(MQTTConfig *)config handle:(MTFYMQTTHandle)handle {
    NSMutableArray *topicArray = [NSMutableArray array];
    for (NSString *topic in topics) {
        MQTTUtilTopicModel *topicModel = [MQTTUtilTopicModel modelWithTopic:[NSString validStr:topic] qosLevel:level handle:handle];
        [topicArray addObject:topicModel];
    }
    MQTTUtilModel *model = [[MQTTUtilModel alloc] init];
    model.session = session;
    model.config = config;
    model.topics = topicArray;
    model.identify = [self validateIdentify:identify];
    return model;
}

+ (instancetype)modelWithIdentify:(NSString *)identify {
    MQTTUtilModel *model = [[MQTTUtilModel alloc] init];
    model.identify = [self validateIdentify:identify];
    model.topics = @[];
    return model;
}

- (void)addTopic:(NSString *)topic level:(MQTTQosLevel)level handle:(MTFYMQTTHandle)handle {
    NSMutableArray *topics = [NSMutableArray arrayWithArray:self.topics];
    BOOL isContain = NO;
    for (MQTTUtilTopicModel *topicModel in topics) {
        if ([topicModel.topic isEqualToString:topic]) {
            isContain = YES;
            break;
        }
    }
    if (isContain) {
        return;
    }
    [topics addObject:[MQTTUtilTopicModel modelWithTopic:topic qosLevel:level handle:handle]];
    self.topics = topics;
}

- (void)removeTopic:(NSString *)topic {
    NSMutableArray *topics = [NSMutableArray arrayWithArray:self.topics];
    NSInteger index = -1;
    for (MQTTUtilTopicModel *topicModel in topics) {
        if ([topicModel.topic isEqualToString:topic]) {
            index = [topics indexOfObject:topicModel];
            break;
        }
    }
    if (index > -1) {
        [topics removeObjectAtIndex:index];
    }
    self.topics = topics;
}

+ (NSString *)validateIdentify:(NSString *)identify {
    if (NULLString(identify)) {
        identify = @"application";
    }
    return identify;
}

@end

@implementation MQTTUtilTopicModel

+ (instancetype)modelWithTopic:(NSString *)topic qosLevel:(MQTTQosLevel)level handle:(MTFYMQTTHandle)handle{
    MQTTUtilTopicModel *model = [[MQTTUtilTopicModel alloc] init];
    model.topic = topic;
    model.level = level;
    if (handle) {
        model.handle = handle;
    }
    return model;
}
@end
