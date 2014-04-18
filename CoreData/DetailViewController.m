//
//  DetailViewController.m
//  IOS Project Try 2
//
//  Created by Dubicki, Jeremy on 4/15/14.
//  Copyright (c) 2014 Avnet. All rights reserved.
//

#import "DetailViewController.h"
#import "MyAnnotation.h"
#import "MyAnnotationView.h"

#define METERS_PER_MILE 1609.344

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize annotation, detaiMapView,nameLabel,networkLabel,addressLabel,businessHours,specialtyLabel,phoneNumberLabel;

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
    
    [detaiMapView addAnnotation:annotation];
    addressLabel.text = annotation.address;
    nameLabel.text = [annotation.title stringByAppendingString:annotation.lastName];
    phoneNumberLabel.text = annotation.phoneNumber;
    businessHours.text = annotation.businessHours;
    specialtyLabel.text = annotation.subtitle;
    
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    // Dont create annotation views for the user location annotation
    if ([annotation isKindOfClass:[MyAnnotation class]]) {
        static NSString *myAnnotationId = @"myAnnotation";
        
        // Create an annotation view, but reuse a cached one if available
        MyAnnotationView *annotationView = (MyAnnotationView *)[detaiMapView dequeueReusableAnnotationViewWithIdentifier:myAnnotationId];
        if (annotationView) {
            // Cached view found, associate it with the annotation
            annotationView.annotation = annotation;
        } else {
            // No cached views were available, create a new one
            annotationView = [[MyAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:myAnnotationId];
        }
        return annotationView;
    }
    // Use a default annotation view for the user location annotation
    return nil;
}

-(void)viewWillAppear:(BOOL)animated {
    // 1
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 30.2669444;
    zoomLocation.longitude = -97.7427778;
    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 25*METERS_PER_MILE, 15*METERS_PER_MILE);
    
    // 3
    [detaiMapView setRegion:viewRegion animated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end


