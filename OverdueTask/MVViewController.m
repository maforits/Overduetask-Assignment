//
//  MVViewController.m
//  OverdueTask
//
//  Created by Mauro on 9/25/14.
//
//

#import "MVViewController.h"
#import "MVTaskObject.h"
#import "MVAddTaskViewController.h"
#import "MVTaskDetailViewController.h"
@interface MVViewController ()

@end

@implementation MVViewController

-(NSMutableArray *)addedTaskObjects
{
    if(!_addedTaskObjects){
        _addedTaskObjects = [[NSMutableArray alloc] init];
    }
    return _addedTaskObjects;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //Setting the delegate and datasource
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //Accesing NSUserDefaults
    NSArray *myTasksAsPropertyLists = [[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_TASK_OBJECTS_KEY];
    for (NSDictionary *dictionary in myTasksAsPropertyLists) {
        MVTaskObject *spaceObject =  [self taskObjectForDictionary:dictionary];
        [self.addedTaskObjects addObject:spaceObject];
    }
    
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
    
    if([segue.destinationViewController isKindOfClass:[MVAddTaskViewController class]])
    {
        MVAddTaskViewController *nextViewController = segue.destinationViewController;
        nextViewController.addTaskDelegate = self;
    }
    
    if([segue.destinationViewController isKindOfClass:[MVTaskDetailViewController class]])
    {
        MVTaskDetailViewController *nextViewController = segue.destinationViewController;
        NSIndexPath *indexPath = sender;
        nextViewController.taskObject = [self.addedTaskObjects objectAtIndex:indexPath.row];
        nextViewController.taskDetailDelegate = self;
        nextViewController.row = indexPath.row;
    }
}

- (IBAction)reorderButtonPressed:(UIBarButtonItem *)sender {
    //Switch editing mode of the tableview
    BOOL editingMode = self.tableView.editing;
    if (editingMode == YES)
        [self.tableView setEditing: NO];
    else
        [self.tableView setEditing: YES];
}

- (IBAction)addTaskButtonPressed:(UIBarButtonItem *)sender {
    //Call the segue
    [self performSegueWithIdentifier:@"toAddTaskViewController" sender:sender];
}
#pragma mark - MVAddTaskViewController Delegate

-(void)didCancel
{
    //Return to the previous Controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didAddTask:(MVTaskObject *)taskObject
{
    //Add the user object to the array of users
    [self.addedTaskObjects addObject:taskObject];
    
    //Save the new user to the NSUserDefaults dictionary
    
    NSMutableArray *taskObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_TASK_OBJECTS_KEY] mutableCopy];
    if(!taskObjectsAsPropertyLists)
        taskObjectsAsPropertyLists = [[NSMutableArray alloc] init];
    
    [taskObjectsAsPropertyLists addObject:[self taskObjectAsAPropertyList:taskObject]];
    [[NSUserDefaults standardUserDefaults] setObject:taskObjectsAsPropertyLists forKey:ADDED_TASK_OBJECTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Task" message:@"Task created succesfully!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - MVTaskDetaillViewController Delegate

-(void)didUpdateTaskDetail:(MVTaskObject *)taskObject and:(int)row
{
    [self updateTask:taskObject and:row];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Task Update" message:@"Task updated succesfully!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void)didCompleteTask:(MVTaskObject *)taskObject and:(int)row
{
    [self completeTask:taskObject and:row];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Task Complete" message:@"Task completed succesfully!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    
    //Only one section with the task's list
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.addedTaskObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"taskCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    //Use new task object to customize the cell
    MVTaskObject *task = [self.addedTaskObjects objectAtIndex:indexPath.row];
    cell.textLabel.text = task.title;
    
    //Configure the date format
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm"];
    
    cell.detailTextLabel.text = [dateFormat stringFromDate:task.date];
    
    //Configure the cell colors and image depending of the task date and status
    NSDate *currentDate = [NSDate date];
    NSString *strDate = [dateFormat stringFromDate:currentDate];
    BOOL isCompleted = task.completion;
    
    if(isCompleted){
//        cell.backgroundColor = [UIColor greenColor];
        cell.imageView.image = [UIImage imageNamed:@"check.png"];
    }else{
        if([self isDateGreaterThanDate:task.date and:[dateFormat dateFromString:strDate]]==YES){
//            cell.backgroundColor = [UIColor yellowColor];
            cell.imageView.image = [UIImage imageNamed:@"todo.png"];
        }else{
//            cell.backgroundColor = [UIColor redColor];
            cell.imageView.image = [UIImage imageNamed:@"Icon-warning.png"];
        }
    }
    
    //Customize the appearance of the cell
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    
    return  cell;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    //Define a temp array and vars
    NSMutableArray *orderedTaskObjects = [self.addedTaskObjects mutableCopy];
    int fromIndex = sourceIndexPath.row;
    int toIndex = destinationIndexPath.row;

    MVTaskObject *movedTask = [orderedTaskObjects objectAtIndex:fromIndex];
    
    //Remove the task at fromIndex
    [orderedTaskObjects removeObjectAtIndex:fromIndex];
    
    //Reinsert the task at toIndex
    [orderedTaskObjects insertObject:movedTask atIndex:toIndex];
    
    //Persist the array
    [self saveTasks:orderedTaskObjects];
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MVTaskObject *taskSelected = self.addedTaskObjects[indexPath.row];
    [self updateCompletionOfTask:taskSelected forIndexPath:indexPath];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self deleteTask:indexPath];
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toTaskDetailViewController" sender:indexPath];
}
#pragma mark - Helper Methods
-(NSDictionary *)taskObjectAsAPropertyList:(MVTaskObject *)taskObject
{
    //Define the dateformatter for the overduedate
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm"];
    
    NSDictionary *dictionary = @{TASK_TITLE : taskObject.title, TASK_DESCRIPTION : taskObject.description, TASK_OVERDUEDATE : taskObject.date, TASK_COMPLETION : @(taskObject.completion)};
    return dictionary;
}

-(MVTaskObject *)taskObjectForDictionary:(NSDictionary *)dictionary
{
    MVTaskObject *taskObject = [[MVTaskObject alloc] initWithData:dictionary];
    return taskObject;
}

- (BOOL) isDateGreaterThanDate:(NSDate *)date and:(NSDate *)toDate
{
    BOOL isGreater = NO;
    NSComparisonResult result = [date compare:toDate];
    if (result == NSOrderedDescending){
        //date is greater than today
        isGreater = YES;
    }
    return isGreater;
}

- (void) updateCompletionOfTask:(MVTaskObject *)task forIndexPath:(NSIndexPath *) indexPath
{
    //Update the task completion status
    if (task.completion == YES) {
        task.completion = NO;
    }else{
        task.completion = YES;
    }
    
    //Remove and add again the task from NSUserDefaults and the NSMutableArray
    NSMutableArray *taskObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_TASK_OBJECTS_KEY] mutableCopy];
    
    [taskObjectsAsPropertyLists removeObjectAtIndex:indexPath.row];
    [taskObjectsAsPropertyLists addObject:[self taskObjectAsAPropertyList:task]];
    [[NSUserDefaults standardUserDefaults] setObject:taskObjectsAsPropertyLists forKey:ADDED_TASK_OBJECTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.addedTaskObjects removeObjectAtIndex:indexPath.row];
    [self.addedTaskObjects addObject:task];
    [self.tableView reloadData];
}

