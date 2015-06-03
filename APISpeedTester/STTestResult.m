//
//  STTestResult.m
//  APISpeedTester
//
//  Created by Michael Hong on 6/1/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import "STTestResult.h"

@implementation STTestResult

- (instancetype)initWithStatus:(STTestResultStatus)status andTime:(NSTimeInterval)time
{
    self = [super init];
    if (self) {
        self.status = status;
        self.time = time;
    }
    return self;
}

- (NSDictionary *)serialize {
    NSString *statusStr;
    switch (self.status) {
        case STTestSuccess:
            statusStr = @"success";
            break;
            
        case STTestFailure:
            statusStr = @"failure";
            break;
            
        case STTestTimeOut:
            statusStr = @"timeout";
            
        default:
            break;
    }
    return @{@"status"  : statusStr,
             @"time"    : @(self.time)};
}

@end
