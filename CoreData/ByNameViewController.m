//
//  ByNameViewController.m
//  IOS Project Try 2
//
//  Created by Dubicki, Jeremy on 4/15/14.
//  Copyright (c) 2014 Avnet. All rights reserved.
//

#import "ByNameViewController.h"
#import "DoctorListView.h"

@interface ByNameViewController ()

@end

@implementation ByNameViewController

@synthesize nameTF, providerTypeTF, withinTF, locationTF,topTF;
@synthesize scrollView, providerArray, providerPicker;

BOOL keyboardIsShown;
UITextField *currentTextField;

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
    scrollView.frame = CGRectMake(0, 0, 320, 568);
    scrollView.contentSize = CGSizeMake(320, 700);
    [self.navigationItem setHidesBackButton:YES];
    
    providerArray   = [self getProviderTypes];
    
    
    providerPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 380, 320, 200)];
    providerPicker.delegate = self;
    providerPicker.showsSelectionIndicator = YES;

}

-(NSMutableArray *) getProviderTypes
{
    NSMutableArray *providerTypesArray = [[NSMutableArray alloc] init];
   
    [providerTypesArray addObject:@"Ancillaries"];
    [providerTypesArray addObject:@"Behavioral Health Facilities"];
    [providerTypesArray addObject:@"Behavioral Health Practitioners"];
    [providerTypesArray addObject:@"Blue Distinction Bariatric Centers"];
    [providerTypesArray addObject:@"Blue Distinction Cardiac Centers"];
    [providerTypesArray addObject:@"Blue Distinction Knee/Hip Centers"];
    [providerTypesArray addObject:@"Blue Distinction Rare and Complex Cancer Centers"];
    [providerTypesArray addObject:@"Blue Distinction Spine Centers"];
    [providerTypesArray addObject:@"Blue Distinction Transplant Centers"];
    [providerTypesArray addObject:@"Medical/Surgical Hospitals"];
    [providerTypesArray addObject:@"Pharmacies"];
    [providerTypesArray addObject:@"Primary Care Physicians"];
    [providerTypesArray addObject:@"Retail Health Clinics"];
    [providerTypesArray addObject:@"Specialists"];
    [providerTypesArray addObject:@"Supervised And Sponsored Providers"];
    [providerTypesArray addObject:@"Urgent Care Centers"];
    return providerTypesArray;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection
    [providerTypeTF setText:providerArray[row]];
    [providerPicker  removeFromSuperview];
    
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    
    return [providerArray count];
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    
    return providerArray[row];
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if(textField == providerTypeTF) {
        [self.view addSubview:providerPicker];
        
        return NO;
    }
    else{
        return YES;
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)dismissTheKeyboard:(id)sender
{
    [self.view endEditing:YES];
}
/**
 When keyboard appears
 */
- (void)keyboardDidShow: (NSNotification *)notification
{
    if (keyboardIsShown) return;
    
    NSDictionary *info = [notification userInfo];
    
    // -- obtain the size of the keyboard --
    NSValue *aValue = [info objectForKey: UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [self.view convertRect:[aValue CGRectValue] fromView:nil];
    
    // -- resize the scroll view (with keyboard) --
    CGRect viewFrame = [scrollView frame];
    viewFrame.size.height -= keyboardRect.size.height;
    scrollView.frame = viewFrame;
    
    // -- scroll to the current textField --
    CGRect textFieldRect = [currentTextField frame];
    [scrollView scrollRectToVisible:textFieldRect animated:YES];
    
    keyboardIsShown = YES;
}

/**
 When keyboard disappears
 */
- (void)keyboardDidHide: (NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    
    // -- obtain the size of the keyboard --
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [self.view convertRect:[aValue CGRectValue] fromView:nil];
    
    // -- resize the scroll view back to its original size (without keyboard) --
    CGRect viewFrame = [scrollView frame];
    viewFrame.size.height += keyboardRect.size.height;
    scrollView.frame = viewFrame;
    
    // -- scroll to the current textField --
    currentTextField = topTF;
    CGRect textFieldRect = [currentTextField frame];
    [scrollView scrollRectToVisible:textFieldRect animated:YES];
    
    keyboardIsShown = NO;
}

/**
 Before the view appears
 */
- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:self.view.window];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:self.view.window];
}

/**
 When a textField begins editing
 */
- (void)texFieldDidBeginEditing: (UITextField *)texfieldView
{
    currentTextField = texfieldView;
}

/**
 When the user taps on the return key on the keyboard
 */
- (BOOL)textFieldShouldReturn: (UITextField *)texfieldView
{
    [self.view endEditing:YES];
    return NO;
}

/**
 When a textField is done editing
 */
- (void)textFieldDidEndEditing: (UITextField *)textFieldView
{
    currentTextField = nil;
}

/**
 Peform the view window disappears
 */
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [super viewWillDisappear:animated];
}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    BOOL toBeReturned;
    if ([identifier isEqualToString:@"findDoctorByName"]) {
        
        
        if ([nameTF.text isEqual:@""] &&
            [providerTypeTF.text isEqual:@""] &&
            [withinTF.text isEqual:@""] &&
            [locationTF.text isEqual:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please Fill At Least One Fields"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            toBeReturned = NO;
            
            
        } else {
            // Method to query database
            toBeReturned =  YES;
        }
    }
    return toBeReturned;
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"findDoctorByName"]) {
        SearchObject *search= [[SearchObject alloc]init];
        NSArray *array=[nameTF.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if([array count]==1){
            search.firstName=nameTF.text;
            search.lastName= nameTF.text;
        }
        else if ([array count]==2){
            search.firstName=array[0];
            search.lastName=array[1];
        }
        else{
            // TODO: Alert message
        }
        search.providerType=providerTypeTF.text;
        search.withIn=withinTF.text;
        search.location=locationTF.text;
        [[segue destinationViewController] setSearch:search];
    }

}


@end
