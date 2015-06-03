//
//  TestCaseCell.h
//  APISpeedTester
//
//  Created by Michael Hong on 6/1/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STTestCase;
@class STTestQueue;

@interface TestCaseCell : UITableViewCell

@property UILabel *timeLabel;

- (void) displayTestCase:(STTestCase *) test testQueue:(STTestQueue *) queue;
- (void) displayTestDetail:(STTestCase *) test trial:(NSUInteger) trial;

@end
