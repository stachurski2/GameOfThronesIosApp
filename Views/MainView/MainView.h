#import <UIKit/UIKit.h>
#import "MainLeftMenu.h"
#import "Masonry.h"

@interface MainView : UIView

@property UIButton *clearButton;

@property UIButton *menuButton;

@property UIView *topBar;

@property UITextField *textField;

@property UITableView *tableView;

@property BOOL leftMenuVisible;

@property MainLeftMenu *menu;

-(void)menuShowing;

@end

