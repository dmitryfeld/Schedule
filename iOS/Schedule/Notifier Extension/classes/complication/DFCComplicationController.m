//
//  DFCComplicationController.m
//  Notifier Extension
//
//  Created by Dmitry Feld on 4/9/16.
//  Copyright © 2016 Dmiry Feld. All rights reserved.
//

#import <WatchConnectivity/WatchConnectivity.h>
#import "DFCComplicationController.h"
#import "DFCSchedule.h"
#import "NSDate+Notifier.h"
#import "DFCComplicationData.h"

#import "DFCModulalLargeComplicationSupport.h"



@interface DFCComplicationController ()<WCSessionDelegate> {
@private
    WCSession* _watchSession;
    DFCModulalLargeComplicationSupport* _modularLargeSupport;
}
@property (readonly,nonatomic) DFCComplicationData* complicationData;
@property (readonly,nonatomic) WCSession* watchSession;
@property (readonly,nonatomic) DFCModulalLargeComplicationSupport* modularLargeSupport;
@end

@implementation DFCComplicationController
@dynamic complicationData;
@synthesize watchSession = _watchSession;
@synthesize modularLargeSupport = _modularLargeSupport;

- (id) init {
    if (self = [super init]) {
        self.watchSession.delegate = self;
        self.complicationData.schedule = nil;
    }
    return self;
}

#pragma mark - Timeline Configuration

- (void)getSupportedTimeTravelDirectionsForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTimeTravelDirections directions))handler {
    handler(CLKComplicationTimeTravelDirectionForward|CLKComplicationTimeTravelDirectionBackward);
}

- (void)getTimelineStartDateForComplication:(CLKComplication *)complication withHandler:(void(^)(NSDate * __nullable date))handler {
    NSDate* date = nil;
    if (self.complicationData.schedule.hasMeetings) {
        date = [self.complicationData.schedule firstMeeting].startDate;
    }
    handler(date);
}

- (void)getTimelineEndDateForComplication:(CLKComplication *)complication withHandler:(void(^)(NSDate * __nullable date))handler {
    NSDate* date = nil;
    if (self.complicationData.schedule.hasMeetings) {
        date = [self.complicationData.schedule lastMeeting].endDate;
    }
    handler(date);
}

- (void)getPrivacyBehaviorForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationPrivacyBehavior privacyBehavior))handler {
    handler(CLKComplicationPrivacyBehaviorShowOnLockScreen);
}

#pragma mark - Timeline Population

- (void) getCurrentTimelineEntryForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTimelineEntry * __nullable))handler {
    CLKComplicationTimelineEntry* entry = nil;
    if (complication.family == CLKComplicationFamilyModularLarge) {
        NSDate* date = [NSDate date];
        DFCMeeting* current = [self meetingForDate:date];
        DFCComplicationSupportMeetingStates state = kDFCComplicationSupportMeetingStateNext;
        
        if ([DFCMeetingAUX hasMeeting:current endedToDate:date]) {
            DFCMeeting* nextCandidate = [self.complicationData.schedule meetingNextToMeeting:current];
            state = kDFCComplicationSupportMeetingStateCompleted;
            if (![DFCMeetingAUX hasMeeting:nextCandidate startedToDate:date]) {
                state = kDFCComplicationSupportMeetingStateNext;
                current = nextCandidate;
            }
        } else if ([DFCMeetingAUX hasMeeting:current startedToDate:date]) {
            state = kDFCComplicationSupportMeetingStateStarted;
        }
        entry = [self.modularLargeSupport timelineEntryForMeeting:current withDate:date andState:state];
    }
    handler(entry);
}

- (void) getTimelineEntriesForComplication:(CLKComplication *)complication beforeDate:(NSDate *)date limit:(NSUInteger)limit withHandler:(void(^)(NSArray<CLKComplicationTimelineEntry *> * __nullable entries))handler {
    // Call the handler with the timeline entries prior to the given date
    NSMutableArray<CLKComplicationTimelineEntry*>* entries = nil;
    
    if (self.complicationData.schedule.hasMeetings) {
        CLKComplicationTimelineEntry* entry = nil;
        entries = [NSMutableArray<CLKComplicationTimelineEntry*> new];
        DFCMeeting* temp = nil;
        DFCComplicationSupportMeetingStates state = kDFCComplicationSupportMeetingStateNext;
        NSDate* current = date;
        for (NSUInteger index = 0; index < limit; index ++) {
            current = [self previousDate:current];
            if((temp = [self meetingForDate:current])) {
                
                if ([DFCMeetingAUX hasMeeting:temp endedToDate:date]) {
                    state = kDFCComplicationSupportMeetingStateCompleted;
                } else if ([DFCMeetingAUX hasMeeting:temp startedToDate:date]) {
                    state = kDFCComplicationSupportMeetingStateStarted;
                }
                
                entry = [self.modularLargeSupport timelineEntryForMeeting:temp withDate:current andState:state];
                [entries addObject:entry];
            }
        }
    }
    
    handler(entries);
}

