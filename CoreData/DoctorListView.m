//
//  DoctorListView.m
//  IOS Project Try 2
//
//  Created by Sebastian, Justin on 4/15/14.
//  Copyright (c) 2014 Avnet. All rights reserved.
//

#import "DoctorListView.h"
#import "DoctorTableViewCell.h"
#import "Doctor.h"
#import "FileParser.h"
#import "BySpecialtyViewController.h"
#import "DetailViewController.h"

@interface DoctorListView ()
@property CLLocation *userLocation;
@end

@implementation DoctorListView
@synthesize doctorsList,search, userLocation;

static NSString* DoctortableIdentifier=@"DoctorListTableIdentifier";
UITableView *tableView;
NSMutableArray *sortedKeys;


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
    tableView=(id) [self.view viewWithTag:1];
    tableView.rowHeight=110;
    UINib *nib=[UINib nibWithNibName:@"DoctorTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:DoctortableIdentifier];
    
    NSManagedObjectContext *managedObject= [self managedObjectContext];
    NSFetchRequest *fetchRequest= [[NSFetchRequest alloc]initWithEntityName:@"Doctor"];
    doctorsList=[[managedObject executeFetchRequest:fetchRequest error:nil]mutableCopy];
    
    if([doctorsList count]==0){
        [self setupCoreData];
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(navigate)];
    
    userLocation=[[CLLocation alloc] initWithLatitude:30.2669544 longitude:-97.7423234];


}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSManagedObjectContext *managedObject= [self managedObjectContext];
    NSFetchRequest *fetchRequest= [[NSFetchRequest alloc]initWithEntityName:@"Doctor"];
    NSString *searchQuery;
    if ([search.speciality length]!=0 || [search.idPrefix length]!=0) {
        if([search.speciality length]!=0  && [search.idPrefix length]==0){
            searchQuery = [NSString stringWithFormat:@"speciality CONTAINS[cd] '%@'", search.speciality];
        }
        
        else if([search.speciality length]==0  && [search.idPrefix length]!=0){
            searchQuery = [NSString stringWithFormat:@"ANY idPrefix CONTAINS[cd] '%@'", search.idPrefix];
        }
        
        else if([search.speciality length]!=0  && [search.idPrefix length]!=0){
            searchQuery = [NSString stringWithFormat:@"(ANY speciality CONTAINS[cd] '%@') AND (ANY idPrefix CONTAINS[cd] '%@') ", search.speciality,search.idPrefix];
        }
    }
    
    else{
        
        
        if([search.firstName length]==0 && [search.providerType length]!=0){
                searchQuery =[NSString stringWithFormat:@"providerType CONTAINS[c] '%@'", search.providerType];
        }
        
        else if([search.firstName length]!=0 && [search.providerType length]==0){
            if([search.firstName isEqualToString:search.lastName]){
                searchQuery =[NSString stringWithFormat:@"(ANY firstName CONTAINS[c] '%@' OR ANY lastName CONTAINS[c] '%@')", search.firstName, search.lastName];
            }
            else{
                searchQuery =[NSString stringWithFormat:@"(ANY firstName CONTAINS[c]'%@' AND lastName CONTAINS[c] '%@')", search.firstName, search.lastName];
            }
        }
        
        else if([search.firstName length]!=0 && [search.providerType length]!=0)
        {
            if([search.firstName isEqualToString:search.lastName]){
                searchQuery =[NSString stringWithFormat:@"(ANY firstName CONTAINS[c] '%@' OR lastName CONTAINS[c] '%@') AND providerType CONTAINS[c] '%@'", search.firstName, search.lastName, search.providerType];
            }
            else{
                searchQuery =[NSString stringWithFormat:@"(ANY firstName CONTAINS[c] '%@' AND lastName CONTAINS[c] '%@') AND providerType CONTAINS[c] '%@'", search.firstName, search.lastName, search.providerType];
            }
        }
    }
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:searchQuery]];

    doctorsList=[[managedObject executeFetchRequest:fetchRequest error:nil]mutableCopy];
   
    
    [self findNearestLocAndDistance];
    [tableView reloadData];
    
    
}

