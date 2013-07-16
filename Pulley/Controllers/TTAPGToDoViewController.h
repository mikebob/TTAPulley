//
//  TTAPGToDoViewController.h
//  Progress
//
//  Created by Mike Bobiney on 6/30/13.
//  Copyright (c) 2013 Mike Bobiney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTAProgressItemTableViewCell.h"
#import "TTAKeyboardHandler.h"

@interface TTAPGToDoViewController : UIViewController<UITableViewDelegate, UITextFieldDelegate, TTAKeyboardHandlerDelegate, TTAProgressItemTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)tableview_tapped:(id)sender;

@end
