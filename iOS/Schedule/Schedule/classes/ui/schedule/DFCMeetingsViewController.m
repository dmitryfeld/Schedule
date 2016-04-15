//
//  MeetingsViewController.m
//  Schedule
//
//  Created by Dmitry Feld on 4/9/16.
//  Copyright © 2016 Dmiry Feld. All rights reserved.
//

#import "DFCMeetingsViewController.h"
#import "DFCApplicationData.h"
#import "DFCMeetingViewCell.h"
#import "NSDate+Notifier.h"

@interface DFCMeetingsViewController () {
    
}
@property (readonly,nonatomic) DFCApplicationData* applicationData;
@end

@implementation DFCMeetingsViewController
@synthesize applicationData = _applicationData;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationDataUpdated:) name:(NSString*)kDFCApplicationDataScheduleUpdated object:nil];
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self scrollToFuture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.applicationData.schedule.meetings.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DFCMeetingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DFCMeetingViewCell reuseIdentifier] forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[DFCMeetingViewCell class]]) {
        cell.meeting = [self.applicationData.schedule.meetings objectAtIndex:indexPath.row];
    }
    
    return cell;
}


- (void) onApplicationDataUpdated:(id)sender {
    [self.tableView reloadData];
    [self scrollToFuture];
}
- (IBAction)onRefresh:(id)sender {
    [self.applicationData refresh];
}

- (NSIndexPath*) pathToRowOfCurrentlyRunningMeeting {
    NSIndexPath* result = nil;
    NSUInteger counter = 0;
    for (DFCMeeting* meeting in self.applicationData.schedule.meetings) {
        if ([NSDate isPast:meeting.startDate] && [NSDate isFuture:meeting.endDate]) {
            result = [NSIndexPath indexPathForRow:counter inSection:0];
            break;
        }
        counter ++;
    }
    return result;
}
- (NSIndexPath*) pathToRowOfNextRunningMeeting {
    NSIndexPath* result = nil;
    NSUInteger counter = 0;
    for (DFCMeeting* meeting in self.applicationData.schedule.meetings) {
        if ([NSDate isFuture:meeting.startDate] && [NSDate isFuture:meeting.endDate]) {
            result = [NSIndexPath indexPathForRow:counter inSection:0];
            break;
        }
        counter ++;
    }
    return result;
}
- (void) scrollToFuture {
    NSIndexPath* pathToVisible = [self pathToRowOfCurrentlyRunningMeeting];
    if (!pathToVisible) {
        pathToVisible = [self pathToRowOfNextRunningMeeting];
    }
    if (pathToVisible) {
        [self.tableView scrollToRowAtIndexPath:pathToVisible atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

- (DFCApplicationData*) applicationData {
    if (!_applicationData) {
        _applicationData = [DFCApplicationData sharedApplicationData];
    }
    return _applicationData;
}


@end