-(void)findNearestLocAndDistance {
    NSMutableDictionary *docDistanceDictionary= [[NSMutableDictionary alloc]init];
    
    for(NSManagedObject *tempDoc in doctorsList){
        float latitude= [[tempDoc valueForKey:@"latitude"]floatValue];
        float longitude= [[tempDoc valueForKey:@"longitude"]floatValue];
        CLLocation *docLocation=[[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        
        CLLocationDistance distance = [userLocation distanceFromLocation:docLocation];
        [docDistanceDictionary setObject:tempDoc forKey:[NSNumber numberWithFloat:distance]];
    }
    
    //Remove items with distance grater than requested scope
    NSArray *keyArray =  [docDistanceDictionary allKeys];
    int count = [keyArray count];
    for (int i=0; i < count; i++) {
        if([[keyArray objectAtIndex:i] floatValue]> ([search.withIn floatValue]*1609.34)){
            [docDistanceDictionary removeObjectForKey:[keyArray objectAtIndex:i]];
        }
    }
    
    
    sortedKeys =(NSMutableArray *)[[docDistanceDictionary allKeys] sortedArrayUsingSelector: @selector(compare:)];
    NSMutableArray *sortedValues = [NSMutableArray array];
    for (NSString *key in sortedKeys){
        [sortedValues addObject: [docDistanceDictionary objectForKey: key]];
    }
    
  
    doctorsList=sortedValues;
}

-(void)setupCoreData
{
    FileParser* parser = [[FileParser alloc] init];
    NSString* csvString = [parser readInFile];
    NSArray* fileString = [parser parseCSVStringIntoArray:csvString];
    NSMutableArray *doctorsListFromFile = [parser createDoctorsFromArray:fileString];
    
    for (Doctor *doc in doctorsListFromFile) {
        NSManagedObjectContext *context = [self managedObjectContext];
        NSManagedObject *newDoctor = [NSEntityDescription insertNewObjectForEntityForName:@"Doctor" inManagedObjectContext:context];
        
        [newDoctor setValue:doc.firstName forKey:@"firstName"];
        [newDoctor setValue:doc.lastName forKey:@"lastName"];
        [newDoctor setValue:doc.address forKey:@"address"];
        [newDoctor setValue:doc.network forKey:@"network"];
        [newDoctor setValue:doc.idPrefix forKey:@"idPrefix"];
        [newDoctor setValue:doc.providerType forKey:@"providerType"];
        [newDoctor setValue:doc.speciality forKey:@"speciality"];
        [newDoctor setValue:doc.businessHours forKey:@"businessHours"];
        [newDoctor setValue:doc.phoneNumber forKey:@"phoneNumber"];
        [newDoctor setValue:doc.latitude forKey:@"latitude"];
        [newDoctor setValue:doc.longitude forKey:@"longitude"];
            
        NSError *error=nil;
        if(! [context save:&error]){
            NSLog(@"Can't save, error: %@", [error description]);
        }
        
    }
    NSLog(@"Number of Doctors: %lu", (unsigned long)[doctorsListFromFile count]);
    
}

-(void) setSearchObject:(id)newSearch
{
    if (search != newSearch) {
        search = newSearch;
    }
}

-(NSManagedObjectContext*) managedObjectContext{
    NSManagedObjectContext *context=nil;
    id theAppDelegate =[[UIApplication sharedApplication]delegate];
    if([theAppDelegate performSelector:@selector(managedObjectContext)]){
        context= [theAppDelegate managedObjectContext];
        
    }
    return context;
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

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [doctorsList count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DoctorTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:DoctortableIdentifier forIndexPath:indexPath];
    NSManagedObject *tempDevice= [doctorsList objectAtIndex:indexPath.row];
    
    // doctor full name and title
    NSString *doctorFullName = [NSString stringWithFormat:@"Dr. %@ %@, MD", [tempDevice valueForKey:@"firstName"],
                                [tempDevice valueForKey:@"lastName"]];
    cell.doctorFullName.text = doctorFullName;
    cell.doctorFullName.textColor = [UIColor colorWithRed:0/255.0f green:115/255.0f blue:186/255.0f alpha:1.0f];
    cell.doctorFullName.font = [UIFont boldSystemFontOfSize:18];
    
    // distance
    NSString *distance= [NSString stringWithFormat:@"(%.2f Miles)",[sortedKeys[indexPath.row]floatValue]*0.000621371];
    cell.distanceLabel.text=distance;
    cell.distanceLabel.textColor = [UIColor grayColor];
    
    // speciality
    cell.specialtyLabel.text=[tempDevice valueForKey:@"speciality" ];
    cell.specialtyLabel.textColor = [UIColor darkGrayColor];
    
    // address
    cell.addressLabel.text = [tempDevice valueForKey:@"address"];
    cell.addressLabel.textColor = [UIColor grayColor];
    cell.addressLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    return cell;

}



// Method that will redirect back to the find doc by specialty screen.
- (void) navigate
{    
    NSArray *viewControllers = [[self navigationController] viewControllers];
    for( int i = 0; i < [viewControllers count]; i++) {
        id obj=[viewControllers objectAtIndex:i];
        if([obj isKindOfClass:[BySpecialtyViewController class]]) {
            [[self navigationController] popToViewController:obj animated:YES];
            return;
        }
    }
    
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"showMapView"]) {
        [[segue destinationViewController]  setDoctorsList:doctorsList];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *viewController = (DetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DetailViewControllerSBID"];
    
    
    NSManagedObject *tempDoc= [doctorsList objectAtIndex:indexPath.row];
    float latitude= [[tempDoc valueForKey:@"latitude"]floatValue];
    float longitude= [[tempDoc valueForKey:@"longitude"]floatValue];
    CLLocation *docLocation=[[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    CLLocationCoordinate2D tempCoord = CLLocationCoordinate2DMake(docLocation.coordinate.latitude, docLocation.coordinate.longitude);
    
    MyAnnotation *atn = [[MyAnnotation alloc]initWithCoordinate:tempCoord title:[tempDoc valueForKey:@"firstName"] lastName:[tempDoc valueForKey:@"lastName"] subtitle:[tempDoc valueForKey:@"speciality"] address:[tempDoc valueForKey:@"address"] businessHours:[tempDoc valueForKey:@"businessHours"] network:[tempDoc valueForKey:@"network"] phoneNumber:[tempDoc valueForKey:@"phoneNumber"]];
    viewController.annotation=atn;
    
    [self.navigationController pushViewController:viewController animated:YES];

}

@end
