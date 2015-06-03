//
//  STHTTPClient.h
//  APISpeedTester
//
//  Created by Michael Hong on 6/1/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface STHTTPClient : AFHTTPSessionManager

+ (instancetype) sharedClient;

- (void) retrieveUserIP: (void(^)(NSString *)) callback;

@end
