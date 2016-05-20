//
//  DFCLogger.h
//  Schedule
//
//  Created by Dmitry Feld on 4/9/16.
//  Copyright © 2016 Dmiry Feld. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum __DFCLoggerLevels:NSUInteger {
    kDFCLoggerLevelNone = 0x0000,
    kDFCLoggerLevelError = 0x0001,
    kDFCLoggerLevelWarning = 0x0002,
    kDFCLoggerLevelMessage = 0x0003,
} DFCLoggerLevels;

@protocol DFCLogLineProcessor <NSObject>
@required
- (void) processLine:(NSString*)line;
@end


@interface DFCLogger : NSObject
@property (weak,nonatomic) id<DFCLogLineProcessor> logViewer;
@property (weak,nonatomic) id<DFCLogLineProcessor> logPersister;
@property (assign,nonatomic) DFCLoggerLevels levels;
- (void) logWithLevel:(DFCLoggerLevels)level context:(const char*)context lineNumber:(NSUInteger)lineNumber andFormat:(NSString*)format,...;

- (NSString*) pointToDebugString:(CGPoint) point;
- (NSString*) rectToDebugString:(CGRect) rect;
- (NSString*) sizeToDebugString:(CGSize) size;
- (NSString*) insetsToDebugString:(UIEdgeInsets) insets;
- (NSString*) dateToDebugString:(NSDate*) date;
- (NSString*) timeToDebugString:(NSDate*) date;

+ (DFCLogger*) sharedLogger;
@end


#ifdef DEBUG
#define __MESSAGE__(A, ...) \
[[DFCLogger sharedLogger]   logWithLevel:kDFCLoggerLevelMessage \
context:__PRETTY_FUNCTION__ \
lineNumber:__LINE__ \
andFormat:[NSString stringWithFormat:A, ## __VA_ARGS__]];

#define __WARNING__(A, ...) \
[[DFCLogger sharedLogger]   logWithLevel:kDFCLoggerLevelWarning \
context:__PRETTY_FUNCTION__ \
lineNumber:__LINE__ \
andFormat:[NSString stringWithFormat:A, ## __VA_ARGS__]];

#define __ERROR__(A, ...) \
[[DFCLogger sharedLogger]   logWithLevel:kDFCLoggerLevelError \
context:__PRETTY_FUNCTION__ \
lineNumber:__LINE__ \
andFormat:[NSString stringWithFormat:A, ## __VA_ARGS__]];

#define __LOG__(A, ...) \
[[DFCLogger sharedLogger]   logWithLevel:kDFCLoggerLevelNone \
context:__PRETTY_FUNCTION__ \
lineNumber:__LINE__ \
andFormat:[NSString stringWithFormat:A, ## __VA_ARGS__]];
#else
#define __MESSAGE__(A, ...)
#define __WARNING__(A, ...)
#define __ERROR__(A, ...)
#define __LOG__(A, ...)
#endif



