//
//  DFCUtilitarianLargeComplicationSupport.h
//  Schedule
//
//  Created by Dmitry Feld on 4/9/16.
//  Copyright © 2016 Dmiry Feld. All rights reserved.
//

#import "DFCComplicationSupport.h"

@interface DFCUtilitarianLargeComplicationSupport : DFCComplicationSupport
@property (readonly,nonatomic) CLKComplicationTemplateUtilitarianLargeFlat* defaultTemplate;
- (CLKComplicationTimelineEntry*) timelineEntryForMeeting:(DFCMeeting*)meeting withDate:(NSDate*)date andState:(DFCComplicationSupportMeetingStates)state;
@end
