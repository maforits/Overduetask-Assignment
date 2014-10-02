//
//  MVTaskObject.m
//  OverdueTask
//
//  Created by Mauro on 9/26/14.
//
//

#import "MVTaskObject.h"

@implementation MVTaskObject

-(id)init
{
    self = [self initWithData:nil];
    return self;
}

-(id)initWithData:(NSDictionary *)data
{
    self = [super init];
    self.title = data[TASK_TITLE];
    self.description = data[TASK_DESCRIPTION];
    self.date = data[TASK_OVERDUEDATE];
    self.completion = [data[TASK_COMPLETION] boolValue];
    return self;
}

@end
