//
//  DFCModel.h
//  Schedule
//
//  Created by Dmitry Feld on 4/9/16.
//  Copyright © 2016 Dmiry Feld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFCModel : NSObject
@property (readonly,nonatomic,strong) NSDictionary* dictionary;
- (id) initWithPrototype:(DFCModel*)prototype;
@end
