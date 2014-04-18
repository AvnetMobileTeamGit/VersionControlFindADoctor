//
//  MyAnnotation.h
//  CustomAnnotations
//
//  Created by Andrew Bell on 4/15/14.
//  Copyright (c) 2014 Andrew Bell. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MyAnnotation : MKPointAnnotation

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *businessHours;
@property (nonatomic, strong) NSString *network;
@property (nonatomic, strong) NSString *phoneNumber;

-(id)initWithCoordinate:(CLLocationCoordinate2D)coord title:(NSString *)firstName lastName:(NSString *)lastName subtitle:(NSString *)speciality address:(NSString *)address businessHours:(NSString *)businessHours network:(NSString *)network phoneNumber:(NSString *)phoneNumber;

@end
