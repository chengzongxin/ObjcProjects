//
//  MQTTConst.m
//  ObjcProjects
//
//  Created by Joe on 2019/6/21.
//  Copyright © 2019 Joe. All rights reserved.
//

#import "MQTTConst.h"

@implementation MQTTConst

NSString *const MQTT_HOST = @"mqtt-mqtt.matafy.com";

int const MQTT_PORT = 1883;

NSString *const MQTT_USERNAME = @"public";

NSString *const MQTT_PASSWORD = @"public";

NSString *const MQTT_CLIENTID = @"/mtfy/default/ios/v4.3.6.5/B755AB82-37E8-4662-8515-2DF25E497A60/7160c809-6682-4033-9f8f-af9967f06f77";

@end

@implementation NSString (MQTT_Extension)

+ (NSString *)validStr:(NSString *)string
{
    if (!string
        || [string isKindOfClass:[NSNull class]]
        || [string isEqualToString:@"<null>"]) {
        return @"";
    }
    return string;
}

@end
