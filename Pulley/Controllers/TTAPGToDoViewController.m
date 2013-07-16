//
//  TTAPGToDoViewController.m
//  Progress
//
//  Created by Mike Bobiney on 6/30/13.
//  Copyright (c) 2013 Mike Bobiney. All rights reserved.
//

#import "TTAPGToDoViewController.h"
#import "TTAFilePersistantStore.h"

#define kCellHeight 75.0f

@interface TTAPGToDoViewController ()
@property (nonatomic, strong) UIView *newRowView;
@end

@implementation TTAPGToDoViewController {
    NSMutableOrderedSet *todos;
    TTAKeyboardHandler *keyboard;
    BOOL isNewCellDragging;
    UILabel *pullLabelHint;
}

static NSString *cellIdentifier = @"todoItemCell";

-(UIView *)newRowView
{
    if (nil == _newRowView) {
        _newRowView = [[UIView alloc] initWithFrame:CGRectMake(0, -kCellHeight, _tableView.frame.size.width, kCellHeight)];
        _newRowView.backgroundColor = [UIColor lightGrayColor];

        pullLabelHint = [UILabel new];
        [pullLabelHint setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20.0f]];
        [pullLabelHint setFrame:CGRectInset(_newRowView.bounds, 0, 20.0f)];
        [pullLabelHint setTextAlignment:NSTextAlignmentCenter];
        [pullLabelHint setBackgroundColor:[UIColor clearColor]];

        [pullLabelHint setTextColor:[UIColor whiteColor]];
        [_newRowView addSubview:pullLabelHint];
    }
    return _newRowView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([TTAProgressItemTableViewCell class]) bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"todoItemCell"];
    
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = [UIColor blackColor];
    
    keyboard = [TTAKeyboardHandler new];
    keyboard.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self reloadTodos];
}

#pragma mark - TTAKeyboardHandlerDelegate -

-(void)keyboardSizeChanged:(CGSize)delta
{
    CGRect f = _tableView.frame;
    f.size.height -= delta.height;
    f.size.height += (delta.height>0) ? 48.0f : -48.0f;  // adjust for tabbar height
    _tableView.frame = f;
    
}

#pragma mark - TableViewDelegate -

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTAProgressItemTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    TTAPGReminder *item = todos[indexPath.row];
    [cell setDataItem:item];
    [cell setDataIndex:indexPath.row];
    [cell setDelegate:self];
    cell.vwPrimary.backgroundColor =
            item.isCompleted ?
            [UIColor colorWithRed:0 green:1.0f blue:0 alpha:0.6f] :
            [UIColor colorWithWhite:1.0f alpha:0.3f];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return todos.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = _tableView.contentOffset.y;
 
    if(offset < 0 && CGRectIsEmpty(keyboard.frame)) {
        if(isNewCellDragging == NO) {
            [_tableView addSubview:self.newRowView];
            isNewCellDragging = YES;
        } else if(offset < -kCellHeight) {
            pullLabelHint.text = @"Release";
        } else {
            pullLabelHint.text = @"Pull to add";
        }
        _newRowView.alpha = -(offset/kCellHeight);
    }
}

#pragma mark - ItemTableViewDelegate -

-(void)itemTableViewCell:(TTAProgressItemTableViewCell *)cell didDeleteAtIndex:(NSInteger)index
{
    [todos removeObject:cell.dataItem];
    [[TTAFilePersistantStore sharedStore] writeData:[todos array]];
    [self reloadTodos];
}

-(void)itemTableViewCell:(TTAProgressItemTableViewCell *)cell beganEditingatIndex:(NSInteger)index
{
    CGRect rc = [cell bounds];
    rc = [cell convertRect:rc toView:_tableView];
    
    if(index >= 4) {
        CGPoint pt = rc.origin;
        pt.x = 0;
        pt.y -= 160;
        [_tableView setContentOffset:pt animated:YES];
    }
    
    _tableView.scrollEnabled = NO;
}

-(void)itemTableViewCell:(TTAProgressItemTableViewCell *)cell finishedEditingAtIndex:(NSUInteger)index
{    
    if([todos count]) {
        TTAPGReminder *r = todos[index];
        if(cell.title.text.length == 0) {
            [cell remove];
        } else if([r.title isEqualToString:cell.title.text] == NO) {
            r.title = cell.title.text;
            [[TTAFilePersistantStore sharedStore] writeData:[todos array]];
        }
    }
    [self.view endEditing:YES];
    _tableView.scrollEnabled = YES;
}

-(void)itemTableViewCell:(TTAProgressItemTableViewCell *)cell completeItemAtIndex:(NSInteger)index
{
    cell.dataItem.completed = !cell.dataItem.isCompleted;;
    [[TTAFilePersistantStore sharedStore] writeData:[todos array]];
    [_tableView reloadData];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{    
    isNewCellDragging = NO;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y < -kCellHeight) {
        [_newRowView removeFromSuperview];
        [self addNewToDoItemRow];

        TTAProgressItemTableViewCell *cell = [_tableView visibleCells][0];
        [cell.title becomeFirstResponder];
    }
}

-(void)addNewToDoItemRow
{
    //Save the tableview content offset
    CGPoint tableViewOffset = [self.tableView contentOffset];
    
    //Turn off animations for the update block
    //to get the effect of adding rows on top of TableView
    [UIView setAnimationsEnabled:NO];
    
    [self.tableView beginUpdates];
    
    NSMutableArray *rowsInsertIndexPath = [NSMutableArray new];

    TTAPGReminder *newReminder = [[TTAPGReminder alloc] initWithTitle:@""];
    [todos insertObject:newReminder atIndex:0];

    [[TTAFilePersistantStore sharedStore] writeData:[todos array]];

    NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [rowsInsertIndexPath addObject:tempIndexPath];

    CGFloat heightForNewRows = 0;
    heightForNewRows = [self heightForCellAtIndexPath:tempIndexPath];
    tableViewOffset.y += heightForNewRows;

    [self.tableView insertRowsAtIndexPaths:rowsInsertIndexPath withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];

    [UIView setAnimationsEnabled:YES];

    [self.tableView setContentOffset:tableViewOffset animated:NO];
}


-(CGFloat) heightForCellAtIndexPath: (NSIndexPath *) indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    CGFloat cellHeight = cell.frame.size.height;
    return cellHeight;
}

- (void)reloadTodos
{
    NSArray *arr = [[TTAFilePersistantStore sharedStore] loadData];
    todos = [[NSMutableOrderedSet orderedSetWithArray:arr] mutableCopy];
    [_tableView reloadData];
}

- (IBAction)tableview_tapped:(id)sender
{
    [self.view endEditing:YES];
    [[TTAFilePersistantStore sharedStore] writeData:[todos array]];
}

@end
