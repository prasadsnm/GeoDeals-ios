//
//  geomobyNotificationViewController.h
//  GeoDeals
//
//  Created by Zachary Durber on 29/11/2013.
//  Copyright (c) 2013 GeoMoby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface geomobyNotificationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *notifTitle;
@property (weak, nonatomic) IBOutlet UILabel *notifLink;
@property (weak, nonatomic) IBOutlet UIImageView *notifImage;
@property (weak, nonatomic) IBOutlet UILabel *notifDesc;
@property (nonatomic, retain) NSDictionary *pending_alert;
@end
