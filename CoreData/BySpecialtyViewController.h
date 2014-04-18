//
//  BySpecialtyViewController.h
//  IOS Project Try 2
//
//  Created by Dubicki, Jeremy on 4/15/14.
//  Copyright (c) 2014 Avnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchObject.h"

@interface BySpecialtyViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *specialityArray;
@property (nonatomic, strong) UIPickerView *doctorSpecialityPicker;


@property (nonatomic, strong) SearchObject *search;

@property (weak, nonatomic) IBOutlet UITextField *specialtyTF;
@property (weak, nonatomic) IBOutlet UITextField *withinTF;
@property (weak, nonatomic) IBOutlet UITextField *locationTF;
@property (weak, nonatomic) IBOutlet UITextField *IdPrefixTF;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *pickerScrollView;
@property (weak, nonatomic) IBOutlet UITextField *topTF;

-(NSMutableArray *) getDoctorSpecialities;

@end
