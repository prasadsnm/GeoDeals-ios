//
//  geomobyViewController.m
//  GeoDeals
//
//  Created by Zachary Durber on 27/11/2013.
//  Copyright (c) 2013 GeoMoby. All rights reserved.
//

#import "geomobyViewController.h"
#import "GM_SDK.h"
#import "SVProgressHUD.h"
#import "CustomIOS7AlertView.h"
#import "geomobyNotificationViewController.h"

@interface geomobyViewController ()

@property (nonatomic, strong) GM_SDK *client;
@property (nonatomic, strong) NSDictionary *pending_alert;

@end

@implementation geomobyViewController {
    bool isDailyNotifEnabled;
    bool useCustomAlert;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    NSString *udid;
    NSString *device_type = [UIDevice currentDevice].model;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if([userDefaults stringForKey:@"udid"]) {
        udid = [userDefaults stringForKey:@"udid"];
    } else {
        udid = [UIDevice currentDevice].identifierForVendor.UUIDString;
        [userDefaults setValue:udid forKey:@"udid"];
    }
    
    if(_keepMonitoringForAlerts == true) {
        [_btnServiceStart setTitle:@"Disable Service" forState:UIControlStateNormal];
        [self keepMonitoringForAlerts];
    }
    
    if(_client == nil) {
        _client = [[GM_SDK alloc] initWithBusinessKey:@"63fb41b334a8e68522fde8bf59823f077284d5c7" andUDID:udid andDeviceType:device_type];
        
        //good settings for testing and development
        _client.walkingOnly = false;
        _client.ignoreCharging = true;
        
        [_client checkIfDeviceIsRegistered];
        //useful to cache the geofences and reduce battery consumption in the long run
        [_client updateGeoFences];
        
        isDailyNotifEnabled = false;
    }
    
    _pending_alert = [[NSDictionary alloc] init];
    
    useCustomAlert = false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) alertUser {
    
    //optional snooze timer, stops the perodic checking for geofences and location. Helps preserve the battery
    //[_client setSnoozeTimer:18];
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    
    if (localNotif == nil)
        return;
    if(_pending_alert == nil)
        return;
    
	// Notification details
    localNotif.alertBody = [_pending_alert valueForKey:@"title"];
    localNotif.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
	// Set the action button
    localNotif.alertAction = @"View";
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;

    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];
    
    if(useCustomAlert) {
        [self showCustomUIAlert ];
    }
    else {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification Received" message:[_pending_alert valueForKey:@"title"] delegate:self cancelButtonTitle:@"No Thanks" otherButtonTitles:@"Show Me", nil];
        [alert show];
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        _keepMonitoringForAlerts = false;
        [self performSegueWithIdentifier: @"segueToNotification" sender: self];
    } else {
        //do something with Close button
    }
    
    //start monitoring again
    [self startMonitoringForAlerts];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segueToNotification"]) {
        geomobyNotificationViewController *notifView = segue.destinationViewController;
        notifView.pending_alert = _pending_alert;
    }
}

//Not recommended, there are significant lag issues upon loading an image into the custom UIAlertView
//and Apple has removed support for loading images into normal UIAlertViews in iOS7
//Here as an example only
- (void) showCustomUIAlert {
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    __block UIImage *myimage;
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 270, 180)];
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 190)];
    
    [alertView setDelegate:self];
    
    [SVProgressHUD showWithStatus:@"Loading ..."];
    NSLog(@"Image: %@", [_pending_alert valueForKey:@"image_url"]);
    
    dispatch_queue_t concurrentQueue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(concurrentQueue, ^{
        NSData *mydata = [[NSData alloc] initWithContentsOfURL:[_pending_alert valueForKey:@"image_url"]];
        myimage = [[UIImage alloc] initWithData:mydata];
        
        [image setImage:myimage];
        [customView addSubview:image];
        
        [alertView setContainerView:customView];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [alertView show];
            [SVProgressHUD dismiss];
        });
    });

}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    [self startMonitoringForAlerts];
    [alertView close];
    
}

-(void) startMonitoringForAlerts {
    if(_keepMonitoringForAlerts == true){
        return;
    } else {
        NSLog(@"Monitoring for alerts");
        _keepMonitoringForAlerts = true;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            do {
                _pending_alert = [_client getCurrentAlert];
                if([_pending_alert valueForKey:@"title"]) {
                    _keepMonitoringForAlerts = false;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self alertUser];
                    });
                }
                else {
                    sleep(8);
                }
            } while(_keepMonitoringForAlerts);
        });
    }
}

- (IBAction)dealClick:(id)sender {
    NSString *dealBtnText = @"";
    
    //stop the service
    if(isDailyNotifEnabled) {
        dealBtnText = @"Enable Service";
        [_client stopBackgroundMonitoringOfGeoFences];
        _keepMonitoringForAlerts = false;
        isDailyNotifEnabled = false;
    } else {
        //start the service
        dealBtnText = @"Disable Service";
        [_client startBackgroundMonitoringOfGeoFences];
        [self startMonitoringForAlerts];
        isDailyNotifEnabled = true;
        
    }
    [_btnServiceStart setTitle:dealBtnText forState:UIControlStateNormal];
}

@end
