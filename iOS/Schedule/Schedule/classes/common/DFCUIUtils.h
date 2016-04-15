//
//  DFCUIUtils.h
//  Schedule
//
//  Created by Dmitry Feld on 4/9/16.
//  Copyright © 2016 Dmiry Feld. All rights reserved.
//
#import <UIKit/UIKit.h>

// macros for idiom detection. Needed of Tablet vs. iPhone UX changes
#define __IS_IPAD__ ([[UIDevice currentDevice] userInterfaceIdiom]  == UIUserInterfaceIdiomPad)
#define __IS_IPHONE__ ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)

#define __SCREEN_WIDTH__ ([[UIScreen mainScreen] bounds].size.width)
#define __SCREEN_HEIGHT__ ([[UIScreen mainScreen] bounds].size.height)
#define __SCREEN_MAX_LENGTH__ (MAX(__SCREEN_WIDTH__, __SCREEN_HEIGHT__))
#define __SCREEN_MIN_LENGTH__ (MIN(__SCREEN_WIDTH__, __SCREEN_HEIGHT__))

#define __IS_IPHONE_4_OR_LESS__ (__IS_IPHONE__ && __SCREEN_MAX_LENGTH__ < 568.0)

typedef enum __DFCUICellAlignment__ {
    kDFCUICellAlignmentTop = 0x0001,
    kDFCUICellAlignmentBottom = 0x0002,
    kDFCUICellAlignmentVCenter = 0x0003,
    kDFCUICellAlignmentLeft = 0x0010,
    kDFCUICellAlignmentRight = 0x0020,
    kDFCUICellAlignmentHCenter = 0x0030
} DFCUICellAlignment;

@interface DFCUIUtils : NSObject
+ (CGRect) rectangleWithSize:(CGSize)size aligned:(DFCUICellAlignment)aligment inFrame:(CGRect)frame;
+ (CGRect) rectangleWithRectangle:(CGRect)rect aligned:(DFCUICellAlignment)aligment inFrame:(CGRect)frame;
+ (CGPoint) flipPoint:(CGPoint)point;
+ (CGSize) flipSize:(CGSize)size;
+ (CGRect) flipRect:(CGRect)rect;
+ (UIColor*) colorWithRGB:(NSUInteger)rgb;
@end

