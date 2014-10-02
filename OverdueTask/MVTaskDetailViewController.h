//
//  MVTaskDetailViewController.h
//  OverdueTask
//
//  Created by Mauro on 9/25/14.
//
//

#import <UIKit/UIKit.h>
#import "MVTaskObject.h"
#import "MVEditTaskViewController.h"
@protocol MVTaskDetaillViewControllerDelegate <NSObject>

@required

- (void) didUpdateTaskDetail:(MVTaskObject *)taskObject and: (int)row;
- (void) didCompleteTask:(MVTaskObject *)taskObject and: (int)row;

@end

@interface MVTaskDetailViewController : UIViewController<MVEditTaskViewControllerDelegate>

@property (weak,nonatomic) id <MVTaskDetaillViewControllerDelegate>taskDetailDelegate;

@property (strong, nonatomic) IBOutlet UILabel *taskTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskOverdueDateLabel;
@property (strong, nonatomic) IBOutlet UIButton *completeTaskButton;

@property (strong, nonatomic) MVTaskObject *taskObject;
@property (nonatomic) int row;
- (IBAction)editTaskButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)completeTaskButtonPressed:(UIButton *)sender;

@end
