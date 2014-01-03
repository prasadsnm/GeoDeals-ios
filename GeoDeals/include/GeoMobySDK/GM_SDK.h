//
//  GeoMobySDK.h
//  GeoMobySDK
//
//  Created by Zachary Durber on 13/09/13.
//  Copyright (c) 2013 GeoMoby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GM_SDK : NSObject

@property (assign)  NSString *business_key;
@property (assign)  NSString *udid;
@property (assign)  NSString *device_type;
@property bool debug;
@property bool walkingOnly;
@property bool ignoreCharging;

-(void) setDebugMode: (bool) enableDebug;

-(id) init;

//initialise client with all required fields.
-(id) initWithBusinessKey:(NSString *)business_key andUDID:(NSString *)udid andDeviceType:(NSString *)device_type;

//Thread created to validate the given udid against the server
-(void) checkIfDeviceIsRegistered;

//How to check if you device was successfully validated
-(BOOL) isDeviceRegistered;

//Checks if the user is moving over 10 seconds, if so, sends the lat/long against the server
-(void) checkForMotionAndUpdate;

//Puts checkForMotion onto a thread running in the background
-(void) startBackgroundMonitoringOfGeoFences;

//Request the background service to halt
-(void)stopBackgroundMonitoringOfGeoFences;

//Update a received notification to indicate it was clicked
-(void) setNotificationAsClicked: (NSString *)notification_id;

//Returns current notification, deletes the pending notification from the queue
-(NSDictionary *) getCurrentAlert;

//Thread created to check the server for current GeoFences for the given business_key
-(void) updateGeoFences;

//Snooze the service, will only wake up for the keep alive every 9minutes
-(void) setSnoozeTimer:(int) minutes;

@end
