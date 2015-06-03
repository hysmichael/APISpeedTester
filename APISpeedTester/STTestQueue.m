//
//  STTestQueue.m
//  APISpeedTester
//
//  Created by Michael Hong on 6/1/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import "STTestQueue.h"

@interface STTestQueue()

@property NSUInteger testInProgress;

@end

@implementation STTestQueue

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tests = [[NSMutableArray alloc] init];
        self.totalTrials = 3;
    }
    return self;
}

- (void)addTest:(STTestCase *)test {
    test.totalTrials = self.totalTrials;
    test.delegate = self;
    [self.tests addObject:test];
}

- (void)runAllTests {
    self.testInProgress = 0;
    self.testIsRunning = true;
    for (STTestCase *test in self.tests) [test reset];
    if ([self.delegate respondsToSelector:@selector(didStartAllTests)]) [self.delegate didStartAllTests];
    [self runTest];
}

- (void)runTest {
    STTestCase *test = self.tests[self.testInProgress];
    [test runTest];
}

- (void)didStartTrial:(NSUInteger)trial {
    if ([self.delegate respondsToSelector:@selector(didStartTest:trial:)]) [self.delegate didStartTest:self.testInProgress trial:trial];
}

- (void)didEndTrial:(NSUInteger)trial {
    if (trial < self.totalTrials) {
        if ([self.delegate respondsToSelector:@selector(didEndTest:trial:)]) [self.delegate didEndTest:self.testInProgress trial:trial];
    } else {
        if ([self.delegate respondsToSelector:@selector(didEndTest:)]) [self.delegate didEndTest:self.testInProgress];
        self.testInProgress ++;
        if (self.testInProgress < [self.tests count]) {
            [self runTest];
        } else {
            self.testIsRunning = false;
            if ([self.delegate respondsToSelector:@selector(didEndAllTests)]) [self.delegate didEndAllTests];
        }
    }
}

- (NSArray *)serialize {
    NSMutableArray *tests = [NSMutableArray array];
    for (STTestCase *testObj in self.tests) [tests addObject:[testObj serialize]];
    return tests;
}

@end
