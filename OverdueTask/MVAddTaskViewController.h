//
//  MVAddTaskViewController.h
//  OverdueTask
//
//  Created by Mauro on 9/25/14.
//
//

#import <UIKit/UIKit.h>
#import "MVTaskObject.h"
@protocol MVAddTaskViewControllerDelegate <NSObject>

@required

- (void) didCancel;
- (void) didAddTask:(MVTaskObject *)taskObject;

@end

@interface MVAddTaskViewController : UIViewController <UITextViewDelegate,UITextFieldDelegate>

@property (weak,nonatomic) id <MVAddTaskViewControllerDelegate>addTaskDelegate;

@property (strong, nonatomic) IBOutlet UITextField *taskTitle;
@property (strong, nonatomic) IBOutlet UITextView *taskDescription;
@property (strong, nonatomic) IBOutlet UIDatePicker *taskOverdueDate;
- (IBAction)addTaskButtonPressed:(UIButton *)sender;
- (IBAction)cancelButtonPressed:(UIButton *)sender;
@end
