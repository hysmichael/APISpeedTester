//
//  STTestCase.h
//  APISpeedTester
//
//  Created by Michael Hong on 6/1/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol STTestCaseDelegate <NSObject>

@optional

- (void) didStartTrial:(NSUInteger) trial;
- (void) didEndTrial:(NSUInteger) trial;

@end

typedef enum STRequestMethod_t {
    /* JSON Response */  STRequestGET, STRequestPOST, STRequestPATCH,
    /* HTTP Response */  STRequestGeneralGET
} STRequestMethod;

@interface STTestCase : NSObject

@property id<STTestCaseDelegate> delegate;

@property NSString *name;

@property STRequestMethod method;
@property NSString * urlString;
@property NSDictionary * requestParameters;

@property NSUInteger totalTrials;
@property NSUInteger trialCount;

@property NSMutableArray *results;

+ (instancetype) testCaseWithName:(NSString *) name HTTPMethod:(STRequestMethod) method urlString:(NSString *) urlStr parameters:(NSDictionary *) para;

- (void) reset;

- (void) runTest;
- (NSString *) requestDescription;

- (NSTimeInterval) averageResponseTime;

- (NSDictionary *) serialize;

@end
