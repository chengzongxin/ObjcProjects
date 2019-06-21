//
//  MQTTConst.h
//  ObjcProjects
//
//  Created by Joe on 2019/6/21.
//  Copyright © 2019 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NULLString(string) ((![string isKindOfClass:[NSString class]])||[string isEqualToString:@""] || (string == nil) || [string isEqualToString:@""] || [string isKindOfClass:[NSNull class]]||[[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)

NS_ASSUME_NONNULL_BEGIN

@interface MQTTConst : NSObject
// ip
FOUNDATION_EXPORT NSString *const MQTT_HOST;
// port
FOUNDATION_EXPORT int const MQTT_PORT;
// username
FOUNDATION_EXPORT NSString *const MQTT_USERNAME;
// password
FOUNDATION_EXPORT NSString *const MQTT_PASSWORD;
// ClineId
FOUNDATION_EXPORT NSString *const MQTT_CLIENTID;

@end

@interface NSString (MQTT_Extension)

+ (NSString *)validStr:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
