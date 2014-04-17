//
//  MyAnnotation.m
//  CustomAnnotations
//
//  Created by Andrew Bell on 4/15/14.
//  Copyright (c) 2014 Andrew Bell. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation

-(id)initWithCoordinate:(CLLocationCoordinate2D)coord title:(NSString *)title subtitle:(NSString *)subtitle contactInformation:(NSString *)contactInfo {
    self = [super init];
    if (self) {
        self.coordinate = coord;
        self.title = title;
        self.subtitle = subtitle;
        self.contactInformation = contactInfo;
    }
    return self;
}

//-(float)getDistance:(CLLocationCoordinate2D)coord {
//   
//    CLLocation *myLoc = [[CLLocation alloc] initWithLatitude:30.2669544 longitude:-97.7423234];
//    CLLocation *destLoc = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
//    
//    CLLocationDistance distance = [myLoc distanceFromLocation:destLoc];
//    
//    return distance;
//}

@end
