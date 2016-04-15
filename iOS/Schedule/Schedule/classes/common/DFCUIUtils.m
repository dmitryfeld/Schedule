//
//  DFCUtils.m
//  Schedule
//
//  Created by Dmitry Feld on 4/9/16.
//  Copyright © 2016 Dmiry Feld. All rights reserved.
//

#import "DFCUIUtils.h"

@implementation DFCUIUtils
+ (CGRect) rectangleWithSize:(CGSize)size aligned:(DFCUICellAlignment)alignment inFrame:(CGRect)frame {
    CGRect result = CGRectZero;
    result.size = size;
    return [DFCUIUtils rectangleWithRectangle:result aligned:alignment inFrame:frame];
}
+ (CGRect) rectangleWithRectangle:(CGRect)rect aligned:(DFCUICellAlignment)alignment inFrame:(CGRect)frame {
    CGRect result = rect;
    
    if (alignment & kDFCUICellAlignmentLeft) {
        result.origin.x = 0.f;
    }
    if (alignment & kDFCUICellAlignmentRight) {
        result.origin.x = frame.size.width - rect.size.width;
    }
    if (kDFCUICellAlignmentHCenter == (alignment & 0x00F0)) {
        result.origin.x = (frame.size.width - rect.size.width) * .5f;
    }
    
    if (alignment & kDFCUICellAlignmentTop) {
        result.origin.y = 0.f;
    }
    if (alignment & kDFCUICellAlignmentBottom) {
        result.origin.y = frame.size.height - rect.size.height;
    }
    if (kDFCUICellAlignmentVCenter == (alignment & 0x000F)) {
        result.origin.y = (frame.size.height - rect.size.height) * .5f;
    }
    
    return result;
}
+ (CGPoint) flipPoint:(CGPoint)point {
    return CGPointMake(point.y, point.x);
}
+ (CGSize) flipSize:(CGSize)size {
    return CGSizeMake(size.height, size.width);
}
+ (CGRect) flipRect:(CGRect)rect {
    return CGRectMake(rect.origin.y,rect.origin.x,rect.size.height,rect.size.width);
}
+ (UIColor*) colorWithRGB:(NSUInteger)rgb {
    return [[UIColor alloc] initWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:1.0];
}
@end
