//
//  MyAnnotation.h
//  CustomAnnotations
//
//  Created by Andrew Bell on 4/15/14.
//  Copyright (c) 2014 Andrew Bell. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MyAnnotation : MKPointAnnotation

@property (nonatomic, strong) NSString *contactInformation;

-(id)initWithCoordinate:(CLLocationCoordinate2D)coord title:(NSString *)title subtitle:(NSString *)subtitle contactInformation:(NSString *)contactInfo;


@end
