//
//  TTAFilePersistantStore.m
//  Progress
//
//  Created by Mike Bobiney on 6/29/13.
//  Copyright (c) 2013 Mike Bobiney. All rights reserved.
//

#import "TTAFilePersistantStore.h"

#define FILENAME @"todos"

@implementation TTAFilePersistantStore {
    NSMutableArray *actionItems;
}

static NSString *destPath;
+(NSString *)destPath
{
    return destPath;
}

+ (TTAFilePersistantStore *)sharedStore
{
    static dispatch_once_t onceToken;
    static TTAFilePersistantStore *sharedStore = nil;
    dispatch_once(&onceToken, ^{
        sharedStore = [self new];
        destPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        destPath = [destPath stringByAppendingPathComponent:[FILENAME stringByAppendingString:@".plist"]];
    });
    return sharedStore;
}

-(NSArray *)loadData
{
    NSArray *arr = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:destPath] == NO) {
        NSLog(@"Cannot load file, does not exist");
        return @[];
    }

    arr = [NSKeyedUnarchiver unarchiveObjectWithFile:[TTAFilePersistantStore destPath]];
    
    return arr;
}

-(BOOL)writeData:(NSArray *)arr
{
    return [NSKeyedArchiver archiveRootObject:arr toFile:[TTAFilePersistantStore destPath]];
}

@end
