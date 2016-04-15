//
//  DFCSchedule.m
//  Schedule
//
//  Created by Dmitry Feld on 4/9/16.
//  Copyright © 2016 Dmiry Feld. All rights reserved.
//

#import "DFCSchedule.h"
#import "NSDate+Notifier.h"
#import "DFCLogger.h"

@interface DFCSchedule() {
@protected
    id _meetings;
}

@end

@implementation DFCSchedule
@dynamic meetings;
@dynamic hasMeetings;
- (id) init {
    if (self = [super init]) {
        _meetings = [NSArray<DFCMeeting*> new];
    }
    return self;
}
- (id) initWithPrototype:(DFCSchedule *)prototype {
    if (self = [super init]) {
        _meetings = [[NSArray<DFCMeeting*> alloc] initWithArray:prototype.meetings copyItems:YES];
    }
    return self;
}
- (NSDictionary*) dictionary {
    NSMutableDictionary* result = [NSMutableDictionary new];
    NSMutableArray* meetings = [NSMutableArray new];
    for (DFCMeeting* temp in _meetings) {
        [meetings addObject:temp.dictionary];
    }
    [result setObject:meetings forKey:@"meetings"];
    return [NSDictionary dictionaryWithDictionary:result];
}
- (id) copyWithZone:(NSZone *)zone {
    return [[DFCSchedule alloc] initWithPrototype:self];
}
- (DFCMutableSchedule*) mutableCopy {
    return [[DFCMutableSchedule alloc] initWithPrototype:self];
}
- (BOOL) isEqual:(id)object {
    if (![object isKindOfClass:[DFCMeeting class]]) {
        return NO;
    }
    DFCSchedule* schedule = (DFCSchedule*)object;
    if (![_meetings isEqualToArray:schedule.meetings]) {
        return NO;
    }
    return YES;
}
- (NSArray<DFCMeeting*>*) meetings {
    return (NSArray<DFCMeeting*>*)_meetings;
}
- (BOOL) hasMeetings {
    return self.meetings.count;
}
- (DFCMeeting*) firstMeeting {
    DFCMeeting* result = nil;
    if (self.meetings.count) {
        result = [self.meetings firstObject];
    }
    return result;
}
- (DFCMeeting*) lastMeeting {
    DFCMeeting* result = nil;
    if (self.meetings.count) {
        result = [self.meetings lastObject];
    }
    return result;
}
- (DFCMeeting*) meetingAtIndex:(NSUInteger)index {
    DFCMeeting* result = nil;
    if (index < self.meetings.count) {
        result = self.meetings[index];
    }
    return result;
}
@end


@implementation  DFCMutableSchedule
@dynamic meetings;
- (id) init {
    if (self = [super init]) {
        _meetings = [NSMutableArray<DFCMeeting*> new];
    }
    return self;
}
- (id) initWithPrototype:(DFCSchedule *)prototype {
    if (self = [super init]) {
        _meetings = [[NSMutableArray<DFCMeeting*> alloc] initWithArray:prototype.meetings copyItems:YES];
    }
    return self;
}
- (DFCSchedule*) immutableCopy {
    return [[DFCSchedule alloc] initWithPrototype:self];
}
- (NSMutableArray<DFCMeeting*>*) meetings {
    NSMutableArray<DFCMeeting*>* result = (NSMutableArray<DFCMeeting*>*)_meetings;
    if (![result isKindOfClass:[NSMutableArray<DFCMeeting*> class]]) {
        result = [[NSMutableArray<DFCMeeting*> alloc] initWithArray:_meetings copyItems:YES];
        _meetings = result;
    }
    return result;
}
- (void) setMeetings:(NSMutableArray<DFCMeeting *> *)meetings {
    _meetings = [[NSMutableArray<DFCMeeting*> alloc] initWithArray:meetings copyItems:YES];
}

@end

