//
//  DFCUtilitarianLargeComplicationSupport.m
//  Schedule
//
//  Created by Dmitry Feld on 4/9/16.
//  Copyright © 2016 Dmiry Feld. All rights reserved.
//

#import "DFCUtilitarianLargeComplicationSupport.h"
#import "DFCSchedule.h"
#import "NSDate+Notifier.h"
#import "DFCComplicationData.h"

#import "DFCTheme.h"

@interface DFCUtilitarianLargeComplicationSupport() {
@private
    CLKComplicationTemplateUtilitarianLargeFlat* _defaultTemplate;
}

@end

@implementation DFCUtilitarianLargeComplicationSupport
- (CLKComplicationTemplate*) defaultTemplate {
    _defaultTemplate = nil;
    if (!_defaultTemplate) {
        CLKComplicationTemplateUtilitarianLargeFlat *result = [CLKComplicationTemplateUtilitarianLargeFlat new];
        result.imageProvider = [CLKImageProvider imageProviderWithOnePieceImage:[UIImage imageNamed:@"meeting"]];
        result.imageProvider.tintColor = [UIColor whiteColor];
        result.textProvider = [CLKSimpleTextProvider textProviderWithText:@"Not Scheduled"];
        
        _defaultTemplate = result;
    }
    return _defaultTemplate;
}

- (CLKComplicationTimelineEntry*) timelineEntryForMeeting:(DFCMeeting*)meeting withDate:(NSDate*)date andState:(DFCComplicationSupportMeetingStates)state {
    CLKComplicationTemplateUtilitarianLargeFlat* template = self.defaultTemplate;
    if (meeting) {
        NSString* label = nil;
        date = meeting.startDate;
        label = [NSDate shortTimeFormatForDate:date];
        label = [NSString stringWithFormat:@"%@ - %@",label,meeting.displayName];
        
        template.imageProvider = [CLKImageProvider imageProviderWithOnePieceImage:[UIImage imageNamed:@"meeting"]];
        template.imageProvider.tintColor = [self tintColorForState:state];
        template.textProvider = [CLKSimpleTextProvider textProviderWithText:label];
        template.textProvider.tintColor = [self tintColorForState:state];
    }
    return [CLKComplicationTimelineEntry entryWithDate:date complicationTemplate:template];
}
@end
