//
//  TTAProgressItemTableViewCell.h
//  Progress
//
//  Created by Mike Bobiney on 6/29/13.
//  Copyright (c) 2013 Mike Bobiney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTAPGReminder.h"

@class TTAProgressItemTableViewCell;

@protocol TTAProgressItemTableViewCellDelegate <NSObject>
-(void)itemTableViewCell:(TTAProgressItemTableViewCell *)cell didDeleteAtIndex:(NSInteger)index;
-(void)itemTableViewCell:(TTAProgressItemTableViewCell *)cell finishedEditingAtIndex:(NSUInteger)index;
-(void)itemTableViewCell:(TTAProgressItemTableViewCell *)cell beganEditingatIndex:(NSInteger)index;
-(void)itemTableViewCell:(TTAProgressItemTableViewCell *)cell completeItemAtIndex:(NSInteger)index;
@end

@interface TTAProgressItemTableViewCell : UITableViewCell<UITextFieldDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UITextField *title;
@property (weak, nonatomic) IBOutlet UIView *vwPrimary;
@property (weak, nonatomic) IBOutlet UIView *vwDeleteIndicator;
@property (strong, nonatomic) TTAPGReminder *dataItem;
@property (assign, nonatomic) NSUInteger dataIndex;
@property (weak) id<TTAProgressItemTableViewCellDelegate> delegate;

- (void)remove;
@end
