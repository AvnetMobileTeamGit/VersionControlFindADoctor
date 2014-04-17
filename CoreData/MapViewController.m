//
//  MapViewController.m
//  IOS Project Try 2
//
//  Created by Dubicki, Jeremy on 4/15/14.
//  Copyright (c) 2014 Avnet. All rights reserved.
//

#import "MapViewController.h"
#import "MyAnnotation.h"
#import "MyAnnotationView.h"

#define METERS_PER_MILE 1609.344

@interface MapViewController ()

@property (strong, nonatomic) CLLocation *selectedLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation MapViewController
@synthesize doctorsList;
CLLocation *myLoc;
NSMutableArray *arr;

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
    
    myLoc = [[CLLocation alloc] initWithLatitude:30.2669544 longitude:-97.7423234];

    //    [self updateMaps];
    
    self.mapView.delegate = self;
    
    NSMutableArray *annotations= [[NSMutableArray alloc]init];
    for (int i = 0; i < [doctorsList count]; i++) {
        NSManagedObject *tempDoc= [doctorsList objectAtIndex:i];
        float latitude= [[tempDoc valueForKey:@"latitude"]floatValue];
        float longitude= [[tempDoc valueForKey:@"longitude"]floatValue];
        CLLocation *docLocation=[[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        CLLocationCoordinate2D tempCoord = CLLocationCoordinate2DMake(docLocation.coordinate.latitude, docLocation.coordinate.longitude);
        
        [annotations addObject: [[MyAnnotation alloc]initWithCoordinate:tempCoord title:[tempDoc valueForKey:@"firstName"] subtitle:[tempDoc valueForKey:@"speciality"] contactInformation:[tempDoc valueForKey:@"phoneNumber"]]];
        
        
        
    }
    
    [self.mapView addAnnotations:annotations];
    
    
    
    [self findNearestLocAndDistance];
    
    
    
}

#pragma mark - Custom methods

-(void)findNearestLocAndDistance {
    
    CLLocation *nearestLoc = nil;
    CLLocationDistance nearestDis = DBL_MAX;
    for (CLLocation *loc in arr) {
        CLLocationDistance distance = [myLoc distanceFromLocation:loc];
        if (nearestDis > distance) {
            nearestLoc = loc;
            nearestDis = distance;
        }
    }
}

#pragma mark - MapKit delegate methods



-(void)viewWillAppear:(BOOL)animated {
    // 1
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 30.2669444;
    zoomLocation.longitude = -97.7427778;
    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 15*METERS_PER_MILE, 15*METERS_PER_MILE);
    
    // 3
    [_mapView setRegion:viewRegion animated:YES];
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    // Dont create annotation views for the user location annotation
    if ([annotation isKindOfClass:[MyAnnotation class]]) {
        static NSString *myAnnotationId = @"myAnnotation";
        
        // Create an annotation view, but reuse a cached one if available
        MyAnnotationView *annotationView = (MyAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:myAnnotationId];
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