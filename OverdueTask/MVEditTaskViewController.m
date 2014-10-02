//
//  MVEditTaskViewController.m
//  OverdueTask
//
//  Created by Mauro on 9/25/14.
//
//

#import "MVEditTaskViewController.h"

@interface MVEditTaskViewController (){
    NSArray *_pickerData;
}

@end

@implementation MVEditTaskViewController

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
    self.editTaskTitle.text = self.taskObject.title;
    self.editTaskDescription.text = self.taskObject.description;
    
    //Define the dateformatter for the overduedate
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm"];
    
    self.editTaskOverdueDate.date = self.taskObject.date;
    
    //Set up the delegates
    self.editTaskDescription.delegate = self;
    self.editTaskTitle.delegate = self;
    
    //Datepicker properties
    _pickerData = @[@"YES",@"NO"];
    self.editTaskOverdueDate.backgroundColor = [UIColor whiteColor];
    
    //Picker properties
    self.editTaskCompletion.backgroundColor = [UIColor whiteColor];
    self.editTaskCompletion.delegate = self;
    self.editTaskCompletion.dataSource = self;
    
    //Set the value of the task completion
    NSString *taskCompletion = self.taskObject.completion ? @"YES" : @"NO";
    
    [self.editTaskCompletion selectRow:[_pickerData indexOfObject:taskCompletion] inComponent:0 animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPickerViewDatasource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)saveTaskButtonPressed:(UIBarButtonItem *)sender {
    //Update the task object
    NSString *title = self.editTaskTitle.text;
    NSString *description = self.editTaskDescription.text;
    NSDate *overdueDate = self.editTaskOverdueDate.date;
    NSString *selectedCompletion = [_pickerData objectAtIndex:[self.editTaskCompletion selectedRowInComponent:0]];
    
    BOOL completion = [selectedCompletion boolValue];
    
    self.taskObject.title = title;
    self.taskObject.description = description;
    self.taskObject.date = overdueDate;
    self.taskObject.completion = completion;
    
    [self.editTaskDelegate didUpdateTask:self.taskObject];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]){
        [self.editTaskDescription resignFirstResponder];
        return NO;
    }else{
        return YES;
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@"\n"]){
        [self.editTaskTitle resignFirstResponder];
        return NO;
    }else{
        return YES;
    }
}
@end
