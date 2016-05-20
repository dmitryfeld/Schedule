//
//  NSDate(Notifier).h
//  Schedule
//
//  Created by Dmitry Feld on 4/9/16.
//  Copyright © 2016 Dmiry Feld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(Notifier)
+ (NSDate*) dateFromRESTString:(NSString*)number;
+ (NSString*) RESTStringFromDate:(NSDate*)date;
+ (NSDate*) dateFromRESTNumber:(NSNumber*)number;
+ (NSNumber*) RESTNumberFromDate:(NSDate*)date;
+ (NSString*) shortDateFormatForDate:(NSDate*)date;
+ (NSString*) shortTimeFormatForDate:(NSDate*)date;
+ (NSString*) shortFormatForDate:(NSDate*)date;
+ (BOOL) isPast:(NSDate*)date;
+ (BOOL) isFuture:(NSDate*)date;
@end
