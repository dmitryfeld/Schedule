//
//  DFCTheme.m
//  Schedule
//
//  Created by Dmitry Feld on 4/9/16.
//  Copyright © 2016 Dmiry Feld. All rights reserved.
//

#import "DFCTheme.h"
#import "DFCUIUtils.h"
#import "DFCSingleton.h"

const NSString* __kDFCThemeTag = @"__kDFCThemeTag";

@interface DFCTheme()<DFCTagged> {
@private
    UIColor* _futureTimeCellLabelColor;
    UIColor* _pastTimeCellLabelColor;
}
@end

@implementation DFCTheme
@synthesize futureTimeCellLabelColor = _futureTimeCellLabelColor;
@synthesize pastTimeCellLabelColor = _pastTimeCellLabelColor;
@synthesize currentTimeCellLabelColor = _currentTimeCellLabelColor;
@synthesize currentTimeCellLabelFont = _currentTimeCellLabelFont;
@synthesize notCurrentTimeCellLabelFont = _notCurrentTimeCellLabelFont;

- (id) init {
    if (self = [super init]) {
        _futureTimeCellLabelColor = [DFCUIUtils colorWithRGB:0x157B11];
        _pastTimeCellLabelColor = [DFCUIUtils colorWithRGB:0x7B1511];
        _currentTimeCellLabelColor = [DFCUIUtils colorWithRGB:0x55BB51];
        _currentTimeCellLabelFont = [UIFont boldSystemFontOfSize:11.];
        _notCurrentTimeCellLabelFont = [UIFont systemFontOfSize:11.];
    }
    return self;
}
- (id) tag {
    return __kDFCThemeTag;
}
+ (DFCTheme*)sharedTheme {
    DFCTheme* result = [DFCSingleton instanceWithTag:__kDFCThemeTag];
    if (!result) {
        result = [DFCTheme new];
        [DFCSingleton addInstance:result];
    }
    return result;
}
@end
