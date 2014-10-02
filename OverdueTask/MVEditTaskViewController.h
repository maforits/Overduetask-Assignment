//
//  MVEditTaskViewController.h
//  OverdueTask
//
//  Created by Mauro on 9/25/14.
//
//

#import <UIKit/UIKit.h>
#import "MVTaskObject.h"
@protocol MVEditTaskViewControllerDelegate <NSObject>

@required

- (void) didUpdateTask:(MVTaskObject *)taskObject;

@end

@interface MVEditTaskViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak,nonatomic) id <MVEditTaskViewControllerDelegate>editTaskDelegate;

@property (strong, nonatomic) IBOutlet UITextField *editTaskTitle;
@property (strong, nonatomic) IBOutlet UITextView *editTaskDescription;
@property (strong, nonatomic) IBOutlet UIDatePicker *editTaskOverdueDate;

@property (strong, nonatomic) IBOutlet UIPickerView *editTaskCompletion;

@property (strong, nonatomic) MVTaskObject *taskObject;
@property (nonatomic) int row;

- (IBAction)saveTaskButtonPressed:(UIBarButtonItem *)sender;

@end
