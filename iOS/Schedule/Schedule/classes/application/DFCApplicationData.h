//
//  DFCApplicationData.h
//  Schedule
//
//  Created by Dmitry Feld on 4/9/16.
//  Copyright © 2016 Dmiry Feld. All rights reserved.
//

#import "DFCSchedule.h"

extern const NSString* kDFCApplicationDataScheduleUpdated;

@interface DFCApplicationData : NSObject
@property (readonly,nonatomic,strong) DFCSchedule* schedule;
- (void) refresh;
+ (DFCApplicationData*) sharedApplicationData;
@end
