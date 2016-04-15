//
//  DFCLogger.m
//  Schedule
//
//  Created by Dmitry Feld on 4/9/16.
//  Copyright © 2016 Dmiry Feld. All rights reserved.
//

#import "DFCLogger.h"
#import "DFCSingleton.h"

const NSString* __kDFCLoggerTag = @"__kDFCLoggerTag";

@interface DFCLogger()<DFCTagged> {
@private
    __weak id<DFCLogLineProcessor> _logViewer;
    __weak id<DFCLogLineProcessor> _logPersister;
    DFCLoggerLevels _levels;

    __strong NSDateFormatter* _dateFormatter;
    __strong NSDateFormatter* _timeFormatter;
    __strong NSArray* _kDFCLoggerLevelNames;
}
@end

@implementation DFCLogger
@synthesize logViewer = _logViewer;
@synthesize logPersister = _logPersister;
@synthesize levels = _levels;
- (id) init {
    if (self = [super init]) {
        _levels = kDFCLoggerLevelNone;
    }
    return self;
}
- (void) logWithLevel:(DFCLoggerLevels)level context:(const char*)context lineNumber:(NSUInteger)lineNumber andFormat:(NSString*)format,... {
    if (_levels >= level) {
        va_list argList;
        va_start(argList, format);
        NSString *formattedString = [[NSString alloc] initWithFormat:format arguments:argList];
        va_end(argList);
#ifdef DEBUG
        NSLog(@"%@ %s (%6lu): %@",[self levelNameWithLevel:level],context,(unsigned long)lineNumber,formattedString);
        [NSString stringWithFormat:@"%@ - %@",[self timeToDebugString:[NSDate new]],formattedString];
        [_logViewer processLine:formattedString];
#endif
        formattedString = nil;
    }
}
- (NSString*) levelNameWithLevel:(DFCLoggerLevels)level {
    NSString* result = @"       :";
#pragma clang diagnostic ignored "-Wtautological-compare"
    if (level < 4) {
        if (!_kDFCLoggerLevelNames) {
            _kDFCLoggerLevelNames = @[@"       :",@"MESSAGE:",@"WARNING:",@"ERROR  :"];
        }
        result = _kDFCLoggerLevelNames[level];
    }
    return result;
}
- (id) tag {
    return __kDFCLoggerTag;
}
- (NSString*) pointToDebugString:(CGPoint) point {
    return [NSString stringWithFormat:@"X:%f, Y:%f",point.x,point.y];
}
- (NSString*) rectToDebugString:(CGRect) rect {
    return [NSString stringWithFormat:@"X:%f, Y:%f, W:%f, H:%f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height];
}
- (NSString*) sizeToDebugString:(CGSize) size {
    return [NSString stringWithFormat:@"W:%f, H:%f",size.width,size.height];
}
- (NSString*) insetsToDebugString:(UIEdgeInsets) insets {
    return [NSString stringWithFormat:@"T:%f L:%f B:%f R:%f",insets.top,insets.left,insets.bottom,insets.right];
}
- (NSString*) dateToDebugString:(NSDate*) date {
    if (!_dateFormatter) {
        _dateFormatter = [NSDateFormatter new];
        [_dateFormatter setDateFormat:@"dd mm yyyy - HH:mm:ss"];
    }
    return [_dateFormatter stringFromDate:date];
}
- (NSString*) timeToDebugString:(NSDate*) date {
    if (!_timeFormatter) {
        _timeFormatter = [NSDateFormatter new];
        [_timeFormatter setDateFormat:@"HH:mm:ss"];
    }
    return [_timeFormatter stringFromDate:date];
}

+ (DFCLogger*) sharedLogger {
    DFCLogger* result = [DFCSingleton instanceWithTag:__kDFCLoggerTag];
    if (!result) {
        result = [DFCLogger new];
        [DFCSingleton addInstance:result];
    }
    return result;
}
@end
