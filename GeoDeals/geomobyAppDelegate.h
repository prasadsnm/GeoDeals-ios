//
//  geomobyAppDelegate.h
//  GeoDeals
//
//  Created by Zachary Durber on 27/11/2013.
//  Copyright (c) 2013 GeoMoby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GM_SDK.h"

@interface geomobyAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) GM_SDK *client;

@end
