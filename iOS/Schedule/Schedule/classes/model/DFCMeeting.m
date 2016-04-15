//
//  Meeting.m
//  Notifier
//
//  Created by Dmitry Feld on 4/7/16.
//  Copyright © 2016 Dmiry Feld. All rights reserved.
//

#import "DFCMeeting.h"
#import "NSDate+Notifier.h"
#import "DFCLogger.h"
@interface DFCMeeting()<NSCopying> {
@protected
    NSDate* _startDate;
    NSDate* _endDate;
    NSString* _displayName;
}
@end

@implementation DFCMeeting
@synthesize startDate = _startDate;
@synthesize endDate = _endDate;
@synthesize displayName = _displayName;
- (id) initWithPrototype:(DFCMeeting *)prototype {
    if (self = [super init]) {
        _startDate = [prototype.startDate copy];
        _endDate = [prototype.endDate copy];
        _displayName = [prototype.displayName copy];
    }
    return self;
}
- (NSDictionary*) dictionary {
    NSMutableDictionary* result = [NSMutableDictionary new];
    [result setObject:[NSDate RESTStringFromDate:_startDate] forKey:@"startDate"];
    [result setObject:[NSDate RESTStringFromDate:_endDate] forKey:@"endDate"];
    [result setObject:_displayName forKey:@"displayName"];
    return [NSDictionary dictionaryWithDictionary:result];
}
- (id) copyWithZone:(NSZone *)zone {
    return [[DFCMeeting alloc] initWithPrototype:self];
}
- (DFCMutableMeeting*) mutableCopy {
    return [[DFCMutableMeeting alloc] initWithPrototype:self];
}
- (BOOL) isEqual:(id)object {
    if (![object isKindOfClass:[DFCMeeting class]]) {
        return NO;
    }
    DFCMeeting* meeting = (DFCMeeting*)object;
    if (![_startDate isEqual:meeting.startDate]) {
        return NO;
    }
    if (![_endDate isEqual:meeting.endDate]) {
        return NO;
    }
    if (![_displayName isEqualToString:meeting.displayName]) {
        return NO;
    }
    return YES;
}
@end

@implementation DFCMutableMeeting
@dynamic startDate;
@dynamic endDate;
@dynamic displayName;
- (void) setStartDate:(NSDate *)startDate {
    _startDate = [startDate copy];
}
- (void) setEndDate:(NSDate *)endDate {
    _endDate = [endDate copy];
}
- (void) setDisplayName:(NSString *)displayName {
    _displayName = [displayName copy];
}
- (DFCMeeting*) immutableCopy {
    return [[DFCMeeting alloc] initWithPrototype:self];
}
@end

@implementation DFCMeetingKVP
- (void) setValue:(id)value forUndefinedKey:(NSString *)key {
    __WARNING__(@"!!!UNKNOWN KEY: [%@,%@]",NSStringFromClass([self class]),key);
}
- (void) setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"startDate"]) {
        if ([value isKindOfClass:[NSString class]]) {
            NSDate* temp = [NSDate dateFromRESTString:value];
            _startDate = temp;
        } else if ([value isKindOfClass:[NSDate class]]) {
            _startDate = (NSDate*)[value copy];
        } else {
            __WARNING__(@"!!!INVALID DATA TYPE FOR KEY:[%@,%@]",NSStringFromClass([self class]),key);
        }
    } else if([key isEqualToString:@"endDate"]) {
        if ([value isKindOfClass:[NSString class]]) {
            NSDate* temp = [NSDate dateFromRESTString:value];
            _endDate = temp;
        } else if ([value isKindOfClass:[NSDate class]]) {
            _endDate = (NSDate*)[value copy];
        } else {
            __WARNING__(@"!!!INVALID DATA TYPE FOR KEY:[%@,%@]",NSStringFromClass([self class]),key);
        }
    } else {
        [super setValue:value forKey:key];
    }
}
@end


@implementation DFCMeetingAUX
- (BOOL) hasStartedToDate:(NSDate*)date {
    NSTimeInterval interval = [self.startDate timeIntervalSinceDate:date];
    return interval < 0;
}
- (BOOL) hasEndedToDate:(NSDate*)date {
    NSTimeInterval interval = [self.endDate timeIntervalSinceDate:date];
    return interval < 0;
}
- (BOOL) isToDate:(NSDate*)date {
    return [self hasStartedToDate:date] && (![self hasEndedToDate:date]);
}
+ (BOOL) hasMeeting:(DFCMeeting*)meeting startedToDate:(NSDate*)date {
    NSTimeInterval interval = [meeting.startDate timeIntervalSinceDate:date];
    return interval < 0;
}
+ (BOOL) hasMeeting:(DFCMeeting*)meeting endedToDate:(NSDate*)date {
    NSTimeInterval interval = [meeting.endDate timeIntervalSinceDate:date];
    return interval < 0;
}
+ (BOOL) isMeeting:(DFCMeeting*)meeting toDate:(NSDate*)date {
    return [DFCMeetingAUX hasMeeting:meeting startedToDate:date] && (![DFCMeetingAUX hasMeeting:meeting endedToDate:date]);
}
@end



