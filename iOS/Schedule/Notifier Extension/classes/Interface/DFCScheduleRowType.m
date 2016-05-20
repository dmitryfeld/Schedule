//
//  DFCScheduleRowType.m
//  Schedule
//
//  Created by Dmitry Feld on 5/6/16.
//  Copyright © 2016 Dmiry Feld. All rights reserved.
//
#import <WatchKit/WatchKit.h>
#import "DFCScheduleRowType.h"
#import "DFCTheme.h"

@interface DFCScheduleRowType() {
@protected
    DFCMeeting* _meeting;
}
@property (weak, nonatomic) IBOutlet WKInterfaceImage* icon;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel* name;
@end

@implementation DFCScheduleRowType
@dynamic meeting;
- (DFCMeeting*) meeting {
    return _meeting;
}
- (void) setMeeting:(DFCMeeting *)meeting {
    if (![_meeting isEqual:meeting]) {
        NSDate* now = [NSDate date];
        UIColor* tint = [DFCTheme sharedTheme].nextMeetingTintColor;
        _meeting = meeting;
        if ([DFCMeetingAUX hasMeeting:_meeting endedToDate:now]) {
            tint = [DFCTheme sharedTheme].completedMeetingTintColor;
        } else if ([DFCMeetingAUX hasMeeting:_meeting startedToDate:now]) {
            tint = [DFCTheme sharedTheme].startedMeetingTintColor;
        }
        self.icon.image = [[UIImage imageNamed:@"meeting_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.name.text = _meeting.displayName;
        self.icon.tintColor = tint;
        self.name.textColor = tint;
    }
}

@end
