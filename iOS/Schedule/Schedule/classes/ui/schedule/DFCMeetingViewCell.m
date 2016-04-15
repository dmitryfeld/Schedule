//
//  MeetingViewCell.m
//  Schedule
//
//  Created by Dmitry Feld on 4/9/16.
//  Copyright © 2016 Dmiry Feld. All rights reserved.
//

#import "DFCMeetingViewCell.h"
#import "NSDate+Notifier.h"
#import "DFCTheme.h"

const NSString* __kDFCMeetingsViewControllerCellReuseID = @"__kDFCMeetingsViewControllerCellReuseID";


@interface DFCMeetingViewCell() {
@private
    DFCMeeting* _meeting;
}
@property (strong,nonatomic) IBOutlet UILabel* dateLabel;
@property (strong,nonatomic) IBOutlet UILabel* startTimeLabel;
@property (strong,nonatomic) IBOutlet UILabel* endTimeLabel;
@property (strong,nonatomic) IBOutlet UILabel* nameLabel;
@end

@implementation DFCMeetingViewCell
@synthesize meeting = _meeting;
@synthesize shallBeVisible = _shallBeVisible;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (DFCMeeting*) meeting {
    return _meeting;
}
- (void) setMeeting:(DFCMeeting *)meeting {
    if (![_meeting isEqual:meeting]) {
        _meeting = meeting;
        self.dateLabel.text = [NSDate shortDateFormatForDate:_meeting.startDate];
        self.startTimeLabel.text = [NSDate shortTimeFormatForDate:_meeting.startDate];
        self.endTimeLabel.text = [NSDate shortTimeFormatForDate:_meeting.endDate];
        self.nameLabel.text = meeting.displayName;
        if ([NSDate isFuture:_meeting.startDate]) {
            self.startTimeLabel.textColor = [DFCTheme sharedTheme].futureTimeCellLabelColor;
            self.endTimeLabel.textColor = [DFCTheme sharedTheme].futureTimeCellLabelColor;
            _shallBeVisible = YES;
        } else {
            self.startTimeLabel.textColor = [DFCTheme sharedTheme].pastTimeCellLabelColor;
            self.endTimeLabel.textColor = [DFCTheme sharedTheme].pastTimeCellLabelColor;
            _shallBeVisible = NO;
        }
        if ([NSDate isFuture:_meeting.endDate] && [NSDate isPast:_meeting.startDate]) {
            self.startTimeLabel.font = [DFCTheme sharedTheme].currentTimeCellLabelFont;
            self.endTimeLabel.font = [DFCTheme sharedTheme].currentTimeCellLabelFont;
            self.startTimeLabel.textColor = [DFCTheme sharedTheme].currentTimeCellLabelColor;
            self.endTimeLabel.textColor = [DFCTheme sharedTheme].currentTimeCellLabelColor;
        } else {
            self.startTimeLabel.font = [DFCTheme sharedTheme].notCurrentTimeCellLabelFont;
            self.endTimeLabel.font = [DFCTheme sharedTheme].notCurrentTimeCellLabelFont;
        }
    }
}
+ (NSString*) reuseIdentifier {
    return (NSString*)__kDFCMeetingsViewControllerCellReuseID;
}
@end
