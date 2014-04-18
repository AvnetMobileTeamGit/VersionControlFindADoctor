//
//  ByNameViewController.h
//  IOS Project Try 2
//
//  Created by Dubicki, Jeremy on 4/15/14.
//  Copyright (c) 2014 Avnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ByNameViewController : UIViewController <UIPickerViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *providerArray;
@property (nonatomic, strong) UIPickerView *providerPicker;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *providerTypeTF;
@property (weak, nonatomic) IBOutlet UITextField *withinTF;
@property (weak, nonatomic) IBOutlet UITextField *locationTF;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *topTF;

@end
