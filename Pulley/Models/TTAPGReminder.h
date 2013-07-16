//
//  TTAPGReminder.h
//  Progress
//
//  Created by Mike Bobiney on 7/4/13.
//  Copyright (c) 2013 Mike Bobiney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface TTAPGReminder : MTLModel

@property(nonatomic, copy) NSString *identifier;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, assign, getter = isCompleted) BOOL completed;
@property(nonatomic, strong) NSDate *createDate;

-(id)initWithTitle:(NSString *)title;

@end
