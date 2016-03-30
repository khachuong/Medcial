//
//  GLEListDiseasesViewController.m
//  Medcial
//
//  Created by Khachuong on 6/23/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

// Import the implementation classes
#import "GLEListDiseasesViewController.h" 
#import "GLEListQuestionsViewController.h"

// Import the Parse.com library
#import <Parse/Parse.h>


/* This View Controller allows us get all the diseases from server  and display them into the Table View
To use the Table View in Objective-C we must implement two protocols are: 
    + UITableViewDataSource: this protocol helps us connect our data with the Table View. To do that, we have to
    implement at least these two methods:
        - tableView:cellForRowAtIndexPath // customize a cell 
        - tableView:numberOfRowsInSection // let the table view know how many row in this table
    + UITableViewDelegate: this protocol allows us to manage selections, configure the table section 
    such as headings footers and so on
*/

@interface GLEListDiseasesViewController ()

@end

@implementation GLEListDiseasesViewController

// The viewDidLoad() method called after the controller's view is loaded

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Set the title of navigation bar
    self.navigationController.navigationBar.topItem.title = @"List of diseases";

    /* Before configure our Table View, we must have a list of objects. In this class,
    the list objects we want to get is Diseases. So, by using the Parse's API we can 
    easily get all the object from Diseases class and add it into our custom list called: lisDiseases
    
    The dispatch_async allows us to put the code inside a block on the queue and
    it will immediatly return.

    */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PFQuery *query = [PFQuery queryWithClassName:@"Diseases"];
        [query orderByAscending:@"diseaseName"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            // get all the disease object from Diseases and sorting be diseaseName
            self.listDiseases = objects; 
            // reload the table after get all the disease objects
            [self.tbListQuestions reloadData]; 
        }];
    });
}

#pragma mark - Table view data source

// Return the number of Section in the Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
// Return the number of rows in on section of the Table View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_listDiseases count];
}
// Return fixed value of height for each row in table 
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 77;
}

// the cellForRowAtIndexPath allows us to configure or customize our cell to display whatever information we want 
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // We use the cell identifier to identify a cell and for resue a cell
    static NSString *cellIdentifier = @"diseaseCell"; 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    // Get an object from the lisDiseases array by using objectAtIndex:indexPath.row]
    PFObject *anObject = [_listDiseases objectAtIndex:indexPath.row];
    /* We use viewWithTag as a quick way to connect the child views without set up IBOutlet 
    Every UI component has different and unique tag
    In this cell we have three UI components are UILabel and UIImageView for displaying the title of a disease, its photo
    and the number of questions related that diseases
    */
    UILabel *title = (UILabel *)[cell viewWithTag:101];
    // Set the title of disease into the UILabel 
    title.text = anObject[@"diseaseName"];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    //Get the photo from server that related to a disease and set it into imageView
    PFFile *userImageFile = anObject[@"diseaseImage"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            imageView.image = image;
        }
    }];

    // From line 103 to 109, we make some corner for our photo. It will display like a circle with the photo inside
    imageView.layer.borderWidth = 3.0f;
    
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    imageView.layer.cornerRadius = imageView.frame.size.height /2;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderWidth = 0;
    
    // Get the number of questions related a disease and set it with format as a number into the numQuestions label
    UILabel *numQuestions = (UILabel *)[cell viewWithTag:102];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PFQuery *questions = [PFQuery queryWithClassName:@"Question"];
        [questions whereKey:@"diseaseID" equalTo:obj.objectId];
        [questions findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            _numberOfQuestions = objects;
            numQuestions.text = [NSString stringWithFormat:@"%d", (int)[_numberOfQuestions count]];
        }];
        
    });

    // after finish binding the data into the UI components, we must return our cell
    return cell;
}
// The prepareForSegue allows us pass the value and data from one ViewController to other ViewController
// In this case, we will passing an PFObject to the GLEListQuestionsViewController.
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{ 
    // 
    if([segue.identifier isEqualToString:@"showDiseaseSegue"]){
        /*
            Explain for line 135 to 138:
            If the user select a cell, we will pass an PFObject to other ViewController called: GLEListQuestionsViewController
            The purpose of this method is we will no longer need to request again from server the information that we 
            already requested from viewDidLoad() method. So, it helps us save our time and network resources
        */
        NSIndexPath *indexPath = [_tbListQuestions indexPathForSelectedRow];
        PFObject *anObject = [_listDiseases objectAtIndex:indexPath.row];
        GLEListQuestionsViewController *viewController = (GLEListQuestionsViewController *)segue.destinationViewController;
        viewController.diseaseID = anObject.objectId;
    }
}

// The refreshWasPressed will call when the user tap on the refresh button on the top 
- (IBAction)refreshWasPressed:(id)sender {
    [self viewDidLoad];
}
@end