@implementation DFCScheduleKVP : DFCMutableSchedule
- (void) setValue:(id)value forUndefinedKey:(NSString *)key {
    __WARNING__(@"!!!UNKNOWN KEY: [%@,%@]",NSStringFromClass([self class]),key);
}
- (void) setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"meetings"]) {
        NSMutableArray<DFCMeeting*>* tempMeetings = (NSMutableArray<DFCMeeting*>*)_meetings;
        if (![tempMeetings isKindOfClass:[NSMutableArray<DFCMeeting*> class]]) {
            tempMeetings = [[NSMutableArray<DFCMeeting*> alloc] initWithArray:_meetings copyItems:YES];
        }
        if ([value isKindOfClass:[NSArray class]]) {
            NSArray* meetings = (NSArray*)value;
            DFCMeetingKVP* temp = nil;
            for (id meeting in meetings) {
                if ([meeting isKindOfClass:[NSDictionary class]]) {
                    temp = [DFCMeetingKVP new];
                    [temp setValuesForKeysWithDictionary:meeting];
                    [tempMeetings addObject:[temp immutableCopy]];
                } else if ([meetings isKindOfClass:[DFCMeeting class]]) {
                    [tempMeetings addObject:meeting];
                } else {
                    __WARNING__(@"!!!INVALID DATA TYPE FOR KEY:[%@,%@]",NSStringFromClass([self class]),key);
                }
            }
        } else {
            __WARNING__(@"!!!INVALID DATA TYPE FOR KEY:[%@,%@]",NSStringFromClass([self class]),key);
        }
    } else {
        [super setValue:value forKey:key];
    }
}
@end

@implementation DFCScheduleAUX
- (DFCMeeting*) meetingClosestToDate:(NSDate*)date {
    DFCMeeting* result = nil;
    if (self.meetings.count) {
        NSTimeInterval interval = 0.;
        NSTimeInterval minInterval = 1000000000.0;
        for (DFCMeeting* meeting in self.meetings) {
            interval = [meeting.startDate timeIntervalSinceDate:date];
            if (interval < 0) {
                interval *= -1.;
            }
            if (interval < minInterval) {
                minInterval = interval;
                result = meeting;
            }
        }
    }
    return result;
}
- (DFCMeeting*) meetingPreviousToDate:(NSDate*)date {
    DFCMeeting* result = nil;
    if (self.meetings.count) {
        DFCMeeting* closest = [self meetingClosestToDate:date];
        if (closest) {
            NSUInteger index = [_meetings indexOfObject:closest];
            if (NSNotFound != index) {
                if (index > 0) {
                    index --;
                    result = [self meetingAtIndex:index];
                }
            }
        }
    }
    return result;
}
- (DFCMeeting*) meetingNextToDate:(NSDate*)date {
    DFCMeeting* result = nil;
    if (self.meetings.count) {
        DFCMeeting* closest = [self meetingClosestToDate:date];
        if (closest) {
            NSUInteger index = [_meetings indexOfObject:closest];
            if (NSNotFound != index) {
                if (index < self.meetings.count) {
                    index ++;
                    result = [self meetingAtIndex:index];
                }
            }
        }
    }
    return result;
}
- (DFCMeeting*) meetingClosestToMeeting:(DFCMeeting*)meeting {
    return [self meetingClosestToDate:meeting.startDate];
}
- (DFCMeeting*) meetingPreviousToMeeting:(DFCMeeting*)meeting {
    DFCMeeting* result = nil;
    NSUInteger index = [self.meetings indexOfObject:meeting];
    if (NSNotFound != index) {
        if (index > 0) {
            index --;
            result = [self meetingAtIndex:index];
        }
    } else {
        result = [self meetingPreviousToDate:meeting.startDate];
    }
    return result;
}
- (DFCMeeting*) meetingNextToMeeting:(DFCMeeting*)meeting {
    DFCMeeting* result = nil;
    NSUInteger index = [self.meetings indexOfObject:meeting];
    if (NSNotFound != index) {
        if (index < self.meetings.count) {
            index ++;
            result = [self meetingAtIndex:index];
        }
    } else {
        result = [self meetingNextToDate:meeting.startDate];
    }
    return result;
}

