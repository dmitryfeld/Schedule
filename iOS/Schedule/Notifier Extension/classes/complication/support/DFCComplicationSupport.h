//
//  DFCComplicationSupport.h
//  Schedule
//
//  Created by Dmitry Feld on 4/9/16.
//  Copyright © 2016 Dmiry Feld. All rights reserved.
//

#import <ClockKit/ClockKit.h>
#import "DFCSchedule.h"

typedef enum __DFCComplicationSupportMeetingStates__:NSUInteger {
    kDFCComplicationSupportMeetingStateStarted,
    kDFCComplicationSupportMeetingStateCompleted,
    kDFCComplicationSupportMeetingStateNext
    
} DFCComplicationSupportMeetingStates;

@interface DFCComplicationSupport : NSObject
@property (readonly,nonatomic) CLKComplicationTemplate* defaultTemplate;
- (CLKComplicationTimelineEntry*) timelineEntryForMeeting:(DFCMeeting*)meeting withDate:(NSDate*)date andState:(DFCComplicationSupportMeetingStates)state;
- (UIColor*) tintColorForState:(DFCComplicationSupportMeetingStates)state;
@end
