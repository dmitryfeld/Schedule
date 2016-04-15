//
//  DFCSchedule.h
//  Schedule
//
//  Created by Dmitry Feld on 4/9/16.
//  Copyright © 2016 Dmiry Feld. All rights reserved.
//

#import "DFCMeeting.h"

typedef enum __DFCScheduleSYMTypes__:NSInteger {
    kDFCScheduleSYMType30Min,
    kDFCScheduleSYMType1Hour,
    kDFCScheduleSYMType2Hours
} DFCScheduleSYMTypes;


@class DFCMutableSchedule;
@interface DFCSchedule : DFCModel
@property (readonly,nonatomic) NSArray<DFCMeeting*>*meetings;
@property (readonly,nonatomic) BOOL hasMeetings;
- (id) initWithPrototype:(DFCSchedule *)prototype;
- (DFCMutableSchedule*) mutableCopy;
- (DFCMeeting*) firstMeeting;
- (DFCMeeting*) lastMeeting;
- (DFCMeeting*) meetingAtIndex:(NSUInteger)index;
@end

@interface DFCMutableSchedule : DFCSchedule
@property (nonatomic,setter=setMeetings:) NSMutableArray<DFCMeeting*>*meetings;
- (DFCSchedule*) immutableCopy;
@end

@interface DFCScheduleKVP : DFCMutableSchedule
@end

@interface DFCScheduleAUX : DFCSchedule
- (DFCMeeting*) meetingClosestToDate:(NSDate*)date;
- (DFCMeeting*) meetingPreviousToDate:(NSDate*)date;
- (DFCMeeting*) meetingNextToDate:(NSDate*)date;
- (DFCMeeting*) meetingClosestToMeeting:(DFCMeeting*)meeting;
- (DFCMeeting*) meetingPreviousToMeeting:(DFCMeeting*)meeting;
- (DFCMeeting*) meetingNextToMeeting:(DFCMeeting*)meeting;

+ (DFCMeeting*) meetingClosestToDate:(NSDate*)date forSchedule:(DFCSchedule*)schedule;
+ (DFCMeeting*) meetingPreviousToDate:(NSDate*)date forSchedule:(DFCSchedule*)schedule;
+ (DFCMeeting*) meetingNextToDate:(NSDate*)date forSchedule:(DFCSchedule*)schedule;
+ (DFCMeeting*) meetingClosestToMeeting:(DFCMeeting*)meeting forSchedule:(DFCSchedule*)schedule;
+ (DFCMeeting*) meetingPreviousToMeeting:(DFCMeeting*)meeting forSchedule:(DFCSchedule*)schedule;
+ (DFCMeeting*) meetingNextToMeeting:(DFCMeeting*)meeting forSchedule:(DFCSchedule*)schedule;
@end

@interface DFCScheduleSYM : DFCSchedule
+ (DFCSchedule*) simulatedScheduleWithType:(DFCScheduleSYMTypes)type;
@end