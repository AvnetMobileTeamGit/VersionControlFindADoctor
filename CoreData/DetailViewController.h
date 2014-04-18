//
//  DetailViewController.h
//  IOS Project Try 2
//
//  Created by Dubicki, Jeremy on 4/15/14.
//  Copyright (c) 2014 Avnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"

@interface DetailViewController : UIViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *networkLabel;
@property (weak, nonatomic) IBOutlet UITextView *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UITextView *businessHours;
@property (weak, nonatomic) IBOutlet UILabel *specialtyLabel;

@property (weak, nonatomic) IBOutlet MKMapView *detaiMapView;

@property (strong, nonatomic) MyAnnotation *annotation;


-(id)initWithAnnotation:(MyAnnotation *)annotation;
@end
