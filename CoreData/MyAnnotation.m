//
//  MyAnnotation.m
//  CustomAnnotations
//
//  Created by Andrew Bell on 4/15/14.
//  Copyright (c) 2014 Andrew Bell. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation


@synthesize coordinate, title, lastName, subtitle, address, businessHours, network, phoneNumber;

-(id)initWithCoordinate:(CLLocationCoordinate2D)coord title:(NSString *)firstN lastName:(NSString *)lastN subtitle:(NSString *)special address:(NSString *)add businessHours:(NSString *)businessH network:(NSString *)netw phoneNumber:(NSString *)phoneN   {
    self = [super init];
    if (self) {
        coordinate = coord;
        title = firstN;
        lastName = lastN;
        subtitle = special;
        address = add;
        businessHours = businessH;
        network = netw;
        phoneNumber = phoneN;
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
