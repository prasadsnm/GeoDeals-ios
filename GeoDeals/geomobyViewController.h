//
//  geomobyViewController.h
//  GeoDeals
//
//  Created by Zachary Durber on 27/11/2013.
//  Copyright (c) 2013 GeoMoby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "geomobyAppDelegate.h"

@interface geomobyViewController : UIViewController {
    geomobyAppDelegate *appDelegate;
}
@property bool keepMonitoringForAlerts;
@property (weak, nonatomic) IBOutlet UIButton *btnServiceStart;
- (IBAction)dealClick:(id)sender;
-(void) checkForAlerts;

@end
