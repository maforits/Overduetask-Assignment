//
//  MVTaskDetailViewController.m
//  OverdueTask
//
//  Created by Mauro on 9/25/14.
//
//

#import "MVTaskDetailViewController.h"
#import "MVEditTaskViewController.h"
@interface MVTaskDetailViewController ()

@end

@implementation MVTaskDetailViewController

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
    // Do any additional setup after loading the view.
    
    //Set the task items
    self.taskTitleLabel.text = self.taskObject.title;
    self.taskDescriptionLabel.text = self.taskObject.description;
    
    //Define the dateformatter for the overduedate
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm"];
    
    self.taskOverdueDateLabel.text = [dateFormat stringFromDate:self.taskObject.date];
    
    //Show or hide complete button according to completion status
    if (self.taskObject.completion == YES)
        self.completeTaskButton.hidden = YES;
    else
        self.completeTaskButton.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.destinationViewController isKindOfClass:[MVEditTaskViewController class]])
    {
        MVEditTaskViewController *nextViewController = segue.destinationViewController;
        nextViewController.taskObject = self.taskObject;
        nextViewController.editTaskDelegate = self;
    }
}


- (IBAction)editTaskButtonPressed:(UIBarButtonItem *)sender {
    //Call the segue
    [self  performSegueWithIdentifier:@"toEditTaskViewController" sender:sender];
}

- (IBAction)completeTaskButtonPressed:(UIButton *)sender {
    [self.taskDetailDelegate didCompleteTask:self.taskObject and:self.row];
    
    self.taskObject.completion = YES;
    self.completeTaskButton.hidden = YES;
}

#pragma mark - MVEditTaskViewController Delegate

-(void)didUpdateTask:(MVTaskObject *)taskObject
{
    //Update the task detail view
    self.taskObject = taskObject;
    //Set the task items
    self.taskTitleLabel.text = self.taskObject.title;
    self.taskDescriptionLabel.text = self.taskObject.description;
    
    if (self.taskObject.completion)
        self.completeTaskButton.hidden = YES;
    else
        self.completeTaskButton.hidden = NO;
    
    //Define the dateformatter for the overduedate
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm"];
    
    self.taskOverdueDateLabel.text = [dateFormat stringFromDate:self.taskObject.date];
    
    [self.taskDetailDelegate didUpdateTaskDetail:taskObject and:self.row];
}
@end
