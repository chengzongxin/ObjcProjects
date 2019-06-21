//
//  MQTTBaseModel.h
//  Matafy
//
//  Created by Fussa on 2019/5/7.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString* const MQTTCommandOver   = @"over";
static NSString* const MQTTCommandClose  = @"close";

@interface MQTTBaseModel : NSObject

@property (nonatomic, copy) NSString *command;
@property (nonatomic, strong) id data;

@end

