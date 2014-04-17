//
//  MyAnnotationView.m
//  CustomAnnotations
//
//  Created by Andrew Bell on 4/15/14.
//  Copyright (c) 2014 Andrew Bell. All rights reserved.
//

#import "MyAnnotationView.h"

@implementation MyAnnotationView

-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImage *myImage = [UIImage imageNamed:@"custompin.png"];
        self.image = myImage;
        self.frame = CGRectMake(0, 0, 40, 40);
        // Use contentMode to ensure best scaling of image
        self.contentMode = UIViewContentModeScaleAspectFill;
        // Use centerOffset to adjust the position of the image
        self.centerOffset = CGPointMake(0, -20);
        
        self.canShowCallout = YES;
        
        // Left callout accessory view
        UIImageView *leftAccessoryView = [[UIImageView alloc] initWithImage:myImage];
        leftAccessoryView.frame = CGRectMake(0, 0, 20, 20);
        leftAccessoryView.contentMode = UIViewContentModeScaleAspectFill;
        self.leftCalloutAccessoryView = leftAccessoryView;
        
        // Right callout accessory view
        self.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    return self;
}

@end
