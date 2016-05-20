//
//  DFCModulalLargeSupport.m
//  Schedule
//
//  Created by Dmitry Feld on 4/9/16.
//  Copyright © 2016 Dmiry Feld. All rights reserved.
//

#import "DFCModulalLargeComplicationSupport.h"
#import "DFCSchedule.h"
#import "NSDate+Notifier.h"
#import "DFCComplicationData.h"

#import "DFCTheme.h"

@interface DFCModulalLargeComplicationSupport() {
@private
    CLKComplicationTemplateModularLargeStandardBody* _defaultTemplate;
}

@end

@implementation DFCModulalLargeComplicationSupport
- (CLKComplicationTemplate*) defaultTemplate {
    _defaultTemplate = nil;
    if (!_defaultTemplate) {
        CLKComplicationTemplateModularLargeStandardBody* result = [CLKComplicationTemplateModularLargeStandardBody new];
        result.headerImageProvider = [CLKImageProvider imageProviderWithOnePieceImage:[UIImage imageNamed:@"meeting"]];
        result.headerImageProvider.tintColor = [UIColor whiteColor];
        result.headerTextProvider = [CLKSimpleTextProvider textProviderWithText:@"Meeting"];
        
        result.body1TextProvider = [CLKSimpleTextProvider textProviderWithText:@""];
        result.body2TextProvider = [CLKSimpleTextProvider textProviderWithText:@"Not Scheduled"];
        _defaultTemplate = result;
    }
    return _defaultTemplate;
}

- (CLKComplicationTimelineEntry*) timelineEntryForMeeting:(DFCMeeting*)meeting withDate:(NSDate*)date andState:(DFCComplicationSupportMeetingStates)state {
    CLKComplicationTemplateModularLargeStandardBody* template = self.defaultTemplate;
    if (meeting) {
        NSString* dateLabel = nil;
        NSString* header = [self headerForState:state];
        date = meeting.startDate;
        dateLabel = [NSDate shortTimeFormatForDate:date];
        dateLabel = [NSString stringWithFormat:@"%@ - %@",dateLabel,[NSDate shortTimeFormatForDate:meeting.endDate]];
        NSString* displayName = meeting.displayName;
        template.headerImageProvider = [CLKImageProvider imageProviderWithOnePieceImage:[UIImage imageNamed:@"meeting"]];
        template.headerImageProvider.tintColor = [self tintColorForState:state];
        template.headerTextProvider = [CLKSimpleTextProvider textProviderWithText:header];
        template.headerTextProvider.tintColor = [self tintColorForState:state];
        template.body1TextProvider = [CLKSimpleTextProvider textProviderWithText:displayName];
        template.body2TextProvider = [CLKSimpleTextProvider textProviderWithText:dateLabel];
    }
    return [CLKComplicationTimelineEntry entryWithDate:date complicationTemplate:template];
}
- (NSString*) headerForState:(DFCComplicationSupportMeetingStates)state {
    NSString* result = @"Next Meeting";
    switch (state) {
        case kDFCComplicationSupportMeetingStateStarted:
            result = @"Current Meeting";
            break;
        case kDFCComplicationSupportMeetingStateCompleted:
            result = @"Completed Meeting";
            break;
        case kDFCComplicationSupportMeetingStateNext:
        default:
            break;
    }
    return result;
}
@end
