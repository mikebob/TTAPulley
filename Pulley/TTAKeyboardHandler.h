//
//  GMKeyboardHandler.h
//  MobileWorkbenchPhone
//
//  Created by Mike Bobiney on 2/2/13.
//  Copyright (c) 2013 General Motors. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TTAKeyboardHandlerDelegate
- (void)keyboardSizeChanged:(CGSize)delta;
@end

@interface TTAKeyboardHandler : NSObject

@property(nonatomic, weak) id<TTAKeyboardHandlerDelegate> delegate;
@property(nonatomic) CGRect frame;

@end
