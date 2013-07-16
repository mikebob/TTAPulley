//
//  TTAFilePersistantStore.h
//  Progress
//
//  Created by Mike Bobiney on 6/29/13.
//  Copyright (c) 2013 Mike Bobiney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTAPGReminder.h"

@interface TTAFilePersistantStore : NSObject

+ (TTAFilePersistantStore *)sharedStore;
- (NSArray *)loadData;
-(BOOL)writeData:(NSArray *)arr;

@end
