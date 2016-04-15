//
//  Meeting.h
//  Notifier
//
//  Created by Dmitry Feld on 4/7/16.
//  Copyright © 2016 Dmiry Feld. All rights reserved.
//

#import "DFCModel.h"

@class DFCMutableMeeting;
@interface DFCMeeting : DFCModel
@property (readonly,nonatomic) NSDate* startDate;
@property (readonly,nonatomic) NSDate* endDate;
@property (readonly,nonatomic) NSString* displayName;
- (id) initWithPrototype:(DFCMeeting*)prototype;
- (DFCMutableMeeting*) mutableCopy;
@end

@interface DFCMutableMeeting : DFCMeeting
@property (nonatomic,setter=setStartDate:) NSDate* startDate;
@property (nonatomic,setter=setEndDate:) NSDate* endDate;
@property (nonatomic,setter=setDisplayName:) NSString* displayName;
- (DFCMeeting*) immutableCopy;
@end

@interface DFCMeetingKVP : DFCMutableMeeting
@end


@interface DFCMeetingAUX : DFCMeeting
- (BOOL) hasStartedToDate:(NSDate*)date;
- (BOOL) hasEndedToDate:(NSDate*)date;
- (BOOL) isToDate:(NSDate*)date;
+ (BOOL) hasMeeting:(DFCMeeting*)meeting startedToDate:(NSDate*)date;
+ (BOOL) hasMeeting:(DFCMeeting*)meeting endedToDate:(NSDate*)date;
+ (BOOL) isMeeting:(DFCMeeting*)meeting toDate:(NSDate*)date;
@end