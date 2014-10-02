//
//  MVTaskObject.h
//  OverdueTask
//
//  Created by Mauro on 9/26/14.
//
//

#import <Foundation/Foundation.h>

@interface MVTaskObject : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSDate *date;
@property (nonatomic) BOOL completion;

-(id)initWithData:(NSDictionary *)data;

@end
