//
//  DFCComplicationSupport.m
//  Schedule
//
//  Created by Dmitry Feld on 4/9/16.
//  Copyright © 2016 Dmiry Feld. All rights reserved.
//

#import "DFCComplicationSupport.h"
#import "DFCTheme.h"

@implementation DFCComplicationSupport
@dynamic defaultTemplate;
- (CLKComplicationTimelineEntry*) timelineEntryForMeeting:(DFCMeeting*)meeting withDate:(NSDate*)date andState:(DFCComplicationSupportMeetingStates)state {
    return nil;
}
- (CLKComplicationTemplate*) defaultTemplate {
    return nil;
}
- (UIColor*) tintColorForState:(DFCComplicationSupportMeetingStates)state {
    UIColor* result = [DFCTheme sharedTheme].nextMeetingTintColor;
    switch (state) {
        case kDFCComplicationSupportMeetingStateStarted:
            result = [DFCTheme sharedTheme].startedMeetingTintColor;
            break;
        case kDFCComplicationSupportMeetingStateCompleted:
            result = [DFCTheme sharedTheme].completedMeetingTintColor;
            break;
        case kDFCComplicationSupportMeetingStateNext:
        default:
            break;
    }
    return result;
}
@end
