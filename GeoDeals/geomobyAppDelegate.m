//
//  geomobyAppDelegate.m
//  GeoDeals
//
//  Created by Zachary Durber on 27/11/2013.
//  Copyright (c) 2013 GeoMoby. All rights reserved.
//

#import "geomobyAppDelegate.h"
#import "geomobyViewController.h"

@implementation geomobyAppDelegate

@synthesize client;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //[application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    [self loadClient];
    // Override point for customization after application launch.
    return YES;
}

-(void) loadClient {
    NSString *udid;
    NSString *device_type = [UIDevice currentDevice].model;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if([userDefaults stringForKey:@"udid"]) {
        udid = [userDefaults stringForKey:@"udid"];
    } else {
        udid = [UIDevice currentDevice].identifierForVendor.UUIDString;
        [userDefaults setValue:udid forKey:@"udid"];
    }
    //test0303 63fb41b334a8e68522fde8bf59823f077284d5c7
    if(client == nil) {
        //another way to construct the object
        //client = [[GM_SDK alloc] initWithBusinessKey:@"18d70812f6515543f1bfc00eff27c550590a1bc8" andUDID:udid andDeviceType:device_type];
        
        [client setDebugMode:true];
        client = [[GM_SDK alloc] init];
        
        //demo account
        client.business_key = @"18d70812f6515543f1bfc00eff27c550590a1bc8";
        
        //demo_ios account
        //client.business_key = @"39c4a5a4e40c7525190db2c95a74651f6f3199f8";
        
        client.udid = udid;
        client.device_type = device_type;
        
        [client setDebugMode:true];
        
        //good settings for testing and development
        client.ignoreCharging = true;
        
        //for testing tags
        [client addTag:@"male"];
        
        [client checkIfDeviceIsRegistered];
        
        //useful to cache the geofences and reduce battery consumption in the long run
        [client updateGeoFences];

    }
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
