//
//  DFCTheme.h
//  Schedule
//
//  Created by Dmitry Feld on 4/9/16.
//  Copyright © 2016 Dmiry Feld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DFCTheme : NSObject
@property (strong,readonly,nonatomic) UIColor *futureTimeCellLabelColor;
@property (strong,readonly,nonatomic) UIColor *pastTimeCellLabelColor;
@property (strong,readonly,nonatomic) UIColor *currentTimeCellLabelColor;
@property (strong,readonly,nonatomic) UIFont *currentTimeCellLabelFont;
@property (strong,readonly,nonatomic) UIFont *notCurrentTimeCellLabelFont;

@property (strong,readonly,nonatomic) UIColor* completedMeetingTintColor;
@property (strong,readonly,nonatomic) UIColor* startedMeetingTintColor;
@property (strong,readonly,nonatomic) UIColor* nextMeetingTintColor;
+ (DFCTheme*)sharedTheme;
@end
