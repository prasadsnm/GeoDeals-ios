//
//  geomobyNotificationViewController.m
//  GeoDeals
//
//  Created by Zachary Durber on 29/11/2013.
//  Copyright (c) 2013 GeoMoby. All rights reserved.
//

#import "geomobyNotificationViewController.h"
#import "geomobyViewController.h"
#import "SVProgressHUD.h"

@interface geomobyNotificationViewController ()

@end

@implementation geomobyNotificationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _notifTitle.text = [_pending_alert valueForKey:@"title"];
    _notifDesc.text = [_pending_alert valueForKey:@"description"];
    _notifLink.text = [_pending_alert valueForKey:@"url"];
    /*if(_notifLink != nil) {
        _notifLink.userInteractionEnabled = true;
        UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myAction:)];
        [_notifLink addGestureRecognizer:gr];
        gr.numberOfTapsRequired = 1;
        gr.cancelsTouchesInView = NO;
        //[self.view addSubview:myLabel];
    }*/
    
    NSLog(@"Deal: %@", _pending_alert);
    
    [SVProgressHUD showWithStatus:@"Loading ..."];
    
    dispatch_queue_t concurrentQueue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(concurrentQueue, ^{
        NSData *mydata = [[NSData alloc] initWithContentsOfURL:[_pending_alert valueForKey:@"image_url"]];
        UIImage *myimage = [[UIImage alloc] initWithData:mydata];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _notifImage.image = myimage;
            [SVProgressHUD dismiss];
        });
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segueToMain"]) {
        geomobyViewController *mainView = segue.destinationViewController;
        mainView.keepMonitoringForAlerts = true;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