+ (DFCMeeting*) meetingClosestToDate:(NSDate*)date forSchedule:(DFCSchedule*)schedule {
    DFCMeeting* result = nil;
    if (schedule.meetings.count) {
        NSTimeInterval interval = 0.;
        NSTimeInterval minInterval = 1000000000.0;
        for (DFCMeeting* meeting in schedule.meetings) {
            interval = [meeting.startDate timeIntervalSinceDate:date];
            if (interval < 0) {
                interval *= -1.;
            }
            if (interval < minInterval) {
                minInterval = interval;
                result = meeting;
            }
        }
    }
    return result;
}
+ (DFCMeeting*) meetingPreviousToDate:(NSDate*)date forSchedule:(DFCSchedule*)schedule {
    DFCMeeting* result = nil;
    if (schedule.meetings.count) {
        DFCMeeting* closest = [DFCScheduleAUX meetingClosestToDate:date forSchedule:schedule];
        if (closest) {
            NSUInteger index = [schedule.meetings indexOfObject:closest];
            if (NSNotFound != index) {
                if (index > 0) {
                    index --;
                    result = [schedule meetingAtIndex:index];
                }
            }
        }
    }
    return result;
}
+ (DFCMeeting*) meetingNextToDate:(NSDate*)date forSchedule:(DFCSchedule*)schedule {
    DFCMeeting* result = nil;
    if (schedule.meetings.count) {
        DFCMeeting* closest = [DFCScheduleAUX meetingClosestToDate:date forSchedule:schedule];
        if (closest) {
            NSUInteger index = [schedule.meetings indexOfObject:closest];
            if (NSNotFound != index) {
                if (index < schedule.meetings.count) {
                    index ++;
                    result = [schedule meetingAtIndex:index];
                }
            }
        }
    }
    return result;
}
+ (DFCMeeting*) meetingClosestToMeeting:(DFCMeeting*)meeting forSchedule:(DFCSchedule*)schedule {
    return [DFCScheduleAUX meetingClosestToDate:meeting.startDate forSchedule:schedule];
}
+ (DFCMeeting*) meetingPreviousToMeeting:(DFCMeeting*)meeting forSchedule:(DFCSchedule*)schedule {
    DFCMeeting* result = nil;
    NSUInteger index = [schedule.meetings indexOfObject:meeting];
    if (NSNotFound != index) {
        if (index > 0) {
            index --;
            result = [schedule meetingAtIndex:index];
        }
    } else {
        result = [DFCScheduleAUX meetingPreviousToDate:meeting.startDate forSchedule:schedule];
    }
    return result;
}
+ (DFCMeeting*) meetingNextToMeeting:(DFCMeeting*)meeting forSchedule:(DFCSchedule*)schedule {
    DFCMeeting* result = nil;
    NSUInteger index = [schedule.meetings indexOfObject:meeting];
    if (NSNotFound != index) {
        if (index < schedule.meetings.count) {
            index ++;
            result = [schedule meetingAtIndex:index];
        }
    } else {
        result = [DFCScheduleAUX meetingNextToDate:meeting.startDate forSchedule:schedule];
    }
    return result;
}
@end

