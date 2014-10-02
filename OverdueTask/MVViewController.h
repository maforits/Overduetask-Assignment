//
//  MVViewController.h
//  OverdueTask
//
//  Created by Mauro on 9/25/14.
//
//

#import <UIKit/UIKit.h>
#import "MVAddTaskViewController.h"
#import "MVTaskDetailViewController.h"
@interface MVViewController : UIViewController <MVAddTaskViewControllerDelegate,UITableViewDataSource, UITableViewDelegate,MVTaskDetaillViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *addedTaskObjects;

- (IBAction)reorderButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)addTaskButtonPressed:(UIBarButtonItem *)sender;
@end
