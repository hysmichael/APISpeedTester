//
//  ViewController.h
//  APISpeedTester
//
//  Created by Michael Hong on 6/1/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTestQueue.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, STTestQueueDelegate>

@property IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *statusItem;

@end

