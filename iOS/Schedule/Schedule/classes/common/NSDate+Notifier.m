//
//  NSDate(Notifier).m
//  Schedule
//
//  Created by Dmitry Feld on 4/9/16.
//  Copyright © 2016 Dmiry Feld. All rights reserved.
//

#import "NSDate+Notifier.h"

@implementation NSDate(Notifier)
+ (NSDate*) dateFromRESTString:(NSString*)number {
    NSTimeInterval elapsed = (number.doubleValue / 1000.f);
    return [NSDate dateWithTimeIntervalSince1970:elapsed];
}
+ (NSString*) RESTStringFromDate:(NSDate*)date {
    NSTimeInterval elapsed = [date timeIntervalSince1970];
    elapsed *= 1000.f;
    return [NSNumber numberWithInteger:trunc(elapsed)].description;
}
+ (NSDate*) dateFromRESTNumber:(NSNumber*)number {
    if (!number.intValue) {
        return nil;
    }
    NSTimeInterval elapsed = number.doubleValue / 1000.f;
    return [NSDate dateWithTimeIntervalSince1970:elapsed];
}
+ (NSNumber*) RESTNumberFromDate:(NSDate*)date {
    NSTimeInterval elapsed = [date timeIntervalSince1970];
    elapsed *= 1000.f;
    return [NSNumber numberWithInteger:trunc(elapsed)];
}
+ (NSString*) shortDateFormatForDate:(NSDate*)date {
    NSDateFormatter* formatter = [NSDateFormatter new];
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    return [formatter stringFromDate:date];
}
+ (NSString*) shortTimeFormatForDate:(NSDate*)date {
    NSDateFormatter* formatter = [NSDateFormatter new];
    formatter.dateStyle = NSDateFormatterNoStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    return [formatter stringFromDate:date];
}
+ (NSString*) shortFormatForDate:(NSDate*)date {
    return [NSString stringWithFormat:@"%@ - %@",[NSDate shortDateFormatForDate:date],[NSDate shortTimeFormatForDate:date]];
}
+ (BOOL) isPast:(NSDate*)date {
    NSTimeInterval interval = [date timeIntervalSinceNow];
    return (interval < 0);
}
+ (BOOL) isFuture:(NSDate*)date {
    NSTimeInterval interval = [date timeIntervalSinceNow];
    return (interval > 0);
}

@end