- (void)getTimelineEntriesForComplication:(CLKComplication *)complication afterDate:(NSDate *)date limit:(NSUInteger)limit withHandler:(void(^)(NSArray<CLKComplicationTimelineEntry *> * __nullable entries))handler {
    // Call the handler with the timeline entries after to the given date
    NSMutableArray<CLKComplicationTimelineEntry*>* entries = nil;
    
    if (self.complicationData.schedule.hasMeetings) {
        CLKComplicationTimelineEntry* entry = nil;
        entries = [NSMutableArray<CLKComplicationTimelineEntry*> new];
        DFCMeeting* temp = nil;
        DFCComplicationSupportMeetingStates state = kDFCComplicationSupportMeetingStateNext;
        NSDate* current = date;
        for (NSUInteger index = 0; index < limit; index ++) {
            current = [self nextDate:current];
            if((temp = [self meetingForDate:current])) {
                
                if ([DFCMeetingAUX hasMeeting:temp endedToDate:date]) {
                    state = kDFCComplicationSupportMeetingStateCompleted;
                } else if ([DFCMeetingAUX hasMeeting:temp startedToDate:date]) {
                    state = kDFCComplicationSupportMeetingStateStarted;
                }
                
                entry = [self.modularLargeSupport timelineEntryForMeeting:temp withDate:current andState:state];
                [entries addObject:entry];
            }
        }
    }
    
    handler(entries);
}

#pragma mark Update Scheduling
- (void) getNextRequestedUpdateDateWithHandler:(void(^)(NSDate * __nullable updateDate))handler {
    NSDate* date = nil;
    if (self.complicationData.schedule.hasMeetings) {
        date = [self.complicationData.schedule meetingNextToDate:[NSDate date]].startDate;
    }
    handler(date);
}

#pragma mark - Placeholder Templates
- (void)getPlaceholderTemplateForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTemplate * __nullable complicationTemplate))handler {
    CLKComplicationTemplateModularLargeStandardBody* template = nil;
    
    if (complication.family == CLKComplicationFamilyModularLarge) {
        template = self.modularLargeSupport.defaultTemplate;
    }
    
    handler(template);
}

#pragma mark update handlers
- (void) requestedUpdateDidBegin {
    
}
- (void) requestedUpdateBudgetExhausted {
    
}

#pragma mark Meeting finders
- (DFCMeeting*) meetingForDate:(NSDate*)date {
    DFCMeeting* result = [self.complicationData.schedule meetingClosestToDate:date];
    if (![DFCMeetingAUX hasMeeting:result startedToDate:date]) {
        result = [self.complicationData.schedule meetingPreviousToMeeting:result];
    }
    return result;
}

#pragma mark TimeLine service
- (NSDate*) nextDate:(NSDate*)date {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:date];
    components.minute += 10;
    return [calendar dateFromComponents:components];
}
- (NSDate*) previousDate:(NSDate*)date {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:date];
    components.minute -= 10;
    return [calendar dateFromComponents:components];
}

#pragma mark Internal Properties
- (WCSession*) watchSession {
    if (!_watchSession) {
        if ([WCSession isSupported]) {
            _watchSession = [WCSession defaultSession];
            _watchSession.delegate = self;
            [_watchSession activateSession];
        }
    }
    return _watchSession;
}
- (DFCModulalLargeComplicationSupport*) modularLargeSupport {
    if (!_modularLargeSupport) {
        _modularLargeSupport = [DFCModulalLargeComplicationSupport new];
    }
    return _modularLargeSupport;
}
- (DFCComplicationData*) complicationData {
    return [DFCComplicationData sharedComplicationData];
}

#pragma mark ComplicationData updates
- (void) session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *,id> *)applicationContext {
    [self setComplicationDataWithDictionary:applicationContext];
}
- (void) session:(WCSession *)session didReceiveUserInfo:(NSDictionary<NSString *,id> *)userInfo {
    [self setComplicationDataWithDictionary:userInfo];
}
- (void) session:(WCSession *)session didReceiveMessage:(nonnull NSDictionary<NSString *,id> *)message replyHandler:(nonnull void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler {
    [self setComplicationDataWithDictionary:message];
}
- (void) setComplicationDataWithDictionary:(NSDictionary*)dict {
    DFCScheduleKVP* schedule = [DFCScheduleKVP new];
    [schedule setValuesForKeysWithDictionary:dict];
    self.complicationData.schedule = [[DFCScheduleAUX alloc] initWithPrototype:schedule];
}

@end
