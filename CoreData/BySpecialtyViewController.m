//
//  BySpecialtyViewController.m
//  IOS Project Try 2
//
//  Created by Dubicki, Jeremy on 4/15/14.
//  Copyright (c) 2014 Avnet. All rights reserved.
//

#import "BySpecialtyViewController.h"
#import "DoctorListView.h"
@interface BySpecialtyViewController ()

@end

@implementation BySpecialtyViewController

@synthesize specialtyTF, withinTF, locationTF, IdPrefixTF, topTF;
@synthesize scrollView;

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
    [self.navigationItem setHidesBackButton:YES];
    
    scrollView.frame = CGRectMake(0, 0, 320, 568);
    scrollView.contentSize = CGSizeMake(320, 700);


}

/**
 Before the view appears
 */
- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:self.view.window];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:self.view.window];
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

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    BOOL toBeReturned;
    if ([identifier isEqualToString:@"findDoctorBySpecialty"]) {
        
        
        if ([specialtyTF.text isEqual:@""] &&
            [IdPrefixTF.text isEqual:@""] &&
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
    
    if ([[segue identifier] isEqualToString:@"findDoctorBySpecialty"]) {
        SearchObject *search= [[SearchObject alloc]init];
        search.speciality=specialtyTF.text;
        search.idPrefix=IdPrefixTF.text;
        search.withIn=withinTF.text;
        search.location=locationTF.text;
        [[segue destinationViewController] setSearch:search];
    }
}


@end
