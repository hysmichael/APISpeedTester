//
//  STTestCase.m
//  APISpeedTester
//
//  Created by Michael Hong on 6/1/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import "STTestCase.h"
#import "STHTTPClient.h"
#import "STTestResult.h"
#import <AFNetworking.h>

@interface STTestCase()

@property NSDate *startTime;
@property NSDate *endTime;

@end

@implementation STTestCase

+ (instancetype)testCaseWithName:(NSString *)name HTTPMethod:(STRequestMethod)method urlString:(NSString *)urlStr parameters:(NSDictionary *)para {
    STTestCase *test = [[self alloc] init];
    test.name = name;
    test.method = method;
    test.urlString = urlStr;
    test.requestParameters = para;
    
    test.totalTrials = 3;
    test.trialCount = 0;
    
    test.results = [[NSMutableArray alloc] init];
    return test;
}

- (void)reset {
    self.trialCount = 0;
    self.results = [[NSMutableArray alloc] init];
}

- (void)runTest {
    self.trialCount ++;
    /* set response serializer */
    if (self.method == STRequestGET || self.method == STRequestPOST || self.method == STRequestPATCH) {
        [STHTTPClient sharedClient].responseSerializer = [AFJSONResponseSerializer serializer];
    } else {
        [STHTTPClient sharedClient].responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    
    /* notify delegate */
    if ([self.delegate respondsToSelector:@selector(didStartTrial:)]) [self.delegate didStartTrial:self.trialCount];
    self.startTime = [NSDate date];
    
    /* issue the request */
    if (self.method == STRequestGET || self.method == STRequestGeneralGET) {
        [[STHTTPClient sharedClient] GET:self.urlString parameters:self.requestParameters success:^(NSURLSessionDataTask *task, id responseObject) {
            [self requestSuccess:task responseObject:responseObject];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self requestFailure:task error:error];
        }];
    }
    else if (self.method == STRequestPOST) {
        [[STHTTPClient sharedClient] POST:self.urlString parameters:self.requestParameters success:^(NSURLSessionDataTask *task, id responseObject) {
            [self requestSuccess:task responseObject:responseObject];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self requestFailure:task error:error];
        }];
    }
    else if (self.method == STRequestPATCH) {
        [[STHTTPClient sharedClient] PATCH:self.urlString parameters:self.requestParameters success:^(NSURLSessionDataTask *task, id responseObject) {
            [self requestSuccess:task responseObject:responseObject];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self requestFailure:task error:error];
        }];
    }
}

- (void) requestSuccess:(NSURLSessionDataTask *)task responseObject:(id) responseObject {
    self.endTime = [NSDate date];
    STTestResult *result = [[STTestResult alloc] initWithStatus:STTestSuccess andTime:[self.endTime timeIntervalSinceDate:self.startTime]];
    [self.results addObject:result];
    if (self.trialCount == self.totalTrials) self.trialCount ++;
    if ([self.delegate respondsToSelector:@selector(didEndTrial:)]) [self.delegate didEndTrial:self.trialCount];
    if (self.trialCount < self.totalTrials) [self runTest];
}

- (void) requestFailure:(NSURLSessionDataTask *)task error:(NSError *)error {
    NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
    NSInteger statusCode = response.statusCode;
    self.endTime = [NSDate date];
    STTestResultStatus status = STTestFailure;
    if (statusCode == 503 || statusCode == 504) status = STTestTimeOut;
    STTestResult *result = [[STTestResult alloc] initWithStatus:status andTime:[self.endTime timeIntervalSinceDate:self.startTime]];
    [self.results addObject:result];
    if (self.trialCount == self.totalTrials) self.trialCount ++;
    if ([self.delegate respondsToSelector:@selector(didEndTrial:)]) [self.delegate didEndTrial:self.trialCount];
    if (self.trialCount < self.totalTrials) [self runTest];
}

- (NSString *)requestDescription {
    if (self.method == STRequestGeneralGET) {
        return [NSString stringWithFormat:@"GET %@", self.urlString];
    }
    
    NSString *method;
    if (self.method == STRequestGET) {
        method = @"GET";
    } else if (self.method == STRequestPOST) {
        method = @"POST";
    } else if (self.method == STRequestPATCH) {
        method = @"PATCH";
    }
    return [NSString stringWithFormat:@"%@ //%@", method, self.urlString];
}

- (NSTimeInterval)averageResponseTime {
    NSTimeInterval sum = 0;
    for (STTestResult *result in self.results) sum += result.time;
    return sum / [self.results count];
}

- (NSDictionary *)serialize {
    NSMutableArray *results = [NSMutableArray array];
    for (STTestResult *resultObj in self.results) [results addObject:[resultObj serialize]];
    return @{@"name"            : self.name,
             @"description"     : [self requestDescription],
             @"trials"          : @(self.totalTrials),
             @"average_time"    : @([self averageResponseTime]),
             @"results"         : results};
}


@end
