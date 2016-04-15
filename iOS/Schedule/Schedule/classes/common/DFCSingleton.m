//
//  DFCSingleton.m
//  Schedule
//
//  Created by Dmitry Feld on 4/9/16.
//  Copyright © 2016 Dmiry Feld. All rights reserved.
//
//

#import "DFCSingleton.h"

@interface DFCSingleton() {
@private
    NSMutableDictionary* _content;
}
+ (DFCSingleton*) _sharedInstance;
- (NSMutableDictionary*) _content;
@end

static DFCSingleton  *__kDFCSingletonSharedInstance = nil;

@implementation DFCSingleton
+ (DFCSingleton*) _sharedInstance {
	@synchronized(self) {
		if (nil == __kDFCSingletonSharedInstance) {
            __kDFCSingletonSharedInstance = [[DFCSingleton alloc] init];
        }
	}
	return __kDFCSingletonSharedInstance;
}

+ (id) allocWithZone:(NSZone*)_zone {
	@synchronized(self) {
		NSAssert
        (
            __kDFCSingletonSharedInstance == nil,
            @"Attempted to allocate a second instance of a DFCSingleton."
        );
		__kDFCSingletonSharedInstance = [super allocWithZone:_zone];
	}
	return __kDFCSingletonSharedInstance;
}

- (id) copyWithZone:(NSZone*)zone {
    return self;
}


- (id) init {
    if( nil != (self = [super init]) ) {
        _content = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) dealloc {
}

+ (id<DFCTagged>) instanceWithTag: (id)tag {
    id<DFCTagged> result = nil;
    DFCSingleton* singleton = [DFCSingleton _sharedInstance];
    if( nil != singleton ) {
        NSMutableDictionary* cnt = [__kDFCSingletonSharedInstance _content];
        result = [cnt objectForKey:tag];
    }
    return result;    
}
+ (void) addInstance: (id<DFCTagged>)inst {
    DFCSingleton* singleton = [DFCSingleton _sharedInstance];
    id tag = [inst tag];
    if( (nil != singleton) && (nil != tag) ) {
        NSMutableDictionary *cnt    =   [__kDFCSingletonSharedInstance _content];
        if( nil == [cnt objectForKey:inst] ) {
            [cnt setObject: inst forKey: tag];
        }
    }
}
+ (void) removeInstance: (id<DFCTagged>)inst {
    DFCSingleton* singleton = [DFCSingleton _sharedInstance];
    id tag = [inst tag];
    if( (nil != singleton) && (nil != tag) ) {
        NSMutableDictionary *cnt = [__kDFCSingletonSharedInstance _content];
        [cnt removeObjectForKey     :   tag];
    }    
}
- (NSMutableDictionary*) _content {
    return _content;
}
@end

