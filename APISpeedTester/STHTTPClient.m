//
//  STHTTPClient.m
//  APISpeedTester
//
//  Created by Michael Hong on 6/1/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import "STHTTPClient.h"
#import "Setting.h"

@implementation STHTTPClient

+ (instancetype)sharedClient {
    static STHTTPClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[STHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]];
    });
    return _sharedClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url{
    self = [super initWithBaseURL:url];
    if (self) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.requestSerializer.timeoutInterval = requestTimeOut;
        self.requestSerializer.cachePolicy  = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
        if (userToken) {
            NSString *tokenStr = [NSString stringWithFormat:@"Token %@", userToken];
            [self.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
        }
    }
    return self;
}

- (void)retrieveUserIP:(void (^)(NSString *))callback {
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self GET:@"http://ipof.in/json" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        callback(responseObject[@"ip"]);
    } failure:nil];
}

@end
