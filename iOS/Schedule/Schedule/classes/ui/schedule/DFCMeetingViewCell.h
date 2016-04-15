//
//  DFCMeetingViewCell.h
//  Schedule
//
//  Created by Dmitry Feld on 4/9/16.
//  Copyright © 2016 Dmiry Feld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFCMeeting.h"

@interface DFCMeetingViewCell : UITableViewCell
@property (strong,nonatomic) DFCMeeting* meeting;
@property (readonly,nonatomic) BOOL shallBeVisible;
+ (NSString*) reuseIdentifier;
@end
