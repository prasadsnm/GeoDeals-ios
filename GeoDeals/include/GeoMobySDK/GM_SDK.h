//
//  GeoMobySDK.h
//  GeoMobySDK
//
//  Created by Zachary Durber on 13/09/13.
//  Copyright (c) 2013 GeoMoby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GM_SDK : NSObject

@property  NSString *business_key;
@property  NSString *udid;
@property  NSString *device_type;
@property bool debug;
@property bool ignoreCharging;

-(void) setDebugMode: (bool) enableDebug;

-(id) init;

//initialise client with all required fields.
-(id) initWithBusinessKey:(NSString *)business_key andUDID:(NSString *)udid andDeviceType:(NSString *)device_type;

//Thread created to validate the given udid against the server
-(void) checkIfDeviceIsRegistered;

//How to check if you device was successfully validated
-(BOOL) isDeviceRegistered;

//Start the GeoMoby service
-(void) startLocationServices;

//Stops the GeoMoby Service
-(void) stopLocationServices;

//Update a received notification to indicate it was clicked
-(void) setNotificationAsClicked: (NSString *)notification_id;

//Display alert notification (app in foreground)
-(void) displayAlert;

//Returns current notification, deletes the pending notification from the queue
-(NSDictionary *) getCurrentAlert;

//Thread created to check the server for current GeoFences for the given business_key
-(void) updateGeoFences;

//set new tags to to send with each MotionUpdate check. (separate with commas)
-(void)setTag: (NSString *)new_tag;

//returns the currently stored tags
-(NSString *)getTags;

//add a single tag onto the tag store. (or more, just include a comma AFTER each new item)
-(void)addTag:(NSString *)new_tag;

@end
