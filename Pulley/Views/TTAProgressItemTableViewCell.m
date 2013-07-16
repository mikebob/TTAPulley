//
//  TTAProgressItemTableViewCell.m
//  Progress
//
//  Created by Mike Bobiney on 6/29/13.
//  Copyright (c) 2013 Mike Bobiney. All rights reserved.
//

#import "TTAProgressItemTableViewCell.h"
#import "TTAFilePersistantStore.h"

#define LEFT_SWIPE_THRESHOLD 50.0f

@implementation TTAProgressItemTableViewCell

-(void)awakeFromNib
{
    _scrollview.delegate = self;
    _title.textColor = [UIColor whiteColor];
    _vwDeleteIndicator.alpha = 0;
}

-(void)setDataItem:(TTAPGReminder *)dataItem
{
    _dataItem = dataItem;
    self.title.text = _dataItem.title;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _scrollview.scrollEnabled = NO;
    if([self.delegate respondsToSelector:@selector(itemTableViewCell:beganEditingatIndex:)]) {
        [self.delegate itemTableViewCell:self beganEditingatIndex:_dataIndex];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    _scrollview.scrollEnabled = YES;
    if([self.delegate respondsToSelector:@selector(itemTableViewCell:finishedEditingAtIndex:)]) {
        [self.delegate itemTableViewCell:self finishedEditingAtIndex:_dataIndex];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint pt = scrollView.contentOffset;
    if(scrollView.isDecelerating == NO) {
        _vwDeleteIndicator.alpha = (pt.x > LEFT_SWIPE_THRESHOLD * 0.4f) ? pt.x/LEFT_SWIPE_THRESHOLD : 0;
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{    
    CGPoint pt = scrollView.contentOffset;
    if(pt.x > 50) {
        [self remove];
    } else if (pt.x < -50) {
        [self complete];
    }
}

-(void)complete
{
    if([self.delegate respondsToSelector:@selector(itemTableViewCell:completeItemAtIndex:)]) {
        [self.delegate itemTableViewCell:self completeItemAtIndex:_dataIndex];
    }
}

-(void)remove
{
    if([self.delegate respondsToSelector:@selector(itemTableViewCell:didDeleteAtIndex:)]) {
        [UIView animateWithDuration:0.3f animations:^{
            _scrollview.transform = CGAffineTransformMakeTranslation(-1000.0f, 0);
        } completion:^(BOOL finished) {
            [_scrollview setContentOffset:CGPointZero animated:NO];
            [self.delegate itemTableViewCell:self didDeleteAtIndex:_dataIndex];
            _scrollview.transform = CGAffineTransformIdentity;
        }];
    }
}

@end
