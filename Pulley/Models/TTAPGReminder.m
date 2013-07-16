//
//  TTAPGReminder.m
//  Progress
//
//  Created by Mike Bobiney on 7/4/13.
//  Copyright (c) 2013 Mike Bobiney. All rights reserved.
//

#import "TTAPGReminder.h"

@implementation TTAPGReminder

-(instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.identifier = [[NSUUID UUID] UUIDString];
        self.title = title;
        self.createDate = [NSDate date];
        self.completed = NO;
    }
    return self;
}

- (NSComparisonResult)compare:(TTAPGReminder *)otherObject {
    return [self.createDate compare:otherObject.createDate];
}

-(BOOL)isEqual:(TTAPGReminder *)object
{
    return [object.identifier isEqualToString:self.identifier];
}

-(NSUInteger)hash
{
    return [self.identifier hash];
}

@end
