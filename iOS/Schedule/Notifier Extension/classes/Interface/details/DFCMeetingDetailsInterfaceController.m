//
//  DFCMeetingDetailsInterfaceController.m
//  Schedule
//
//  Created by Dmitry Feld on 5/6/16.
//  Copyright © 2016 Dmiry Feld. All rights reserved.
//

#import "DFCMeetingDetailsInterfaceController.h"
#import "DFCMeeting.h"
#import "DFCLogger.h"
#import "DFCTheme.h"
#import "NSDate+Notifier.h"

const NSString* kDFCMeetingDetailsInterfaceControllerID = @"kDFCMeetingDetailsInterfaceControllerID";


@interface DFCMeetingDetailsInterfaceController () {
@protected
    DFCMeeting* _meeting;
}
@property (weak, nonatomic) IBOutlet WKInterfaceImage* icon;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel* name;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel* displayName;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel* started;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel* completed;

@end

@implementation DFCMeetingDetailsInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    if ([context isKindOfClass:[DFCMeeting class]]) {
        _meeting = (DFCMeeting*)context;
    }
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    if (!_meeting) {
        [self setErrorView];
    } else {
        [self setMeeting:_meeting];
    }
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}
- (void) setErrorView {
    self.icon.hidden = YES;
    self.name.hidden = YES;
    self.started.hidden = YES;
    self.completed.hidden = YES;
    self.displayName.text = @"General Fault!!!";
    self.displayName.textColor = [UIColor redColor];
}
- (void) setMeeting:(DFCMeeting*)meeting {
    NSDate* now = [NSDate date];
    NSString* title = @"Next";
    UIColor* tint = [DFCTheme sharedTheme].nextMeetingTintColor;
    if ([DFCMeetingAUX hasMeeting:meeting endedToDate:now]) {
        tint = [DFCTheme sharedTheme].completedMeetingTintColor;
        title = @"Completed";
    } else if ([DFCMeetingAUX hasMeeting:meeting startedToDate:now]) {
        tint = [DFCTheme sharedTheme].startedMeetingTintColor;
        title = @"Started";
    }
    self.icon.hidden = NO;
    self.name.hidden = NO;
    self.started.hidden = NO;
    self.completed.hidden = NO;
    self.icon.image = [[UIImage imageNamed:@"meeting_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.name.text = title;
    self.displayName.text = meeting.displayName;
    self.started.text = [NSDate shortFormatForDate:meeting.startDate];
    self.completed.text = [NSDate shortFormatForDate:meeting.endDate];
    self.icon.tintColor = tint;
    self.name.textColor = tint;
}
@end



