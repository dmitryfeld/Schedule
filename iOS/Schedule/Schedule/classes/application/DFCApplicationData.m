//
//  DFCApplicationData.m
//  Schedule
//
//  Created by Dmitry Feld on 4/9/16.
//  Copyright © 2016 Dmiry Feld. All rights reserved.
//

#import <WatchConnectivity/WatchConnectivity.h>
#import "DFCApplicationData.h"
#import "DFCSingleton.h"
#import "DFCLogger.h"

const NSString* kDFCApplicationDataScheduleUpdated = @"kDFCApplicationDataScheduleUpdated";
const NSString* __DFCApplicationDataTag = @"__DFCApplicationDataTag";

@interface DFCApplicationData()<WCSessionDelegate,DFCTagged> {
@private
    DFCSchedule* _schedule;
    NSTimer* _timer;
    DFCScheduleSYMTypes _scheduleType;
    WCSession* _watchSession;
}
@property (readonly,nonatomic) WCSession* watchSession;
@end

@implementation DFCApplicationData
@synthesize watchSession = _watchSession;
- (id) init {
    if (self = [super init]) {
        _scheduleType = kDFCScheduleSYMType1Hour;
        _schedule = [DFCScheduleSYM simulatedScheduleWithType:_scheduleType];
        [self sendDataToComplication];
        _timer = [NSTimer scheduledTimerWithTimeInterval:60. * 10. target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
        //_timer = [NSTimer scheduledTimerWithTimeInterval:3. target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    }
    return self;
}
- (void) refresh {
    if (_scheduleType < 2) {
        _scheduleType ++;
    } else {
        _scheduleType = 0;
    }
    _schedule = [DFCScheduleSYM simulatedScheduleWithType:_scheduleType];
    [[NSNotificationCenter defaultCenter] postNotificationName:(NSString*)kDFCApplicationDataScheduleUpdated object:nil];
    [self sendDataToComplication];
}
- (void) onTimer:(id)timer {
    [self refresh];
}
- (void) sendDataToComplication {
    NSDictionary* content = [_schedule dictionary];
    
    if (self.watchSession.isPaired) {
        
        WCSessionUserInfoTransfer* transfer = [self.watchSession transferUserInfo:content];
        __WARNING__(@"Transferring: %@",transfer.transferring?@"YES":@"NO");
        //[self.watchSession updateApplicationContext:content error:nil];
        
        /*
        if (self.watchSession.isReachable) {
            [self.watchSession sendMessage:content replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
                
            } errorHandler:^(NSError * _Nonnull error) {
            
            }];
        } else {
            transfer = [self.watchSession transferCurrentComplicationUserInfo:content];
            __WARNING__(@"Transferring to complication: %@",transfer.transferring?@"YES":@"NO");
        }
        */
    }
    
}
- (void) updateWatchContext {
    NSError* error = nil;
    [self.watchSession updateApplicationContext:_schedule.dictionary error:&error];
    __ERROR__(@"Error: %@",error?@"YES":@"NO");
}
- (WCSession*) watchSession {
    if (!_watchSession) {
        if ([WCSession isSupported]) {
            _watchSession = [WCSession defaultSession];
            _watchSession.delegate = self;
            [_watchSession activateSession];
        }
    }
    return _watchSession;
}
- (id) tag {
    return __DFCApplicationDataTag;
}
+ (DFCApplicationData*) sharedApplicationData {
    DFCApplicationData* result = [DFCSingleton instanceWithTag:__DFCApplicationDataTag];
    if (!result) {
        result = [DFCApplicationData new];
        [DFCSingleton addInstance:result];
    }
    return result;
}
@end
