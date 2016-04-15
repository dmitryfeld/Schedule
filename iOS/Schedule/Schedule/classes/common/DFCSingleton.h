//
//  DFCSingleton.h
//  Schedule
//
//  Created by Dmitry Feld on 4/9/16.
//  Copyright © 2016 Dmiry Feld. All rights reserved.
//
//

#import "DFCTagged.h"

@interface DFCSingleton : NSObject
- (id) init;
- (void) dealloc;
+ (id) instanceWithTag:(id)tag;
+ (void) addInstance:(id<DFCTagged>)instance;
+ (void) removeInstance:(id<DFCTagged>)instance;
@end
