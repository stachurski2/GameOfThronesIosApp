#import "MainView.h"


@implementation MainView


const double kBarHeightPercent = 0.1;
const int stanadardMargin = 25;
const int standardSize = 50;
const int leftMenuWitdh = 250;

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.topBar = [[UIView new]initWithFrame:CGRectZero];
    self.clearButton = [[UIButton alloc]initWithFrame:CGRectZero];
    self.textField = [[UITextField new]initWithFrame:CGRectZero];
    self.tableView = [[UITableView new]initWithFrame:CGRectZero];
    self.menuButton = [[UIButton alloc]initWithFrame:CGRectZero];
    self.menu = [[MainLeftMenu new]initWithFrame:CGRectZero];
    self.leftMenuVisible = false;
    [self setUpView];
    [self setUpConstraints];
    return self;
}

-(void)setUpView {
    _topBar.backgroundColor = UIColor.redColor;
    [self addSubview:self.topBar];
    [self.topBar addSubview: self.clearButton];
    [self.topBar addSubview: self.menuButton];
    self.clearButton.tintColor = UIColor.whiteColor;
    [self.clearButton setImage: [UIImage imageNamed:@"close"] forState:(UIControlStateNormal)];
    [self.menuButton setImage: [UIImage imageNamed:@"HamburgerMenu"] forState:(UIControlStateNormal)];
    [self addSubview:self.tableView];
    [self addSubview:self.menu];
    self.menu.backgroundColor = UIColor.redColor;
}

-(void)setUpConstraints{
    [self.topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(self).multipliedBy(kBarHeightPercent);
    }];
    [self.topBar sizeToFit];
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topBar).inset(10);
        make.bottom.equalTo(self.topBar).inset(15);
        make.width.offset(standardSize / 2.4);
        make.height.offset((standardSize * 0.4) );
    }];
    [self.menuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topBar).offset(10);
        make.bottom.equalTo(self.topBar).inset(15);
        make.width.offset(standardSize / 2);
        make.height.offset(standardSize * 0.4);
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBar.mas_bottom);
        make.right.left.bottom.equalTo(self);
    }];
    
    [self.menu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_top).multipliedBy(1-kBarHeightPercent);
        make.width.equalTo(self);
        make.height.equalTo(self);
    }];
    [_clearButton sizeToFit];
    [_menuButton sizeToFit];
}



-(void)menuShowing {
   {
        [UIView animateWithDuration:(0.8) animations:^{
            if (self.leftMenuVisible == true){
                [self hideMenu];
            }
            else {
                [self showMenu];
            }
        } completion:^(BOOL finished) {
             self->_leftMenuVisible = !(self -> _leftMenuVisible);
        }];
    }
}

-(void)showMenu {
    CGAffineTransform totalTransform = CGAffineTransformMakeTranslation(0, self.frame.size.height*(1+kBarHeightPercent));
    [self.menu setTransform:totalTransform];
}

-(void)hideMenu {
    CGAffineTransform totalTransform = CGAffineTransformIdentity;
    [self.menu setTransform:totalTransform];
    
}


@end
