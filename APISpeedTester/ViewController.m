//
//  ViewController.m
//  APISpeedTester
//
//  Created by Michael Hong on 6/1/15.
//  Copyright (c) 2015 Michael Hong. All rights reserved.
//

#import "ViewController.h"
#import "TestCaseCell.h"
#import "STTestCase.h"
#import "STHTTPClient.h"
#import "Setting.h"

#define TESTCASE_MAIN @"CELL_MAIN"
#define TESTCASE_DETAIL @"CELL_DETAIL"

@interface ViewController ()

@property STTestQueue *queue;
@property BOOL hasRunOnce;
@property NSUInteger selectedSection;

@end

@interface ViewController (TestData)
- (void) setUpTestQueue:(STTestQueue *) queue;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[TestCaseCell class] forCellReuseIdentifier:TESTCASE_MAIN];
    [self.tableView registerClass:[TestCaseCell class] forCellReuseIdentifier:TESTCASE_DETAIL];
    [self.tableView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];

    self.queue = [[STTestQueue alloc] init];
    self.queue.delegate = self;
    [self setUpTestQueue:self.queue];
    
    self.hasRunOnce = false;
    self.selectedSection = -1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}


- (IBAction)startTests:(id)sender {
    if (!self.queue.testIsRunning) [self.queue runAllTests];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.queue.tests count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == self.selectedSection) {
        STTestCase *test = self.queue.tests[section];
        return 1 + [test.results count];
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) return 50.0;
    return 35.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        TestCaseCell *cell = (TestCaseCell *)[tableView dequeueReusableCellWithIdentifier:TESTCASE_MAIN];
        STTestCase *test = self.queue.tests[indexPath.section];
        [cell displayTestCase:test testQueue:self.queue];
        return cell;
    } else {
        TestCaseCell *cell = (TestCaseCell *)[tableView dequeueReusableCellWithIdentifier:TESTCASE_DETAIL];
        STTestCase *test = self.queue.tests[indexPath.section];
        [cell displayTestDetail:test trial:indexPath.row];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.hasRunOnce && !self.queue.testIsRunning) {
        NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSetWithIndex:indexPath.section];
        if (indexPath.section == self.selectedSection) {
            self.selectedSection = -1;
        } else {
            if (self.selectedSection != -1) [indexSet addIndex:self.selectedSection];
            self.selectedSection = indexPath.section;
        }
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (void)didStartAllTests {
    self.selectedSection = -1;
    [self.tableView reloadData];
}

- (void)didStartTest:(NSUInteger)index trial:(NSUInteger)trial {
    self.statusItem.title = [NSString stringWithFormat:@"Running... %lu/%lu", index + 1, [self.queue.tests count]];
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:index];
    [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionMiddle animated:true];
}

- (void)didEndTest:(NSUInteger)index {
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:index];
    [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didEndAllTests {
    self.hasRunOnce = true;
    self.statusItem.title = @"Uploading Result...";
    [[STHTTPClient sharedClient] retrieveUserIP:^(NSString * userIP) {
        NSDictionary *testResults = @{@"ip": userIP, @"results": [self.queue serialize]};
        [[STHTTPClient sharedClient] POST:reportSubmitURL parameters:testResults success:^(NSURLSessionDataTask *task, id responseObject) {
            self.statusItem.title = @"Done";
        } failure:nil];
    }];
    
}

@end
