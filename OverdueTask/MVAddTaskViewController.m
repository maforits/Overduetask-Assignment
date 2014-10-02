//
//  MVAddTaskViewController.m
//  OverdueTask
//
//  Created by Mauro on 9/25/14.
//
//

#import "MVAddTaskViewController.h"

@interface MVAddTaskViewController ()

@end

@implementation MVAddTaskViewController

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
    
    //Set up the delegates
    self.taskDescription.delegate = self;
    self.taskTitle.delegate = self;
    
    //Datepicker properties
    self.taskOverdueDate.backgroundColor = [UIColor whiteColor];
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

- (IBAction)addTaskButtonPressed:(UIButton *)sender {
    //Get the task information from textFields
    NSString *title = self.taskTitle.text;
    NSString *description = self.taskDescription.text;
    NSDate *overdueDate = self.taskOverdueDate.date;
    NSString *mensaje;
    //Alert the user of possible errors
    if (title.length == 0 || description.length == 0 || overdueDate == nil) {
        mensaje = @"Fields are required";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:mensaje delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else{
        //Add the task using the method didAddTask
        MVTaskObject *taskObject = [[MVTaskObject alloc] init];
        taskObject.title = title;
        taskObject.description = description;
        taskObject.date = overdueDate;
        taskObject.completion = NO;
        
        [self.addTaskDelegate didAddTask:taskObject];
    }
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [self.addTaskDelegate didCancel];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]){
        [self.taskDescription resignFirstResponder];
        return NO;
    }else{
        return YES;
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@"\n"]){
        [self.taskTitle resignFirstResponder];
        return NO;
    }else{
        return YES;
    }
}
@end
