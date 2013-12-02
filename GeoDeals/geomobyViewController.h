//
//  geomobyViewController.h
//  GeoDeals
//
//  Created by Zachary Durber on 27/11/2013.
//  Copyright (c) 2013 GeoMoby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface geomobyViewController : UIViewController
@property bool keepMonitoringForAlerts;
@property (weak, nonatomic) IBOutlet UIButton *btnServiceStart;
- (IBAction)dealClick:(id)sender;

@end
