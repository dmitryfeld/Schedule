//
//  InterfaceController.m
//  Notifier Extension
//
//  Created by Dmitry Feld on 4/9/16.
//  Copyright © 2016 Dmiry Feld. All rights reserved.
//

#import <WatchConnectivity/WatchConnectivity.h>
#import "DFCInterfaceController.h"

#import "DFCComplicationData.h"
#import "DFCSchedule.h"
#import "DFCLogger.h"

#import "DFCScheduleRowType.h"
#import "DFCMeetingDetailsInterfaceController.h"
#import "NSDate+Notifier.h"

@interface DFCInterfaceController()<WCSessionDelegate> {
@private
    DFCComplicationData* _complicationData;
}
@property (strong,nonatomic,readonly) DFCComplicationData* complicationData;
@property (weak,nonatomic) IBOutlet WKInterfaceTable* table;
@end


@implementation DFCInterfaceController
@synthesize complicationData = _complicationData;

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    [DFCLogger sharedLogger].levels = kDFCLoggerLevelMessage;
    __MESSAGE__(@"----->>>> %ul",self.complicationData.schedule.meetings.count)
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    [self configureTableWithSchedule:self.complicationData.schedule];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (DFCComplicationData*)complicationData {
    if (!_complicationData) {
        _complicationData = [DFCComplicationData sharedComplicationData];
    }
    return _complicationData;
}

- (void)configureTableWithSchedule:(DFCSchedule*)schedule {
    [self.table setNumberOfRows:schedule.meetings.count withRowType:@"scheduleRowType"];
    DFCScheduleRowType* row = nil;
    DFCMeeting* meeting = nil;
    NSUInteger current = NSNotFound;
    for (NSInteger index = 0; index < self.table.numberOfRows; index++) {
        row = [self.table rowControllerAtIndex:index];
        row.meeting = meeting = [schedule meetingAtIndex:index];
        if ([NSDate isPast:meeting.startDate] && [NSDate isFuture:meeting.endDate]) {
            current = index;
            break;
        }
    }
    if (NSNotFound != current) {
        [self.table scrollToRowAtIndex:current];
    }
}
- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex {
    __MESSAGE__(@"WOO-HOO!!!");
    [self pushControllerWithName:(NSString*)kDFCMeetingDetailsInterfaceControllerID context:[self.complicationData.schedule meetingAtIndex:rowIndex]];
}
@end



