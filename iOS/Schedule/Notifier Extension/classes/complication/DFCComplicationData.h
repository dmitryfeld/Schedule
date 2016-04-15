//
//  DFCComplicationData.h
//  Schedule
//
//  Created by Dmitry Feld on 4/11/16.
//  Copyright © 2016 Dmiry Feld. All rights reserved.
//

#import "DFCSchedule.h"

@interface DFCComplicationData : NSObject
@property (strong,nonatomic) DFCScheduleAUX* schedule;
+ (DFCComplicationData*) sharedComplicationData;
@end
