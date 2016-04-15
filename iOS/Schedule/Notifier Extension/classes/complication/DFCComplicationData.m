//
//  DFCComplicationData.m
//  Schedule
//
//  Created by Dmitry Feld on 4/11/16.
//  Copyright © 2016 Dmiry Feld. All rights reserved.
//

#import <ClockKit/ClockKit.h>
#import "DFCComplicationData.h"
#import "DFCSingleton.h"

const NSString* __kDFCComplicationDataTag = @"__kDFCComplicationDataTag";

@interface DFCComplicationData()<DFCTagged> {
@private
    DFCScheduleAUX* _schedule;
}
@end


@implementation DFCComplicationData
@synthesize schedule = _schedule;
- (id) tag {
    return __kDFCComplicationDataTag;
}
- (DFCScheduleAUX*) schedule {
    return _schedule;
}
- (void) setSchedule:(DFCScheduleAUX *)schedule {
    if (![_schedule isEqual:schedule]) {
        _schedule = schedule;
        if (_schedule.meetings.count) {
            [self updateAllComplications];
        }
    }
}
- (void) updateAllComplications {
    CLKComplicationServer* complicationServer = [CLKComplicationServer sharedInstance];
    for (CLKComplication* complication in complicationServer.activeComplications) {
        [complicationServer reloadTimelineForComplication:complication];
    }
}

+ (DFCComplicationData*) sharedComplicationData {
    DFCComplicationData* result = [DFCSingleton instanceWithTag:__kDFCComplicationDataTag];
    if (!result) {
        result = [DFCComplicationData new];
        [DFCSingleton addInstance:result];
    }
    return result;
}
@end
