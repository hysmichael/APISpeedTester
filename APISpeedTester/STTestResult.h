//
//  STTestResult.h
//  APISpeedTester
//
//  Created by Michael Hong on 6/1/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum STTestResultStatus_t {
    STTestSuccess, STTestFailure, STTestTimeOut
} STTestResultStatus;

@interface STTestResult : NSObject

@property STTestResultStatus status;
@property NSTimeInterval time;

- (instancetype) initWithStatus:(STTestResultStatus) status andTime:(NSTimeInterval) time;
- (NSDictionary *) serialize;

@end
