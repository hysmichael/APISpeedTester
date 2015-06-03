//
//  TestCaseCell.m
//  APISpeedTester
//
//  Created by Michael Hong on 6/1/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import "TestCaseCell.h"
#import "STTestCase.h"
#import "STTestQueue.h"
#import "STTestResult.h"

@implementation TestCaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:self.timeLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.timeLabel sizeToFit];
    self.timeLabel.frame = CGRectMake(self.contentView.frame.size.width - self.timeLabel.frame.size.width - 15.0,
                                      (self.contentView.frame.size.height - self.timeLabel.frame.size.height) / 2.0,
                                      self.timeLabel.frame.size.width, self.timeLabel.frame.size.height);
    
    self.detailTextLabel.frame = CGRectMake(self.detailTextLabel.frame.origin.x, self.detailTextLabel.frame.origin.y,
                                            self.timeLabel.frame.origin.x - self.detailTextLabel.frame.origin.x - 10.0,
                                            self.detailTextLabel.frame.size.height);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)displayTestCase:(STTestCase *)test testQueue:(STTestQueue *)queue {
    self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.9];
    
    self.textLabel.text = test.name;
    self.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
    self.detailTextLabel.text = [test requestDescription];
    if (test.trialCount <= test.totalTrials) {
        if (test.trialCount == 0) {
            self.timeLabel.textColor = [UIColor lightGrayColor];
            self.timeLabel.text = (queue.testIsRunning ? @"Pending" : @"Ready");
        } else {
            self.timeLabel.textColor = [UIColor colorWithRed:0.97 green:0.20 blue:0.04 alpha:1.0];
            self.timeLabel.text = [NSString stringWithFormat:@"Trial %lu", test.trialCount];
        }
    } else {
        NSTimeInterval ms = [test averageResponseTime] * 1000;
        self.timeLabel.textColor = [UIColor blackColor];
        self.timeLabel.text = [NSString stringWithFormat:@"%.f ms", ms];
    }
}

- (void)displayTestDetail:(STTestCase *)test trial:(NSUInteger)trial {
    self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    self.textLabel.font = [UIFont systemFontOfSize:14.0];
    
    STTestResult *result = test.results[trial - 1];
    if (result.status == STTestSuccess) {
        self.textLabel.textColor = [UIColor colorWithRed:0.28 green:0.78 blue:0.08 alpha:1.0];
        self.textLabel.text = @"  + Success";
    } else {
        self.textLabel.textColor = [UIColor colorWithRed:0.97 green:0.20 blue:0.04 alpha:1.0];
        if (result.status == STTestFailure) {
            self.textLabel.text = @"  - Failure";
        } else {
            self.textLabel.text = @"  - Timeout";
        }
    }
    
    NSTimeInterval ms = result.time * 1000;
    self.timeLabel.textColor = [UIColor darkGrayColor];
    self.timeLabel.text = [NSString stringWithFormat:@"%.f ms", ms];
}

@end
