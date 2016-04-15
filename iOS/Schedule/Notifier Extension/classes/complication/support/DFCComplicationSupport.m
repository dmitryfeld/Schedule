//
//  DFCComplicationSupport.m
//  Schedule
//
//  Created by Dmitry Feld on 4/9/16.
//  Copyright © 2016 Dmiry Feld. All rights reserved.
//

#import "DFCComplicationSupport.h"

@implementation DFCComplicationSupport
@dynamic defaultTemplate;
- (CLKComplicationTimelineEntry*) timelineEntryForMeeting:(DFCMeeting*)meeting withDate:(NSDate*)date andState:(DFCComplicationSupportMeetingStates)state {
    return nil;
}
- (CLKComplicationTemplate*) defaultTemplate {
    return nil;
}
@end
