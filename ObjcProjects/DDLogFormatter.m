//
//  DDLogFormatter.m
//  ObjcProjects
//
//  Created by Joe on 2019/4/29.
//  Copyright © 2019 Joe. All rights reserved.
//

#import "DDLogFormatter.h"

@implementation DDLogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *logLevel;
    switch (logMessage->_flag) {
        case DDLogFlagError    : logLevel = @"Error"; break;
        case DDLogFlagWarning  : logLevel = @"W"; break;
        case DDLogFlagInfo     : logLevel = @"Info"; break;
        case DDLogFlagDebug    : logLevel = @"D"; break;
        default                : logLevel = @"V"; break;
    }
    
    NSString *dateAndTime = [threadUnsafeDateFormatter stringFromDate:(logMessage->_timestamp)];
    NSString *logMsg = logMessage->_message;
    NSString *logFileNmae = logMessage -> _fileName;
    NSString *logFuncation = logMessage -> _function;
    long lineNum = logMessage -> _line;
    
    return [NSString stringWithFormat:@"%@ %@ :%li %@ %@ :::\n %@ ",logFileNmae, logFuncation,lineNum, logLevel, dateAndTime, logMsg];
    
}

@end