@implementation DFCScheduleSYM
+ (DFCSchedule*) simulatedScheduleWithType:(DFCScheduleSYMTypes)type {
    switch (type) {
        case kDFCScheduleSYMType1Hour:
            return [DFCScheduleSYM everyHour];
        case kDFCScheduleSYMType30Min:
            return [DFCScheduleSYM every30Minutes];
        case kDFCScheduleSYMType2Hours:
        default:
            return [DFCScheduleSYM every2Hours];
    }
}
+ (DFCSchedule*) every30Minutes {
    DFCMutableSchedule* result = [DFCMutableSchedule new];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* today = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour fromDate:[self today0AM]];
    today.minute += 1;
    NSDate* temp = nil;
    NSArray* names = [DFCScheduleSYM names48];
    DFCMutableMeeting* meeting = nil;
    for (NSUInteger index = 0; index < names.count; index ++) {
        temp = [calendar dateFromComponents:today];
        meeting = [DFCMutableMeeting new];
        meeting.startDate = temp;
        meeting.endDate = [temp dateByAddingTimeInterval:25*60.];
        meeting.displayName = [names objectAtIndex:index];
        [result.meetings addObject:meeting];
        today.minute += 30;
    }
    return [result immutableCopy];
}
+ (DFCSchedule*) everyHour {
    DFCMutableSchedule* result = [DFCMutableSchedule new];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* today = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour fromDate:[self today0AM]];
    NSDate* temp = nil;
    NSArray* names = [DFCScheduleSYM names24];
    DFCMutableMeeting* meeting = nil;
    for (NSUInteger index = 0; index < names.count; index ++) {
        temp = [calendar dateFromComponents:today];
        meeting = [DFCMutableMeeting new];
        meeting.startDate = temp;
        meeting.endDate = [temp dateByAddingTimeInterval:45*60.];
        meeting.displayName = [names objectAtIndex:index];
        [result.meetings addObject:meeting];
        today.hour += 1;
    }
    return [result immutableCopy];
}
+ (DFCSchedule*) every2Hours {
    DFCMutableSchedule* result = [DFCMutableSchedule new];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* today = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour fromDate:[self today0AM]];
    NSDate* temp = nil;
    NSArray* names = [DFCScheduleSYM names12];
    DFCMutableMeeting* meeting = nil;
    for (NSUInteger index = 0; index < names.count; index ++) {
        temp = [calendar dateFromComponents:today];
        meeting = [DFCMutableMeeting new];
        meeting.startDate = temp;
        meeting.endDate = [temp dateByAddingTimeInterval:(45+60)*60.];
        meeting.displayName = [names objectAtIndex:index];
        [result.meetings addObject:meeting];
        today.hour += 2;
    }
    return [result immutableCopy];
}

+ (NSDate*) today0AM {
    NSDate* today = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour fromDate:today];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [calendar dateFromComponents:components];
}

+ (NSArray*) names48 {
    return @[@"At 00:00",@"At 00:30",@"At 01:00",
             @"At 01:30",@"At 02:00",@"At 02:30",
             @"At 03:00",@"At 03:30",@"At 04:00",
             @"At 04:30",@"At 05:00",@"At 05:30",
             @"At 06:00",@"At 06:30",@"At 07:00",
             @"At 07:30",@"At 08:00",@"At 08:30",
             @"At 09:00",@"At 09:30",@"At 10:00",
             @"At 10:30",@"At 11:00",@"At 11:30",
             @"At 12:00",@"At 12:30",@"At 13:00",
             @"At 13:30",@"At 14:00",@"At 14:30",
             @"At 15:00",@"At 15:30",@"At 16:00",
             @"At 16:30",@"At 17:00",@"At 17:30",
             @"At 18:00",@"At 18:30",@"At 19:00",
             @"At 19:30",@"At 20:00",@"At 20:30",
             @"At 21:00",@"At 21:30",@"At 22:00",
             @"At 22:30",@"At 23:00",@"At 23:30"];
}
+ (NSArray*) names24 {
    return @[@"At 00:00",@"At 01:00",@"At 02:00",
             @"At 03:00",@"At 04:00",@"At 05:00",
             @"At 06:00",@"At 07:00",@"At 08:00",
             @"At 09:00",@"At 10:00",@"At 11:00",
             @"At 12:00",@"At 13:00",@"At 14:00",
             @"At 15:00",@"At 16:00",@"At 17:00",
             @"At 18:00",@"At 19:00",@"At 20:00",
             @"At 21:00",@"At 22:00",@"At 23:00"];
}
+ (NSArray*) names12 {
    return @[@"At 00:00",@"At 02:00",@"At 04:00",
             @"At 06:00",@"At 08:00",@"At 10:00",
             @"At 12:00",@"At 14:00",@"At 16:00",
             @"At 18:00",@"At 20:00",@"At 22:00"];
}

@end