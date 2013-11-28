//
//  geomobyViewController.h
//  GeoDeals
//
//  Created by Zachary Durber on 27/11/2013.
//  Copyright (c) 2013 GeoMoby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface geomobyViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnServiceStart;
- (IBAction)dealClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *testBox;

@end