- (void) deleteTask:(NSIndexPath *) indexPath
{
    //Remove the task from NSUserDefaults and the NSMutableArray
    NSMutableArray *taskObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_TASK_OBJECTS_KEY] mutableCopy];
    
    [taskObjectsAsPropertyLists removeObjectAtIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:taskObjectsAsPropertyLists forKey:ADDED_TASK_OBJECTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.addedTaskObjects removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}

- (void) updateTask:(MVTaskObject *)task and:(int) row
{
    //Remove and add again the updated task from NSUserDefaults and the NSMutableArray
    NSMutableArray *taskObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_TASK_OBJECTS_KEY] mutableCopy];
    
    [taskObjectsAsPropertyLists removeObjectAtIndex:row];
    [taskObjectsAsPropertyLists addObject:[self taskObjectAsAPropertyList:task]];
    [[NSUserDefaults standardUserDefaults] setObject:taskObjectsAsPropertyLists forKey:ADDED_TASK_OBJECTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.addedTaskObjects removeObjectAtIndex:row];
    [self.addedTaskObjects addObject:task];
    [self.tableView reloadData];
}

- (void) completeTask:(MVTaskObject *)task and:(int) row
{
    //Complete the task
    task.completion = YES;
    
    //Remove and add again the updated task from NSUserDefaults and the NSMutableArray
    NSMutableArray *taskObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_TASK_OBJECTS_KEY] mutableCopy];
    
    [taskObjectsAsPropertyLists removeObjectAtIndex:row];
    [taskObjectsAsPropertyLists addObject:[self taskObjectAsAPropertyList:task]];
    [[NSUserDefaults standardUserDefaults] setObject:taskObjectsAsPropertyLists forKey:ADDED_TASK_OBJECTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.addedTaskObjects removeObjectAtIndex:row];
    [self.addedTaskObjects addObject:task];
    [self.tableView reloadData];
}

- (void) saveTasks:(NSMutableArray *)taskObjects
{
    NSMutableArray *updatedTasks = [[NSMutableArray alloc] init];
    for (MVTaskObject *task in taskObjects) {
        NSDictionary *currentTask = [self taskObjectAsAPropertyList:task];
        [updatedTasks addObject:currentTask];
    }

    [[NSUserDefaults standardUserDefaults] setObject:updatedTasks forKey:ADDED_TASK_OBJECTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
