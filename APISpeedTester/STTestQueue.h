//
//  STTestQueue.h
//  APISpeedTester
//
//  Created by Michael Hong on 6/1/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STTestCase.h"

@protocol STTestQueueDelegate <NSObject>

@optional

- (void) didStartAllTests;
- (void) didStartTest:(NSUInteger) index trial:(NSUInteger) trial;
- (void) didEndTest:(NSUInteger) index trial:(NSUInteger) trial;
- (void) didEndTest:(NSUInteger) index;
- (void) didEndAllTests;

@end

@interface STTestQueue : NSObject<STTestCaseDelegate>

@property id<STTestQueueDelegate> delegate;

@property BOOL testIsRunning;

@property NSMutableArray *tests;
@property NSUInteger totalTrials;

- (void) addTest:(STTestCase *) test;
- (void) runAllTests;

- (NSArray *) serialize;

@end
